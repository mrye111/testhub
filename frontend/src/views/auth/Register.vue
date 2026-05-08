<template>
  <div class="login-container">
    <!-- 左侧区域：功能展示区 -->
    <div class="showcase-section">
      <div class="dot-pattern"></div>

      <div class="language-bar">
        <el-dropdown @command="handleLanguageChange" trigger="click">
          <button class="language-btn">
            <span class="lang-badge">{{ currentLanguage === 'zh-cn' ? 'CN' : 'EN' }}</span>
            {{ currentLanguage === 'zh-cn' ? $t('auth.languageZhCN') : $t('auth.languageEn') }}
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"/></svg>
          </button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="zh-cn" :disabled="currentLanguage === 'zh-cn'">简体中文</el-dropdown-item>
              <el-dropdown-item command="en" :disabled="currentLanguage === 'en'">English</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
      </div>

      <div class="showcase-content">
        <div class="brand-header">
          <div class="logo-group">
            <div class="logo-icon"><div class="logo-arrow"></div></div>
            <h1 class="brand-title">TestHub</h1>
          </div>
          <p class="brand-subtitle">AI-Powered Testing Platform</p>
        </div>

        <div class="features-grid">
          <div class="feature-card" v-for="(f, i) in features" :key="i">
            <div class="feature-icon-wrapper"><component :is="f.icon" /></div>
            <h3>{{ f.title }}</h3>
            <p>{{ f.description }}</p>
          </div>
        </div>

        <div class="pill-group">
          <span class="pill-btn" v-for="(p, i) in pills" :key="i">
            <component :is="p.icon" /><span>{{ p.text }}</span>
          </span>
        </div>
      </div>

      <div class="deco-text">
        <h2>One Click Away from<br/>Studio-Grade Tests</h2>
      </div>
    </div>

    <!-- 右侧注册区 -->
    <div class="login-section">
      <div class="login-form-wrapper">
        <div class="form-header">
          <h2>{{ $t('auth.registerTitle') }}</h2>
          <p>{{ $t('auth.registerSubtitle') }}</p>
        </div>

        <el-form ref="formRef" :model="form" :rules="rules" @submit.prevent="handleRegister" class="login-form">
          <!-- 用户名 -->
          <div class="custom-input-group">
            <div class="input-icon-left">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
            </div>
            <el-form-item prop="username">
              <el-input v-model="form.username" :placeholder="$t('auth.username')" size="large" />
            </el-form-item>
          </div>

          <!-- 邮箱 -->
          <div class="custom-input-group">
            <div class="input-icon-left">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/></svg>
            </div>
            <el-form-item prop="email">
              <el-input v-model="form.email" :placeholder="$t('auth.email')" size="large" />
            </el-form-item>
          </div>

          <!-- 姓 / 名 -->
          <div class="form-row">
            <div class="custom-input-group">
              <el-form-item prop="first_name">
                <el-input v-model="form.first_name" :placeholder="$t('auth.firstName')" size="large" />
              </el-form-item>
            </div>
            <div class="custom-input-group">
              <el-form-item prop="last_name">
                <el-input v-model="form.last_name" :placeholder="$t('auth.lastName')" size="large" />
              </el-form-item>
            </div>
          </div>

          <!-- 密码 -->
          <div class="custom-input-group">
            <div class="input-icon-left">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </div>
            <el-form-item prop="password">
              <el-input v-model="form.password" type="password" :placeholder="$t('auth.password')" size="large" show-password />
            </el-form-item>
          </div>

          <!-- 确认密码 -->
          <div class="custom-input-group">
            <div class="input-icon-left">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
            </div>
            <el-form-item prop="password_confirm">
              <el-input v-model="form.password_confirm" type="password" :placeholder="$t('auth.confirmPassword')" size="large" show-password />
            </el-form-item>
          </div>

          <!-- 部门 / 职位 -->
          <div class="form-row">
            <div class="custom-input-group">
              <el-form-item prop="department">
                <el-input v-model="form.department" :placeholder="$t('auth.department')" size="large" />
              </el-form-item>
            </div>
            <div class="custom-input-group">
              <el-form-item prop="position">
                <el-input v-model="form.position" :placeholder="$t('auth.position')" size="large" />
              </el-form-item>
            </div>
          </div>

          <!-- 注册按钮 -->
          <el-form-item>
            <button type="button" class="login-btn" :class="{ 'is-loading': loading }" :disabled="loading" @click="handleRegister">
              <span v-if="!loading">{{ $t('auth.register') }}</span>
              <span v-else class="loading-text">
                <svg class="spinner" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83"/></svg>
                {{ $t('auth.registering') || '注册中...' }}
              </span>
            </button>
          </el-form-item>

          <div class="form-footer">
            <span class="footer-text">{{ $t('auth.hasAccount') }}</span>
            <router-link to="/login" class="register-link">{{ $t('auth.login') }}</router-link>
          </div>
        </el-form>

        <div class="bottom-info">
          <p>&copy; 2024 TestHub. All rights reserved.</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, h } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/stores/user'
