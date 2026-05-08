<template>
  <div class="home-container">
    <!-- 背景装饰 -->
    <div class="bg-orb bg-orb-1"></div>
    <div class="bg-orb bg-orb-2"></div>
    <div class="bg-orb bg-orb-3"></div>
    <div class="bg-grid"></div>

    <div class="content-wrapper">
      <div class="header-actions">
        <el-dropdown @command="handleLanguageChange" trigger="click">
          <button class="language-btn">
            <span class="lang-badge">{{ currentLanguage === 'zh-cn' ? 'CN' : 'EN' }}</span>
            {{ currentLanguage === 'zh-cn' ? $t('home.language.zhCN') : $t('home.language.en') }}
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="zh-cn" :disabled="currentLanguage === 'zh-cn'">简体中文</el-dropdown-item>
              <el-dropdown-item command="en" :disabled="currentLanguage === 'en'">English</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>

        <el-dropdown @command="handleCommand">
          <button class="user-btn">
            <div class="user-avatar">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </div>
            <span class="username">{{ userStore.user?.username || $t('home.user') }}</span>
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="logout">{{ $t('home.logout') }}</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>

      <div class="brand-header">
        <div class="logo-group">
          <div class="logo-icon"><div class="logo-arrow"></div></div>
          <h1 class="brand-title">TestHub</h1>
        </div>
        <p class="brand-subtitle">{{ $t('home.subtitle') }}</p>
      </div>

      <div class="cards-container">
        <!-- AI用例生成 -->
        <div class="nav-card accent-indigo" @click="handleNavigate('ai')" role="button" tabindex="0">
          <div class="card-icon ai-icon"><component :is="IconMagicStick" /></div>
          <h3>{{ $t('home.aiCaseGeneration') }}</h3>
          <p>{{ $t('home.aiCaseGenerationDesc') }}</p>
        </div>

        <!-- 接口测试 -->
        <div class="nav-card accent-emerald" @click="handleNavigate('api')" role="button" tabindex="0">
          <div class="card-icon api-icon"><component :is="IconLink" /></div>
          <h3>{{ $t('home.apiTesting') }}</h3>
          <p>{{ $t('home.apiTestingDesc') }}</p>
        </div>

        <!-- UI自动化测试 -->
        <div class="nav-card accent-amber" @click="handleNavigate('ui')" role="button" tabindex="0">
          <div class="card-icon ui-icon"><component :is="IconMonitor" /></div>
          <h3>{{ $t('home.uiAutomation') }}</h3>
          <p>{{ $t('home.uiAutomationDesc') }}</p>
        </div>

        <!-- 数据工厂 -->
        <div class="nav-card accent-teal" @click="handleNavigate('data')" role="button" tabindex="0">
          <div class="card-icon data-icon"><component :is="IconDataLine" /></div>
          <h3>{{ $t('home.dataFactory') }}</h3>
          <p>{{ $t('home.dataFactoryDesc') }}</p>
        </div>

        <!-- APP自动化测试 -->
        <div class="nav-card accent-violet" @click="handleNavigate('app')" role="button" tabindex="0">
          <div class="card-icon app-icon"><component :is="IconCellphone" /></div>
          <h3>APP自动化测试</h3>
          <p>基于Airtest的Android APP自动化测试</p>
        </div>

        <!-- AI 智能模式 -->
        <div class="nav-card accent-blue" @click="handleNavigate('ai-intelligent')" role="button" tabindex="0">
          <div class="card-icon ai-intelligent-icon"><component :is="IconCpu" /></div>
          <h3>{{ $t('home.aiIntelligentMode') }}</h3>
          <p>{{ $t('home.aiIntelligentModeDesc') }}</p>
        </div>

        <!-- AI评测师 -->
        <div class="nav-card accent-orange" @click="handleNavigate('assistant')" role="button" tabindex="0">
          <div class="card-icon assistant-icon"><component :is="IconChatDotRound" /></div>
          <h3>{{ $t('home.aiEvaluator') }}</h3>
          <p>{{ $t('home.aiEvaluatorDesc') }}</p>
        </div>

        <!-- 配置中心 -->
        <div class="nav-card accent-green" @click="handleNavigate('config')" role="button" tabindex="0">
          <div class="card-icon config-icon"><component :is="IconSetting" /></div>
          <h3>{{ $t('home.configCenter') }}</h3>
          <p>{{ $t('home.configCenterDesc') }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, h } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { useUserStore } from '@/stores/user'
