# ============================================================
# TestHub 一键启动脚本 (PowerShell)
# 用法: .\start.ps1 [-SkipChecks] [-Port <frontend_port>]
# ============================================================

param(
    [switch]$SkipChecks,
    [int]$Port = 3000
)

$ErrorActionPreference = "Stop"
$ProjectRoot = $PSScriptRoot
$BackendPort = 8000

# ── 颜色输出 ──────────────────────────────────────────────
function Write-Step   { param($msg) Write-Host "`n>> $msg" -ForegroundColor Cyan }
function Write-OK     { param($msg) Write-Host "   [OK] $msg" -ForegroundColor Green }
function Write-Warn   { param($msg) Write-Host "   [WARN] $msg" -ForegroundColor Yellow }
function Write-Err    { param($msg) Write-Host "   [ERROR] $msg" -ForegroundColor Red }
function Write-Info   { param($msg) Write-Host "   $msg" -ForegroundColor Gray }

# ── 清理函数：停止所有子进程 ──────────────────────────────
$script:BackendJob = $null
$script:FrontendJob = $null

function Stop-All {
    Write-Step "正在停止所有服务..."
    if ($script:BackendJob) {
        Stop-Job -Id $script:BackendJob.Id -ErrorAction SilentlyContinue
        Remove-Job -Id $script:BackendJob.Id -Force -ErrorAction SilentlyContinue
        Write-OK "后端服务已停止"
    }
    if ($script:FrontendJob) {
        Stop-Job -Id $script:FrontendJob.Id -ErrorAction SilentlyContinue
        Remove-Job -Id $script:FrontendJob.Id -Force -ErrorAction SilentlyContinue
        Write-OK "前端服务已停止"
    }
    # 清理可能残留的属于本项目的 python 进程
    Get-Process -Name "python" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like "*runserver*$BackendPort*" } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "`n所有服务已停止。" -ForegroundColor Green
}

# ── 检查端口是否被占用 ────────────────────────────────────
function Test-Port {
    param([int]$PortNumber)
    try {
        $conn = Get-NetTCPConnection -LocalPort $PortNumber -ErrorAction SilentlyContinue
        return ($null -ne $conn)
    } catch {
        return $false
    }
}

# ── 主流程 ────────────────────────────────────────────────
Write-Host ""
Write-Host "  =======================================" -ForegroundColor Cyan
Write-Host "   TestHub - AI 一体化测试平台 启动脚本" -ForegroundColor Cyan
Write-Host "  =======================================`n" -ForegroundColor Cyan

# ── 步骤 1: 检查前置条件 ──────────────────────────────────
if (-not $SkipChecks) {
    Write-Step "检查前置条件..."

    # Python
    try {
        $pyVer = python --version 2>&1
        Write-OK "Python: $pyVer"
    } catch {
        Write-Err "Python 未安装或不在 PATH 中"
        exit 1
    }

    # Node.js
    try {
        $nodeVer = node --version 2>&1
        Write-OK "Node.js: $nodeVer"
    } catch {
        Write-Err "Node.js 未安装或不在 PATH 中"
        exit 1
    }

    # .env 文件
    if (-not (Test-Path "$ProjectRoot\.env")) {
        Write-Err ".env 文件不存在，请先创建 .env 配置文件"
        Write-Info "可复制 .env.example 并修改: copy .env.example .env"
        exit 1
    }
    Write-OK ".env 配置文件存在"

    # MySQL 连接检查
    $mysqlPaths = @(
        "C:\Program Files\MySQL\MySQL Server 9.6\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysql.exe",
        "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe",
        "mysql"
    )
    $mysqlBin = $null
    foreach ($p in $mysqlPaths) {
        if ((Get-Command $p -ErrorAction SilentlyContinue) -or (Test-Path $p -ErrorAction SilentlyContinue)) {
            $mysqlBin = $p
            break
        }
    }
    if ($mysqlBin) {
        # 从 .env 读取数据库密码
        $dbPassword = ""
        $envContent = Get-Content "$ProjectRoot\.env" -ErrorAction SilentlyContinue
        $pwdLine = $envContent | Where-Object { $_ -match "^DB_PASSWORD=(.*)" }
        if ($pwdLine) {
            $dbPassword = $Matches[1]
        }
        $testResult = & $mysqlBin -u root -p$dbPassword -e "SELECT 1" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-OK "MySQL 连接成功"
        } else {
            Write-Warn "MySQL 连接失败 (服务可能未启动)"
            Write-Info "请确保 MySQL 服务正在运行"
        }
    } else {
        Write-Warn "未找到 MySQL 客户端"
    }

    # node_modules 检查
    if (-not (Test-Path "$ProjectRoot\frontend\node_modules")) {
        Write-Warn "前端依赖未安装，正在安装..."
        Push-Location "$ProjectRoot\frontend"
        npm install
        Pop-Location
        Write-OK "前端依赖安装完成"
    } else {
        Write-OK "前端依赖已安装"
    }
}