import { useAppStore } from '@/stores/app'

const router = useRouter()
const userStore = useUserStore()
const appStore = useAppStore()
const { t } = useI18n()

const currentLanguage = computed(() => appStore.language)
const handleLanguageChange = (lang) => appStore.setLanguage(lang)

const formRef = ref()
const loading = ref(false)

const form = reactive({
  username: '', email: '', first_name: '', last_name: '',
  password: '', password_confirm: '', department: '', position: ''
})

const rules = {
  username: [
    { required: true, message: computed(() => t('auth.usernameRequired')), trigger: 'blur' },
    { min: 3, max: 20, message: computed(() => t('auth.usernameLength')), trigger: 'blur' }
  ],
  email: [
    { required: true, message: computed(() => t('auth.emailRequired')), trigger: 'blur' },
    { type: 'email', message: computed(() => t('auth.emailFormat')), trigger: 'blur' }
  ],
  password: [
    { required: true, message: computed(() => t('auth.passwordRequired')), trigger: 'blur' },
    { min: 6, message: computed(() => t('auth.passwordLength')), trigger: 'blur' }
  ],
  password_confirm: [
    { required: true, message: computed(() => t('auth.confirmPasswordRequired')), trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== form.password) {
          callback(new Error(t('auth.passwordMismatch')))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

// ── SVG 图标组件 ──────────────────────────────────────────
const IconFileText = {
  render: () => h('svg', { width: 24, height: 24, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('path', { d: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z' }),
    h('polyline', { points: '14 2 14 8 20 8' }),
    h('line', { x1: 16, y1: 13, x2: 8, y2: 13 }),
    h('line', { x1: 16, y1: 17, x2: 8, y2: 17 }),
    h('polyline', { points: '10 9 9 9 8 9' })
  ])
}
const IconZap = {
  render: () => h('svg', { width: 24, height: 24, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('polygon', { points: '13 2 3 14 12 14 11 22 21 10 12 10 13 2' })
  ])
}
const IconShare = {
  render: () => h('svg', { width: 24, height: 24, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('circle', { cx: 18, cy: 5, r: 3 }),
    h('circle', { cx: 6, cy: 12, r: 3 }),
    h('circle', { cx: 18, cy: 19, r: 3 }),
    h('line', { x1: 8.59, y1: 13.51, x2: 15.42, y2: 17.49 }),
    h('line', { x1: 15.41, y1: 6.51, x2: 8.59, y2: 10.49 })
  ])
}
const IconBarChart = {
  render: () => h('svg', { width: 24, height: 24, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('line', { x1: 12, y1: 20, x2: 12, y2: 10 }),
    h('line', { x1: 18, y1: 20, x2: 18, y2: 4 }),
    h('line', { x1: 6, y1: 20, x2: 6, y2: 16 })
  ])
}
const IconZapSm = {
  render: () => h('svg', { width: 14, height: 14, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('polygon', { points: '13 2 3 14 12 14 11 22 21 10 12 10 13 2' })
  ])
}
const IconClock = {
  render: () => h('svg', { width: 14, height: 14, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('circle', { cx: 12, cy: 12, r: 10 }),
    h('polyline', { points: '12 6 12 12 16 14' })
  ])
}
const IconPlayCircle = {
  render: () => h('svg', { width: 14, height: 14, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('circle', { cx: 12, cy: 12, r: 10 }),
    h('polygon', { points: '10 8 16 12 10 16 10 8' })
  ])
}
const IconCalendar = {
  render: () => h('svg', { width: 14, height: 14, viewBox: '0 0 24 24', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round', 'stroke-linejoin': 'round' }, [
    h('rect', { x: 3, y: 4, width: 18, height: 18, rx: 2, ry: 2 }),
    h('line', { x1: 16, y1: 2, x2: 16, y2: 6 }),
    h('line', { x1: 8, y1: 2, x2: 8, y2: 6 }),
    h('line', { x1: 3, y1: 10, x2: 21, y2: 10 })
  ])
}

const features = computed(() => [
  { icon: IconFileText, title: t('auth.aiCaseGeneration'), description: t('auth.aiCaseGenerationDesc') },
  { icon: IconZap, title: t('auth.aiIntelligentTesting'), description: t('auth.aiIntelligentTestingDesc') },
  { icon: IconShare, title: t('auth.multiTypeTesting'), description: t('auth.multiTypeTestingDesc') },
  { icon: IconBarChart, title: t('auth.dataAnalysis'), description: t('auth.dataAnalysisDesc') }
])
const pills = computed(() => [
  { icon: IconZapSm, text: t('auth.aiCaseGeneration') },
  { icon: IconClock, text: t('auth.aiIntelligentTesting') },
  { icon: IconPlayCircle, text: t('auth.automatedExecution') },
  { icon: IconCalendar, text: t('auth.scheduledTasks') }
])

const handleRegister = async () => {
  if (!formRef.value) return
  await formRef.value.validate(async (valid) => {
    if (valid) {
      loading.value = true
      try {
        await userStore.register(form)
        ElMessage.success(t('auth.registerSuccess'))
        router.push('/login')
      } catch (error) {
        ElMessage.error(error.response?.data?.error || t('auth.registerFailed'))
      } finally {
        loading.value = false
      }
    }
  })
}
</script>

<style lang="scss" scoped>
.login-container {
  height: 100vh;
  background: #F5F5F5;
  padding: 16px;
  display: flex;
  align-items: stretch;
  justify-content: center;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
  box-sizing: border-box;
}

/* ── 左侧展示区 ──────────────────────────────────────────── */
.showcase-section {
  flex: 1;
  background: #FAFAFA;
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  padding: 48px;
  overflow: hidden;
  border-radius: 32px 0 0 32px;

  .dot-pattern {
    position: absolute;
    inset: 0;
    z-index: 0;
    opacity: 0.4;
    mix-blend-mode: multiply;
    pointer-events: none;
    background-image: radial-gradient(circle at center, #000 1px, transparent 1px);
    background-size: 16px 16px;
    mask-image: radial-gradient(ellipse at center, black 10%, transparent 70%);
    -webkit-mask-image: radial-gradient(ellipse at center, black 10%, transparent 70%);
    transform: scale(1.5) rotate(-15deg) translate(10%, -10%);
  }
}

.language-bar {
  position: relative;
  z-index: 10;
  display: flex;
  justify-content: flex-end;

  .language-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: rgba(255, 255, 255, 0.5);
    backdrop-filter: blur(12px);
    border: 1px solid #e5e7eb;
    padding: 8px 16px;
    border-radius: 9999px;
    font-size: 14px;
    font-weight: 500;
    color: #374151;
    cursor: pointer;
    transition: background-color 0.2s;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
    outline: none;
    white-space: nowrap;
    flex-shrink: 0;

    &:hover { background: rgba(255, 255, 255, 0.8); }

    .lang-badge {
      width: 20px;
      height: 20px;
      background: #e5e7eb;
      border-radius: 9999px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 10px;
      font-weight: 700;
      color: #4b5563;
    }
  }
}

.showcase-content {
  position: relative;
  z-index: 10;
  display: flex;
  flex-direction: column;
  align-items: center;
  flex: 1;
  justify-content: center;
  max-width: 672px;
  margin: 0 auto;
  width: 100%;
}

.brand-header {
  text-align: center;
  margin-bottom: 64px;

  .logo-group {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    margin-bottom: 16px;

    .logo-icon {
      width: 48px;
      height: 48px;
      background: #000;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

      .logo-arrow {
        width: 24px;
        height: 24px;
        border: 4px solid #fff;
        border-radius: 4px;
        border-top-color: transparent;
        border-right-color: transparent;
        transform: rotate(45deg);
      }
    }

    .brand-title {
      font-size: 36px;
      font-weight: 700;
      letter-spacing: -0.5px;
      color: #000;
      margin: 0;
    }
  }

  .brand-subtitle {
    color: #6b7280;
    font-size: 18px;
    letter-spacing: 0.5px;
    margin: 0;
  }
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 24px;
  width: 100%;
  margin-bottom: 48px;

  .feature-card {
    background: rgba(255, 255, 255, 0.8);
    backdrop-filter: blur(20px);
    border: 1px solid #f3f4f6;
    border-radius: 16px;
    padding: 24px;
    box-shadow: 0 10px 40px -10px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    cursor: pointer;

    &:hover {
      transform: translateY(-4px);
      box-shadow: 0 20px 40px -10px rgba(0, 0, 0, 0.12);
    }

    .feature-icon-wrapper {
      width: 48px;
      height: 48px;
      background: #f9fafb;
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 16px;
      transition: all 0.3s;
      :deep(svg) { color: #000; transition: color 0.3s; }
    }

    &:hover .feature-icon-wrapper {
      background: #000;
      :deep(svg) { color: #fff; }
    }

    h3 { color: #000; font-weight: 700; font-size: 18px; margin: 0 0 8px 0; }
    p { color: #6b7280; font-size: 14px; line-height: 1.6; margin: 0; }
  }
}

.pill-group {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 16px;

  .pill-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    background: #fff;
    border: 1px solid #e5e7eb;
    padding: 10px 20px;
    border-radius: 9999px;
    font-size: 14px;
    font-weight: 500;
    color: #4b5563;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);

    &:hover { border-color: #000; color: #000; box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08); }
    :deep(svg) { flex-shrink: 0; }
  }
}

.deco-text {
  position: relative;
  z-index: 10;
  h2 {
    font-size: 28px;
    font-family: Georgia, 'Times New Roman', serif;
    color: #000;
    line-height: 1.3;
    max-width: 280px;
    margin: 0;
    font-weight: 400;
  }
}

/* ── 右侧注册区 ──────────────────────────────────────────── */
.login-section {
  width: 480px;
  background: #fff;
  padding: 48px 48px 32px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  border-left: 1px solid #f3f4f6;
  z-index: 20;
  box-shadow: -20px 0 40px -15px rgba(0, 0, 0, 0.05);
  border-radius: 0 32px 32px 0;
  overflow-y: auto;

  .login-form-wrapper {
    max-width: 384px;
    margin: 0 auto;
    width: 100%;
  }

  .form-header {
    text-align: center;
    margin-bottom: 32px;

    h2 {
      font-size: 30px;
      font-family: Georgia, 'Times New Roman', serif;
      color: #000;
      margin: 0 0 12px 0;
      font-weight: 400;
    }

    p { color: #6b7280; font-size: 14px; margin: 0; }
  }
}

.form-row {
  display: flex;
  gap: 12px;
  .custom-input-group { flex: 1; }
}

.custom-input-group {
  position: relative;
  margin-bottom: 16px;

  .input-icon-left {
    position: absolute;
    left: 16px;
    top: 50%;
    transform: translateY(-50%);
    color: #9ca3af;
    z-index: 5;
    pointer-events: none;
    display: flex;
    align-items: center;
  }

  :deep(.el-form-item) {
    margin-bottom: 0;

    .el-input__wrapper {
      padding: 4px 16px 4px 48px;
      border-radius: 12px;
      box-shadow: 0 0 0 1px #e5e7eb !important;
      background: #fff;
      height: 44px;
      transition: all 0.2s;

      &:hover { box-shadow: 0 0 0 1px #d1d5db !important; }
      &.is-focus { box-shadow: 0 0 0 1px #000, 0 0 0 3px rgba(0, 0, 0, 0.06) !important; }
    }

    .el-input__inner {
      font-size: 14px;
      color: #1f2937;
      &::placeholder { color: #9ca3af; }
    }
  }

  &:not(:has(.input-icon-left)) :deep(.el-form-item .el-input__wrapper) {
    padding-left: 16px;
  }
}

.login-btn {
  width: 100%;
  background: #000;
  color: #fff;
  font-weight: 500;
  font-size: 16px;
  padding: 12px 0;
  border-radius: 12px;
  border: none;
  cursor: pointer;
  transition: all 0.2s;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
  margin-top: 4px;

  &:hover { background: #1f2937; }
  &:active { transform: scale(0.98); }
  &.is-loading { opacity: 0.8; cursor: not-allowed; }

  .loading-text {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    .spinner { animation: spin 1s linear infinite; }
  }
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

.form-footer {
  text-align: center;
  margin-top: 20px;

  .footer-text { color: #6b7280; font-size: 14px; }

  .register-link {
    color: #000;
    font-weight: 600;
    font-size: 14px;
    text-decoration: none;
    &:hover { text-decoration: underline; }
  }
}

.bottom-info {
  margin-top: 40px;
  text-align: center;
  p { font-size: 12px; color: #9ca3af; margin: 0; }
}

/* ── 响应式 ──────────────────────────────────────────────── */
@media (max-width: 1024px) {
  .login-container {
    padding: 0;
    flex-direction: column;
    height: auto;
    min-height: 100vh;
  }

  .showcase-section, .login-section { border-radius: 0 !important; }

  .showcase-section {
    padding: 32px;
    .features-grid, .pill-group, .deco-text { display: none; }
    .brand-header { margin-bottom: 32px; }
  }

  .login-section {
    width: 100%;
    padding: 32px;
    box-shadow: none;
    border-left: none;
    border-top: 1px solid #f3f4f6;
    overflow-y: visible;
  }
}

@media (max-width: 640px) {
  .showcase-section {
    padding: 24px;
    .brand-header .logo-group .brand-title { font-size: 28px; }
  }
  .login-section { padding: 24px; }
  .form-row { flex-direction: column; gap: 0; }
}
</style>