import { useAppStore } from '@/stores/app'
import { ElMessage, ElMessageBox } from 'element-plus'

const router = useRouter()
const { t } = useI18n()
const userStore = useUserStore()
const appStore = useAppStore()

const currentLanguage = computed(() => appStore.language)
const handleLanguageChange = (lang) => appStore.setLanguage(lang)

const handleCommand = (command) => {
  if (command === 'logout') handleLogout()
}

const handleLogout = () => {
  ElMessageBox.confirm(t('home.logoutConfirm'), t('common.tips'), {
    confirmButtonText: t('common.confirm'),
    cancelButtonText: t('common.cancel'),
    type: 'warning'
  }).then(() => {
    userStore.logout()
    router.push('/login')
    ElMessage.success(t('home.logoutSuccess'))
  }).catch(() => {})
}

const handleNavigate = (type) => {
  const routes = {
    'ai': '/ai-generation/requirement-analysis',
    'api': '/api-testing/dashboard',
    'ui': '/ui-automation/dashboard',
    'app': '/app-automation/dashboard',
    'ai-intelligent': '/ai-intelligent-mode/testing',
    'assistant': '/ai-generation/assistant',
    'config': '/configuration/ai-model',
    'data': '/data-factory'
  }
  if (routes[type]) {
    const routeData = router.resolve({ path: routes[type] })
    window.open(routeData.href, '_blank')
  }
}

// ── SVG 图标组件 ──────────────────────────────────────────
const IconMagicStick = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('path', { d: 'M15 4V2' }), h('path', { d: 'M15 16v-2' }), h('path', { d: 'M8 9h2' }), h('path', { d: 'M20 9h2' }),
    h('path', { d: 'M17.8 11.8 19 13' }), h('path', { d: 'M15 9h.01' }), h('path', { d: 'M17.8 6.2 19 5' }),
    h('path', { d: 'm3 21 9-9' }), h('path', { d: 'M12.2 6.2 11 5' })
  ])
}
const IconLink = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('path', { d: 'M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71' }),
    h('path', { d: 'M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71' })
  ])
}
const IconMonitor = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('rect', { x: 2, y: 3, width: 20, height: 14, rx: 2, ry: 2 }),
    h('line', { x1: 8, y1: 21, x2: 16, y2: 21 }),
    h('line', { x1: 12, y1: 17, x2: 12, y2: 21 })
  ])
}
const IconDataLine = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('path', { d: 'M3 3v18h18' }), h('path', { d: 'm19 9-5 5-4-4-3 3' })
  ])
}
const IconCellphone = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('rect', { x: 5, y: 2, width: 14, height: 20, rx: 2, ry: 2 }),
    h('line', { x1: 12, y1: 18, x2: 12.01, y2: 18 })
  ])
}
const IconCpu = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('rect', { x: 4, y: 4, width: 16, height: 16, rx: 2 }), h('rect', { x: 9, y: 9, width: 6, height: 6 }),
    h('path', { d: 'M15 2v2' }), h('path', { d: 'M15 20v2' }), h('path', { d: 'M2 15h2' }), h('path', { d: 'M2 9h2' }),
    h('path', { d: 'M20 15h2' }), h('path', { d: 'M20 9h2' }), h('path', { d: 'M9 2v2' }), h('path', { d: 'M9 20v2' })
  ])
}
const IconChatDotRound = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('path', { d: 'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z' })
  ])
}
const IconSetting = {
  render: () => h('svg', { width: 28, height: 28, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('circle', { cx: 12, cy: 12, r: 3 }),
    h('path', { d: 'M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z' })
  ])
}
</script>

<style scoped lang="scss">
/* ── 容器 ───────────────────────────────────────────────── */
.home-container {
  min-height: 100vh;
  background: #fafafa;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 48px 32px;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
  position: relative;
  overflow: hidden;
}

/* ── 背景装饰：浮动渐变光斑 + 网格 ──────────────────────── */
.bg-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.45;
  pointer-events: none;
  z-index: 0;
  animation: orbFloat 20s ease-in-out infinite;
}