# ── 步骤 2: 端口检查 ─────────────────────────────────────
Write-Step "检查端口..."

# 后端端口
if (Test-Port $BackendPort) {
    Write-Warn "端口 $BackendPort 已被占用，尝试关闭现有 Django 进程..."
    Get-Process -Name "python" -ErrorAction SilentlyContinue |
        Where-Object { $_.CommandLine -like "*runserver*" } |
        Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
    if (Test-Port $BackendPort) {
        Write-Err "端口 $BackendPort 仍被占用，请手动关闭占用进程"
        exit 1
    }
}
Write-OK "后端端口 $BackendPort 可用"

# 前端端口
$frontendPort = $Port
if (Test-Port $frontendPort) {
    Write-Warn "端口 $frontendPort 已被占用，Vite 将自动选择可用端口"
}

# ── 步骤 3: 数据库迁移检查 ───────────────────────────────
Write-Step "检查数据库迁移..."
Push-Location $ProjectRoot
$migrationOutput = python manage.py showmigrations --plan 2>&1 | Select-String "\[ \]" | Measure-Object
if ($migrationOutput.Count -gt 0) {
    Write-Info "发现 $($migrationOutput.Count) 个待执行迁移，正在执行..."
    python manage.py migrate 2>&1 | Out-Null
    Write-OK "数据库迁移完成"
} else {
    Write-OK "数据库已是最新"
}
Pop-Location

# ── 步骤 4: 启动后端 ─────────────────────────────────────
Write-Step "启动 Django 后端 (端口 $BackendPort)..."
$script:BackendJob = Start-Job -ScriptBlock {
    param($root, $port)
    Set-Location $root
    $env:DJANGO_SETTINGS_MODULE = "backend.settings"
    python manage.py runserver "0.0.0.0:$port" 2>&1
} -ArgumentList $ProjectRoot, $BackendPort

Start-Sleep -Seconds 3
if (Test-Port $BackendPort) {
    Write-OK "Django 后端启动成功 -> http://localhost:$BackendPort"
} else {
    Write-Warn "后端启动中，请稍候..."
    Start-Sleep -Seconds 3
    if (Test-Port $BackendPort) {
        Write-OK "Django 后端启动成功 -> http://localhost:$BackendPort"
    } else {
        Write-Err "后端启动失败，查看日志: Receive-Job -Id $($script:BackendJob.Id)"
    }
}

# ── 步骤 5: 启动前端 ─────────────────────────────────────
Write-Step "启动 Vue 前端 (端口 $frontendPort)..."
$script:FrontendJob = Start-Job -ScriptBlock {
    param($root)
    Set-Location "$root\frontend"
    npm run dev 2>&1
} -ArgumentList $ProjectRoot

Start-Sleep -Seconds 5
$frontendOutput = Receive-Job -Id $script:FrontendJob.Id -ErrorAction SilentlyContinue
$actualPort = $frontendPort
if ($frontendOutput -match "localhost:(\d+)") {
    $actualPort = $Matches[1]
}
Write-OK "Vue 前端启动成功 -> http://localhost:$actualPort"

# ── 步骤 6: 输出摘要 ─────────────────────────────────────
Write-Host ""
Write-Host "  =======================================" -ForegroundColor Green
Write-Host "   TestHub 启动完成!" -ForegroundColor Green
Write-Host "  =======================================" -ForegroundColor Green
Write-Host ""
Write-Host "   前端地址:     http://localhost:$actualPort" -ForegroundColor White
Write-Host "   后端 API:     http://localhost:$BackendPort/api/" -ForegroundColor White
Write-Host "   Django Admin: http://localhost:$BackendPort/admin/" -ForegroundColor White
Write-Host ""
Write-Host "   管理员账号:   admin" -ForegroundColor Yellow
Write-Host "   管理员密码:   admin123" -ForegroundColor Yellow
Write-Host ""
Write-Host "   按 Ctrl+C 停止所有服务" -ForegroundColor Gray
Write-Host ""

# ── 等待用户退出 ──────────────────────────────────────────
try {
    while ($true) {
        # 检查后端进程是否还活着
        if ($script:BackendJob -and $script:BackendJob.State -eq "Failed") {
            Write-Err "后端服务异常退出!"
            $output = Receive-Job -Id $script:BackendJob.Id
            Write-Host $output -ForegroundColor Red
            break
        }
        Start-Sleep -Seconds 2
    }
} finally {
    Stop-All
}