.bg-orb-1 {
  width: 600px;
  height: 600px;
  background: radial-gradient(circle, #e0e7ff 0%, transparent 70%);
  top: -15%;
  left: -10%;
  animation-delay: 0s;
}

.bg-orb-2 {
  width: 500px;
  height: 500px;
  background: radial-gradient(circle, #d1fae5 0%, transparent 70%);
  bottom: -10%;
  right: -5%;
  animation-delay: -7s;
}

.bg-orb-3 {
  width: 400px;
  height: 400px;
  background: radial-gradient(circle, #fef3c7 0%, transparent 70%);
  top: 40%;
  right: 20%;
  animation-delay: -14s;
}

@keyframes orbFloat {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(30px, -20px) scale(1.05); }
  66% { transform: translate(-20px, 15px) scale(0.95); }
}

.bg-grid {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
  opacity: 0.35;
  background-image:
    linear-gradient(rgba(0, 0, 0, 0.03) 1px, transparent 1px),
    linear-gradient(90deg, rgba(0, 0, 0, 0.03) 1px, transparent 1px);
  background-size: 48px 48px;
  mask-image: radial-gradient(ellipse at center, black 30%, transparent 70%);
  -webkit-mask-image: radial-gradient(ellipse at center, black 30%, transparent 70%);
}

/* ── 内容容器 ────────────────────────────────────────────── */
.content-wrapper {
  text-align: center;
  max-width: 1080px;
  width: 100%;
  position: relative;
  z-index: 10;
}

/* ── 顶部操作栏 ──────────────────────────────────────────── */
.header-actions {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  gap: 10px;
  margin-bottom: 56px;

  .language-btn, .user-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.55);
    backdrop-filter: blur(16px);
    -webkit-backdrop-filter: blur(16px);
    border: 1px solid rgba(0, 0, 0, 0.06);
    padding: 0 18px;
    height: 40px;
    border-radius: 9999px;
    font-size: 13px;
    font-weight: 500;
    color: #374151;
    cursor: pointer;
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    outline: none;
    white-space: nowrap;
    flex-shrink: 0;
    box-sizing: border-box;

    &:hover {
      background: rgba(255, 255, 255, 0.85);
      box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
      transform: translateY(-1px);
    }
  }

  .lang-badge, .user-avatar {
    width: 24px;
    height: 24px;
    background: #000;
    border-radius: 9999px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .lang-badge {
    font-size: 9px;
    font-weight: 800;
    color: #fff;
    letter-spacing: 0.5px;
  }

  .user-avatar {
    color: #fff;
  }

  .username {
    font-weight: 600;
    color: #111827;
    font-size: 13px;
  }
}

/* ── 品牌头部 ────────────────────────────────────────────── */
.brand-header {
  margin-bottom: 64px;

  .logo-group {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 18px;
    margin-bottom: 20px;

    .logo-icon {
      width: 56px;
      height: 56px;
      background: #000;
      border-radius: 16px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 12px 32px rgba(0, 0, 0, 0.18);
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);

      &:hover { transform: rotate(-5deg) scale(1.05); }

      .logo-arrow {
        width: 28px;
        height: 28px;
        border: 4px solid #fff;
        border-radius: 5px;
        border-top-color: transparent;
        border-right-color: transparent;
        transform: rotate(45deg);
      }
    }

    .brand-title {
      font-size: 46px;
      font-weight: 800;
      letter-spacing: -1.5px;
      color: #000;
      margin: 0;
    }
  }

  .brand-subtitle {
    color: #9ca3af;
    font-size: 17px;
    letter-spacing: 2px;
    text-transform: uppercase;
    font-weight: 500;
    margin: 0;
  }
}

/* ── 功能卡片 ────────────────────────────────────────────── */
.cards-container {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.nav-card {
  background: rgba(255, 255, 255, 0.6);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.8);
  border-radius: 24px;
  padding: 36px 20px 32px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03), 0 4px 16px rgba(0, 0, 0, 0.02);
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  position: relative;
  overflow: hidden;

  /* 顶部彩色渐变光带 */
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 20%;
    right: 20%;
    height: 3px;
    border-radius: 0 0 4px 4px;
    opacity: 0;
    transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  }

  /* 底部柔光反射 */
  &::after {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: 24px;
    background: radial-gradient(circle at 50% 0%, rgba(255, 255, 255, 0.6) 0%, transparent 60%);
    opacity: 0;
    transition: opacity 0.4s;
    pointer-events: none;
  }

  &:hover {
    transform: translateY(-8px);
    box-shadow: 0 24px 48px -12px rgba(0, 0, 0, 0.1), 0 0 0 1px rgba(0, 0, 0, 0.03);
    background: rgba(255, 255, 255, 0.85);
    border-color: rgba(0, 0, 0, 0.06);

    &::before { opacity: 1; left: 10%; right: 10%; }
    &::after { opacity: 1; }
  }

  h3 {
    font-size: 15px;
    font-weight: 700;
    color: #111827;
    margin: 22px 0 8px;
    position: relative;
    letter-spacing: -0.2px;
  }

  p {
    color: #9ca3af;
    font-size: 12.5px;
    line-height: 1.65;
    margin: 0;
    position: relative;
  }
}

/* 顶部光带配色 */
.nav-card.accent-indigo::before { background: linear-gradient(90deg, transparent, #6366f1, transparent); }
.nav-card.accent-emerald::before { background: linear-gradient(90deg, transparent, #10b981, transparent); }
.nav-card.accent-amber::before { background: linear-gradient(90deg, transparent, #f59e0b, transparent); }
.nav-card.accent-teal::before { background: linear-gradient(90deg, transparent, #14b8a6, transparent); }
.nav-card.accent-violet::before { background: linear-gradient(90deg, transparent, #8b5cf6, transparent); }
.nav-card.accent-blue::before { background: linear-gradient(90deg, transparent, #3b82f6, transparent); }
.nav-card.accent-orange::before { background: linear-gradient(90deg, transparent, #f97316, transparent); }
.nav-card.accent-green::before { background: linear-gradient(90deg, transparent, #22c55e, transparent); }

/* 图标 */
.card-icon {
  width: 60px;
  height: 60px;
  border-radius: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
}

.nav-card:hover .card-icon {
  transform: scale(1.12) translateY(-2px);
}

.card-icon {
  &.ai-icon {
    background: #eef2ff;
    color: #4338ca;
  }
  &.api-icon {
    background: #ecfdf5;
    color: #059669;
  }
  &.ui-icon {
    background: #fffbeb;
    color: #d97706;
  }
  &.data-icon {
    background: #f0fdfa;
    color: #0d9488;
  }
  &.app-icon {
    background: #f5f3ff;
    color: #7c3aed;
  }
  &.ai-intelligent-icon {
    background: #eff6ff;
    color: #2563eb;
  }
  &.assistant-icon {
    background: #fff7ed;
    color: #ea580c;
  }
  &.config-icon {
    background: #f0fdf4;
    color: #16a34a;
  }
}

/* ── 入场动画 ────────────────────────────────────────────── */
.nav-card {
  animation: cardReveal 0.6s cubic-bezier(0.4, 0, 0.2, 1) both;
}

@for $i from 1 through 8 {
  .nav-card:nth-child(#{$i}) {
    animation-delay: #{$i * 0.06}s;
  }
}

@keyframes cardReveal {
  from {
    opacity: 0;
    transform: translateY(20px) scale(0.97);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}

/* ── 响应式 ──────────────────────────────────────────────── */
@media screen and (max-width: 1280px) {
  .cards-container { gap: 16px; }
  .nav-card { padding: 30px 16px 26px; }
  .brand-header .logo-group .brand-title { font-size: 40px; }
}

@media screen and (max-width: 1024px) {
  .home-container { padding: 28px 16px; }
  .brand-header {
    margin-bottom: 48px;
    .logo-group .brand-title { font-size: 36px; }
  }
  .cards-container { grid-template-columns: repeat(3, 1fr); }
}

@media screen and (max-width: 768px) {
  .home-container { padding: 20px 12px; }
  .header-actions { margin-bottom: 36px; }
  .brand-header {
    margin-bottom: 36px;
    .logo-group .brand-title { font-size: 32px; }
    .brand-subtitle { font-size: 14px; letter-spacing: 1.5px; }
  }
  .cards-container { grid-template-columns: repeat(2, 1fr); gap: 14px; }
  .nav-card { padding: 24px 14px 20px; border-radius: 20px; }
  .card-icon { width: 50px; height: 50px; border-radius: 15px; }
  .nav-card h3 { font-size: 14px; margin: 18px 0 6px; }
  .nav-card p { font-size: 12px; }
  .bg-orb { display: none; }
}

@media screen and (max-width: 480px) {
  .cards-container { grid-template-columns: 1fr 1fr; gap: 12px; }
  .header-actions {
    gap: 8px;
    .language-btn, .user-btn {
      padding: 6px 12px;
      font-size: 12px;
    }
    .username { display: none; }
  }
}
</style>
