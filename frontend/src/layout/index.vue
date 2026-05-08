<template>
  <div class="app-shell">
    <!-- 背景装饰：浮动渐变光斑 + 网格 -->
    <div class="bg-orb bg-orb--1"></div>
    <div class="bg-orb bg-orb--2"></div>
    <div class="bg-orb bg-orb--3"></div>
    <div class="bg-grid"></div>

    <!-- Main container (full screen) -->
    <div class="main-container">
      <!-- Left Sidebar -->
      <aside class="sidebar" :class="{ 'sidebar--collapsed': sidebarCollapsed }">
        <!-- Logo -->
        <div class="sidebar-logo" @click="router.push('/home')">
          <div class="logo-circle">T</div>
          <span class="logo-text">TestHub</span>
        </div>

        <!-- Edge collapse trigger: vertical line at sidebar edge -->
        <div
          class="sidebar-edge-trigger"
          :class="{ 'sidebar-edge-trigger--hovered': edgeHovered }"
          @mouseenter="edgeHovered = true"
          @mouseleave="edgeHovered = false"
          @click="toggleSidebar">
          <div class="sidebar-edge-line"></div>
          <div class="sidebar-edge-icon">
            <el-icon>
              <Expand v-if="sidebarCollapsed" />
              <Fold v-else />
            </el-icon>
          </div>
        </div>

        <!-- Navigation -->
        <nav class="sidebar-nav">
          <!-- AI用例生成模块 -->
          <template v-if="currentModule === 'ai-generation'">
            <div class="nav-group">
              <NavItem
                icon="magic"
                :label="$t('menu.aiCaseGeneration')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/requirement-analysis'"
                @click="router.push('/ai-generation/requirement-analysis')" />
              <NavItem
                icon="list"
                :label="$t('menu.aiGeneratedTestcases')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/generated-testcases'"
                @click="router.push('/ai-generation/generated-testcases')" />
            </div>
            <div class="nav-group">
              <NavItem
                icon="folder"
                :label="$t('menu.projectManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path.startsWith('/ai-generation/projects')"
                @click="router.push('/ai-generation/projects')" />
              <NavItem
                icon="document"
                :label="$t('menu.testCases')"
                :collapsed="sidebarCollapsed"
                :active="$route.path.startsWith('/ai-generation/testcases')"
                @click="router.push('/ai-generation/testcases')" />
            </div>
            <div class="nav-group">
              <NavItem
                icon="flag"
                :label="$t('menu.versionManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/versions'"
                @click="router.push('/ai-generation/versions')" />
            </div>
            <div class="nav-group">
              <NavItem
                icon="check"
                :label="$t('menu.reviewList')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/reviews'"
                @click="router.push('/ai-generation/reviews')" />
              <NavItem
                icon="template"
                :label="$t('menu.reviewTemplates')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/review-templates'"
                @click="router.push('/ai-generation/review-templates')" />
            </div>
            <div class="nav-group">
              <NavItem
                icon="play"
                :label="$t('menu.testPlan')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/executions'"
                @click="router.push('/ai-generation/executions')" />
              <NavItem
                icon="chart"
                :label="$t('menu.testReport')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ai-generation/reports'"
                @click="router.push('/ai-generation/reports')" />
            </div>
          </template>

          <!-- 接口测试模块 -->
          <template v-else-if="currentModule === 'api-testing'">
            <div class="nav-group">
              <NavItem
                icon="dashboard"
                :label="$t('menu.dashboard')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/dashboard'"
                @click="router.push('/api-testing/dashboard')" />
              <NavItem
                icon="folder"
                :label="$t('menu.projectManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/projects'"
                @click="router.push('/api-testing/projects')" />
              <NavItem
                icon="link"
                :label="$t('menu.interfaceManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/interfaces'"
                @click="router.push('/api-testing/interfaces')" />
              <NavItem
                icon="play"
                :label="$t('menu.automationTesting')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/automation'"
                @click="router.push('/api-testing/automation')" />
              <NavItem
                icon="timer"
                :label="$t('menu.requestHistory')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/history'"
                @click="router.push('/api-testing/history')" />
              <NavItem
                icon="setting"
                :label="$t('menu.environmentManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/environments'"
                @click="router.push('/api-testing/environments')" />
              <NavItem
                icon="chart"
                :label="$t('menu.testReport')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/reports'"
                @click="router.push('/api-testing/reports')" />
              <NavItem
                icon="alarm"
                :label="$t('menu.scheduledTasks')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/scheduled-tasks'"
                @click="router.push('/api-testing/scheduled-tasks')" />
              <NavItem
                icon="bell"
                :label="$t('menu.notificationList')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/api-testing/notification-logs'"
                @click="router.push('/api-testing/notification-logs')" />
            </div>
          </template>

          <!-- UI自动化测试模块 -->
          <template v-else-if="currentModule === 'ui-automation'">
            <div class="nav-group">
              <NavItem
                icon="dashboard"
                :label="$t('menu.dashboard')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/dashboard'"
                @click="router.push('/ui-automation/dashboard')" />
              <NavItem
                icon="folder"
                :label="$t('menu.projectManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/projects'"
                @click="router.push('/ui-automation/projects')" />
              <NavItem
                icon="aim"
                :label="$t('menu.elementManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/elements-enhanced'"
                @click="router.push('/ui-automation/elements-enhanced')" />
              <NavItem
                icon="document"
                :label="$t('menu.caseManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/test-cases'"
                @click="router.push('/ui-automation/test-cases')" />
              <NavItem
                icon="edit"
                :label="$t('menu.scriptGeneration')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/scripts-enhanced'"
                @click="router.push('/ui-automation/scripts-enhanced')" />
              <NavItem
                icon="documentCopy"
                :label="$t('menu.scriptList')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/scripts'"
                @click="router.push('/ui-automation/scripts')" />
              <NavItem
                icon="collection"
                :label="$t('menu.suiteManagement')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/suites'"
                @click="router.push('/ui-automation/suites')" />
              <NavItem
                icon="play"
                :label="$t('menu.executionRecords')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/executions'"
                @click="router.push('/ui-automation/executions')" />
              <NavItem
                icon="chart"
                :label="$t('menu.testReport')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/reports'"
                @click="router.push('/ui-automation/reports')" />
              <NavItem
                icon="alarm"
                :label="$t('menu.scheduledTasks')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/scheduled-tasks'"
                @click="router.push('/ui-automation/scheduled-tasks')" />
              <NavItem
                icon="bell"
                :label="$t('menu.notificationList')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/ui-automation/notification-logs'"
                @click="router.push('/ui-automation/notification-logs')" />
            </div>
          </template>

          <!-- APP自动化测试模块 -->
          <template v-else-if="currentModule === 'app-automation'">
            <div class="nav-group">
              <NavItem icon="dashboard" label="Dashboard" :active="$route.path === '/app-automation/dashboard'" @click="router.push('/app-automation/dashboard')" />
              <NavItem icon="folder" label="项目管理" :active="$route.path === '/app-automation/projects'" @click="router.push('/app-automation/projects')" />
              <NavItem icon="phone" label="设备管理" :active="$route.path === '/app-automation/devices'" @click="router.push('/app-automation/devices')" />
              <NavItem icon="collection" label="包名管理" :active="$route.path === '/app-automation/packages'" @click="router.push('/app-automation/packages')" />
              <NavItem icon="aim" label="元素管理" :active="$route.path === '/app-automation/elements'" @click="router.push('/app-automation/elements')" />
              <NavItem icon="connection" label="用例编排" :active="$route.path === '/app-automation/scene-builder'" @click="router.push('/app-automation/scene-builder')" />
              <NavItem icon="document" label="测试用例" :active="$route.path === '/app-automation/test-cases'" @click="router.push('/app-automation/test-cases')" />
              <NavItem icon="folderOpen" label="测试套件" :active="$route.path === '/app-automation/test-suites'" @click="router.push('/app-automation/test-suites')" />
              <NavItem icon="play" label="执行记录" :active="$route.path === '/app-automation/executions'" @click="router.push('/app-automation/executions')" />
              <NavItem icon="chart" label="测试报告" :active="$route.path === '/app-automation/reports'" @click="router.push('/app-automation/reports')" />
              <NavItem icon="alarm" label="定时任务" :active="$route.path === '/app-automation/scheduled-tasks'" @click="router.push('/app-automation/scheduled-tasks')" />
              <NavItem icon="bell" label="通知列表" :active="$route.path === '/app-automation/notification-logs'" @click="router.push('/app-automation/notification-logs')" />
            </div>
          </template>

          <!-- AI 智能模式模块 -->
          <template v-else-if="currentModule === 'ai-intelligent-mode'">
            <div class="nav-group">
              <NavItem
                icon="play"
                :label="$t('menu.aiIntelligentTesting')"
                :active="$route.path === '/ai-intelligent-mode/testing'"
                @click="router.push('/ai-intelligent-mode/testing')" />
              <NavItem
                icon="document"
                :label="$t('menu.aiCaseManagement')"
                :active="$route.path === '/ai-intelligent-mode/cases'"
                @click="router.push('/ai-intelligent-mode/cases')" />
              <NavItem
                icon="timer"
                :label="$t('menu.aiExecutionRecords')"
                :active="$route.path === '/ai-intelligent-mode/execution-records'"
                @click="router.push('/ai-intelligent-mode/execution-records')" />
            </div>
          </template>

          <!-- 配置中心模块 -->
          <template v-else-if="currentModule === 'configuration'">
            <div class="nav-group">
              <NavItem
                icon="cpu"
                :label="$t('menu.aiModelConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/ai-model'"
                @click="router.push('/configuration/ai-model')" />
              <NavItem
                icon="edit"
                :label="$t('menu.promptConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/prompt-config'"
                @click="router.push('/configuration/prompt-config')" />
              <NavItem
                icon="setting"
                :label="$t('menu.generationConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/generation-config'"
                @click="router.push('/configuration/generation-config')" />
            </div>
            <div class="nav-group">
              <NavItem
                icon="monitor"
                :label="$t('menu.uiEnvConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/ui-env'"
                @click="router.push('/configuration/ui-env')" />
              <NavItem
                icon="phone"
                label="APP环境配置"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/app-env'"
                @click="router.push('/configuration/app-env')" />
              <NavItem
                icon="magic"
                :label="$t('menu.aiModeConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/ai-mode'"
                @click="router.push('/configuration/ai-mode')" />
              <NavItem
                icon="alarm"
                :label="$t('menu.scheduledTaskConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/scheduled-task'"
                @click="router.push('/configuration/scheduled-task')" />
              <NavItem
                icon="chat"
                :label="$t('menu.difyConfig')"
                :collapsed="sidebarCollapsed"
                :active="$route.path === '/configuration/dify'"
                @click="router.push('/configuration/dify')" />
            </div>
          </template>
        </nav>
      </aside>

      <!-- Right content area -->
      <div class="content-area">
        <!-- Header -->
        <header class="content-header">
          <div class="header-left"></div>
          <div class="header-center"></div>
          <div class="header-right">
            <!-- Language switcher -->
            <el-dropdown @command="handleLanguageChange" class="header-dropdown">
              <button class="header-icon-btn lang-btn">
                <span class="lang-flag">{{ appStore.language === 'zh-cn' ? '🇨🇳' : '🇺🇸' }}</span>
                <span class="lang-text">{{ currentLanguage }}</span>
              </button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="zh-cn" :disabled="appStore.language === 'zh-cn'">🇨🇳 简体中文</el-dropdown-item>
                  <el-dropdown-item command="en" :disabled="appStore.language === 'en'">🇺🇸 English</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>

            <!-- User menu -->
            <el-dropdown @command="handleCommand" class="header-dropdown">
              <button class="header-icon-btn user-btn">
                <el-avatar :size="28" :src="userStore.user?.avatar" class="user-avatar" />
                <span class="user-name">{{ userStore.user?.username }}</span>
              </button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="profile">{{ $t('nav.profile') }}</el-dropdown-item>
                  <el-dropdown-item divided command="logout">{{ $t('nav.logout') }}</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </div>
        </header>

        <!-- Page content -->
        <main class="content-main">
          <router-view />
        </main>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed, h, inject, provide, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useUserStore } from '@/stores/user'
import { useAppStore } from '@/stores/app'
import { ElMessage } from 'element-plus'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()
const appStore = useAppStore()
const { t } = useI18n()
const sidebarCollapsed = ref(false)
const sidebarCollapsedKey = Symbol('sidebar-collapsed')
const edgeHovered = ref(false)

provide(sidebarCollapsedKey, sidebarCollapsed)

const toggleSidebar = () => {
  sidebarCollapsed.value = !sidebarCollapsed.value
}

// SVG icon path data (Lucide-style line icons)
const iconPaths = {
  magic: 'M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z',
  list: 'M8 6h13M8 12h13M8 18h13M3 6h.01M3 12h.01M3 18h.01',
  folder: 'M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z',
  document: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z M14 2v6h6 M16 13H8 M16 17H8 M10 9H8',
  flag: 'M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z M4 22v-7',
  check: 'M20 6L9 17l-5-5',
  play: 'M5 3l14 9-14 9V3z',
  chart: 'M18 20V10M12 20V4M6 20v-6',
  dashboard: 'M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z M9 22V12h6v10',
  link: 'M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71 M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71',
  timer: 'M12 2v10l4.3 2.5',
  setting: 'M12 15a3 3 0 1 0 0-6 3 3 0 0 0 0 6z',
  alarm: 'M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9 M13.73 21a2 2 0 0 1-3.46 0',
  bell: 'M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9 M13.73 21a2 2 0 0 1-3.46 0',
  aim: 'M12 2v4M12 18v4M4.93 4.93l2.83 2.83M16.24 16.24l2.83 2.83M2 12h4M18 12h4M4.93 19.07l2.83-2.83M16.24 7.76l2.83-2.83',
  edit: 'M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7 M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z',
  documentCopy: 'M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2 M14 2H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z M14 2v6h6',
  collection: 'M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z',
  template: 'M4 4h16v4H4zM4 12h8v8H4zM16 12h4v8h-4z',
  phone: 'M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72c.127.96.361 1.903.7 2.81a2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0 1 22 16.92z',
  connection: 'M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6 M15 3h6v6 M10 14L21 3',
  folderOpen: 'M2 19a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-6l-2-3H6a2 2 0 0 0-2 2z',
  cpu: 'M9 3v2M15 3v2M9 19v2M15 19v2M3 9h2M3 15h2M19 9h2M19 15h2',
  monitor: 'M2 3h20v14H2zM8 21h8M12 17v4',
  chat: 'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z'
}

// NavItem render-function component
const NavItem = {
  name: 'NavItem',
  props: {
    icon: { type: String, required: true },
    label: { type: String, required: true },
    collapsed: { type: Boolean, default: false },
    active: { type: Boolean, default: false }
  },
  setup(props) {
    const injectedSidebarCollapsed = inject(sidebarCollapsedKey, ref(false))

    return () => {
      const iconPath = iconPaths[props.icon] || iconPaths.document
      // Split multi-path SVGs into individual <path> elements
      const paths = iconPath.split(/(?=M)/).filter(Boolean)
      const isCollapsed = props.collapsed || injectedSidebarCollapsed.value

      return h('button', {
        'aria-label': props.label,
        'data-label': props.label,
        class: ['nav-item', { 'nav-item--active': props.active }]
      }, [
        h('div', { class: 'nav-item__icon' }, [
          h('svg', {
            viewBox: '0 0 24 24',
            fill: 'none',
            stroke: 'currentColor',
            'stroke-width': '2',
            'stroke-linecap': 'round',
            'stroke-linejoin': 'round',
            width: '20',
            height: '20'
          }, paths.map(d => h('path', { d: d.trim() })))
        ]),
        !isCollapsed ? h('span', { class: 'nav-item__label' }, props.label) : null
      ])
    }
  }
}

// Current language display
const currentLanguage = computed(() => {
  return appStore.language === 'zh-cn' ? '中文' : 'EN'
})

const handleLanguageChange = (lang) => {
  appStore.setLanguage(lang)
  ElMessage.success(lang === 'zh-cn' ? '语言已切换为中文' : 'Language switched to English')
}

// Module detection from route path
const currentModule = computed(() => {
  if (route.path.startsWith('/ai-generation')) return 'ai-generation'
  if (route.path.startsWith('/api-testing')) return 'api-testing'
  if (route.path.startsWith('/ui-automation')) return 'ui-automation'
  if (route.path.startsWith('/app-automation')) return 'app-automation'
  if (route.path.startsWith('/ai-intelligent-mode')) return 'ai-intelligent-mode'
  if (route.path.startsWith('/configuration')) return 'configuration'
  return ''
})

const moduleName = computed(() => {
  const map = {
    'ai-generation': t('modules.aiGeneration'),
    'api-testing': t('modules.apiTesting'),
    'ui-automation': t('modules.uiAutomation'),
    'app-automation': 'APP自动化测试',
    'ai-intelligent-mode': t('modules.aiIntelligentMode'),
    'configuration': t('modules.configuration')
  }
  return map[currentModule.value] || ''
})

const breadcrumbTitle = computed(() => {
  const routeMap = {
    '/ai-generation/requirement-analysis': t('menu.aiCaseGeneration'),
    '/ai-generation/generated-testcases': t('menu.aiGeneratedTestcases'),
    '/ai-generation/projects': t('menu.projectManagement'),
    '/ai-generation/testcases': t('menu.testCases'),
    '/ai-generation/versions': t('menu.versionManagement'),
    '/ai-generation/reviews': t('menu.reviewList'),
    '/ai-generation/review-templates': t('menu.reviewTemplates'),
    '/ai-generation/testsuites': t('menu.suiteManagement'),
    '/ai-generation/executions': t('menu.executionRecords'),
    '/ai-generation/reports': t('menu.testReport'),
    '/api-testing/dashboard': t('menu.dashboard'),
    '/api-testing/projects': t('menu.projectManagement'),
    '/api-testing/interfaces': t('menu.interfaceManagement'),
    '/api-testing/automation': t('menu.automationTesting'),
    '/api-testing/history': t('menu.requestHistory'),
    '/api-testing/environments': t('menu.environmentManagement'),
    '/api-testing/reports': t('menu.testReport'),
    '/api-testing/scheduled-tasks': t('menu.scheduledTasks'),
    '/api-testing/notification-logs': t('menu.notificationList'),
    '/ui-automation/dashboard': t('menu.dashboard'),
    '/ui-automation/projects': t('menu.projectManagement'),
    '/ui-automation/elements-enhanced': t('menu.elementManagement'),
    '/ui-automation/test-cases': t('menu.caseManagement'),
    '/ui-automation/scripts-enhanced': t('menu.scriptGeneration'),
    '/ui-automation/scripts': t('menu.scriptList'),
    '/ui-automation/suites': t('menu.suiteManagement'),
    '/ui-automation/executions': t('menu.executionRecords'),
    '/ui-automation/reports': t('menu.testReport'),
    '/ui-automation/scheduled-tasks': t('menu.scheduledTasks'),
    '/ui-automation/notification-logs': t('menu.notificationList'),
    '/app-automation/dashboard': 'Dashboard',
    '/app-automation/projects': '项目管理',
    '/app-automation/devices': '设备管理',
    '/app-automation/packages': '包名管理',
    '/app-automation/elements': '元素管理',
    '/app-automation/scene-builder': '用例编排',
    '/app-automation/test-cases': '测试用例',
    '/app-automation/test-suites': '测试套件',
    '/app-automation/scheduled-tasks': '定时任务',
    '/app-automation/notification-logs': '通知列表',
    '/app-automation/executions': '执行记录',
    '/app-automation/reports': '测试报告',
    '/ai-intelligent-mode/testing': t('menu.aiIntelligentTesting'),
    '/ai-intelligent-mode/cases': t('menu.aiCaseManagement'),
    '/ai-intelligent-mode/execution-records': t('menu.aiExecutionRecords'),
    '/configuration/ai-model': t('menu.aiModelConfig'),
    '/configuration/prompt-config': t('menu.promptConfig'),
    '/configuration/generation-config': t('menu.generationConfig'),
    '/configuration/ui-env': t('menu.uiEnvConfig'),
    '/configuration/ai-mode': t('menu.aiModeConfig'),
    '/configuration/scheduled-task': t('menu.scheduledTaskConfig'),
    '/configuration/dify': t('menu.difyConfig'),
    '/profile': t('nav.profile')
  }
  return routeMap[route.path] || route.meta.title || ''
})

const handleCommand = (command) => {
  if (command === 'logout') {
    userStore.logout()
    ElMessage.success('退出登录成功')
    router.push('/login')
  } else if (command === 'profile') {
    router.push('/ai-generation/profile')
  }
}
</script>

<style lang="scss" scoped>
/* ===== Design Tokens ===== */
$cyan-50: #ecfeff;
$cyan-100: #cffafe;
$cyan-400: #22d3ee;
$cyan-500: #06b6d4;
$cyan-600: #0891b2;
$gray-50: #F8F9FC;
$gray-100: #F4F7F9;
$gray-200: #e5e7eb;
$gray-300: #d1d5db;
$gray-400: #9ca3af;
$gray-500: #6b7280;
$gray-600: #4b5563;
$gray-700: #374151;
$gray-800: #1f2937;
$gray-900: #111827;
$bg-main: #F0F4F9;
$sidebar-width: 260px;
$radius-lg: 24px;
$radius-xl: 32px;

/* ===== App Shell ===== */
.app-shell {
  position: relative;
  width: 100vw;
  height: 100vh;
  background: #fafafa;
  overflow: hidden;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Hiragino Sans GB', 'Microsoft YaHei', sans-serif;
}

/* ===== Background orbs (Home-style) ===== */
.bg-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.45;
  pointer-events: none;
  z-index: 0;
  animation: orbFloat 20s ease-in-out infinite;

  &--1 {
    width: 600px;
    height: 600px;
    background: radial-gradient(circle, #e0e7ff 0%, transparent 70%);
    top: -15%;
    left: -10%;
    animation-delay: 0s;
  }

  &--2 {
    width: 500px;
    height: 500px;
    background: radial-gradient(circle, #d1fae5 0%, transparent 70%);
    bottom: -10%;
    right: -5%;
    animation-delay: -7s;
  }

  &--3 {
    width: 400px;
    height: 400px;
    background: radial-gradient(circle, #fef3c7 0%, transparent 70%);
    top: 40%;
    right: 20%;
    animation-delay: -14s;
  }
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

/* ===== Main Container ===== */
.main-container {
  position: relative;
  z-index: 1;
  display: flex;
  width: 100%;
  height: 100%;
  background: transparent;
  overflow: hidden;
}

/* ===== Sidebar ===== */
.sidebar {
  width: $sidebar-width;
  min-width: $sidebar-width;
  height: 100%;
  background: white;
  display: flex;
  flex-direction: column;
  border-right: 1px solid $gray-200;
  overflow: hidden;
  flex-shrink: 0;
  position: relative;
  will-change: width, min-width;
  transition:
    width 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    min-width 0.32s cubic-bezier(0.22, 1, 0.36, 1);
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 20px 24px;
  cursor: pointer;
  flex-shrink: 0;
  border-bottom: 1px solid $gray-200;
  transition:
    padding 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    gap 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    justify-content 0.32s cubic-bezier(0.22, 1, 0.36, 1);

  &:hover .logo-text {
    color: $cyan-600;
  }
}

.logo-circle {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, $cyan-400, $cyan-600);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-weight: 800;
  font-size: 18px;
  font-family: 'Inter', sans-serif;
  flex-shrink: 0;
  box-shadow: 0 4px 12px rgba($cyan-500, 0.3);
  transition:
    width 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    height 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    font-size 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    box-shadow 0.32s cubic-bezier(0.22, 1, 0.36, 1);
}

.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: $gray-800;
  letter-spacing: -0.02em;
  opacity: 1;
  transform: translateX(0);
  transition:
    color 0.18s ease,
    opacity 0.2s cubic-bezier(0.22, 1, 0.36, 1),
    transform 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}

/* ===== Sidebar Nav ===== */
.sidebar-nav {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 16px 12px;

  &::-webkit-scrollbar {
    width: 4px;
  }

  &::-webkit-scrollbar-thumb {
    background: $gray-300;
    border-radius: 2px;
  }
}

.nav-group {
  margin-bottom: 0;
  display: contents;
}

/* ===== NavItem ===== */
.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;
  padding: 10px 12px;
  border: none;
  border-radius: 12px;
  background: transparent;
  color: $gray-500;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  text-align: left;
  outline: none;
  margin-bottom: 0;
  font-family: inherit;
  will-change: width, min-width, padding, justify-content;
  transition:
    background 0.18s ease,
    color 0.18s ease,
    width 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    min-width 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    height 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    min-height 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    padding 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    margin 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    justify-content 0.32s cubic-bezier(0.22, 1, 0.36, 1),
    border-radius 0.32s cubic-bezier(0.22, 1, 0.36, 1);

  &:hover {
    background: $gray-100;
    color: $gray-700;
  }
}

.nav-item--active {
  background: $cyan-500;
  color: white;
  box-shadow: 0 4px 12px rgba($cyan-500, 0.3);
  font-weight: 600;

  &:hover {
    background: $cyan-600;
    color: white;
  }

  .nav-item__icon {
    color: white;
  }
}

.nav-item__icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  flex-shrink: 0;
  color: $gray-400;
  transition: color 0.18s ease, transform 0.32s cubic-bezier(0.22, 1, 0.36, 1);
}

.nav-item__label {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  opacity: 1;
  transform: translateX(0);
  transition:
    opacity 0.2s cubic-bezier(0.22, 1, 0.36, 1),
    transform 0.2s cubic-bezier(0.22, 1, 0.36, 1);
}

/* ===== Content Area ===== */
.content-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: rgba(255, 255, 255, 0.55);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  margin: 8px;
  border-radius: $radius-xl;
  overflow: hidden;
  min-width: 0;
  border: 1px solid rgba(0, 0, 0, 0.06);
}

/* ===== Content Header ===== */
.content-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 24px;
  background: rgba(255, 255, 255, 0.85);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
  flex-shrink: 0;
  border-radius: $radius-xl $radius-xl 0 0;
}

.header-left,
.header-center {
  display: none;
}

.breadcrumb {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: $gray-400;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.breadcrumb-home {
  color: $gray-500;
  cursor: pointer;
  transition: color 0.2s;

  &:hover {
    color: $cyan-500;
  }
}

.breadcrumb-sep {
  color: $gray-300;
  font-size: 12px;
}

.breadcrumb-module {
  color: $gray-500;
}

.breadcrumb-current {
  color: $gray-800;
  font-weight: 600;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-shrink: 0;
}

.header-icon-btn {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 8px 14px;
  border: 1px solid $gray-200;
  border-radius: 12px;
  background: white;
  cursor: pointer;
  transition: all 0.2s;
  font-family: inherit;
  font-size: 13px;
  color: $gray-600;

  &:hover {
    border-color: $cyan-400;
    background: $cyan-50;
    color: $cyan-600;
  }
}

.lang-btn {
  .lang-flag {
    font-size: 16px;
    line-height: 1;
  }
  .lang-text {
    font-weight: 500;
  }
}

.user-btn {
  .user-name {
    font-weight: 500;
    color: $gray-700;
    max-width: 100px;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

.user-avatar {
  flex-shrink: 0;
}

.header-dropdown {
  outline: none;
}

/* ===== Content Main ===== */
.content-main {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 20px;

  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-track {
    background: transparent;
  }

  &::-webkit-scrollbar-thumb {
    background: $gray-300;
    border-radius: 3px;
  }
}

/* ===== Responsive ===== */
@media (max-width: 1280px) {
  .sidebar {
    width: 220px;
    min-width: 220px;
  }
}

@media (max-width: 1024px) {
  .sidebar {
    width: 60px;
    min-width: 60px;

    .logo-text,
    .nav-item__label {
      display: none;
    }

    .sidebar-logo {
      justify-content: center;
      padding: 20px 8px;
    }

    .sidebar-nav {
      padding: 12px 8px;
    }

    .nav-item {
      justify-content: center;
      padding: 10px;
    }
  }

  .content-area {
    margin: 6px;
    border-radius: $radius-lg;
  }

  .content-header {
    border-radius: $radius-lg $radius-lg 0 0;
    padding: 12px 16px;
  }

  .user-name {
    display: none;
  }
}

@media (max-width: 768px) {
  .sidebar {
    position: fixed;
    left: 0;
    top: 0;
    z-index: 1000;
    transform: translateX(-100%);
    transition: transform 0.3s ease;

    &.mobile-open {
      transform: translateX(0);
    }
  }

  .content-area {
    margin: 4px;
    border-radius: 16px;
  }

  .content-header {
    border-radius: 16px 16px 0 0;
    padding: 10px 12px;
  }

  .breadcrumb-module,
  .breadcrumb-sep:last-of-type {
    display: none;
  }
}

/* ===== FundFlow 参考图整体还原层 ===== */
.app-shell {
  display: block;
  padding: 0;
  background: #fafafa;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'PingFang SC', 'Microsoft YaHei', sans-serif;
}

.bg-orb {
  position: absolute;
  border-radius: 50%;
  filter: blur(80px);
  opacity: 0.45;
  pointer-events: none;
  z-index: 0;
  animation: orbFloat 20s ease-in-out infinite;

  &--1 {
    width: 600px;
    height: 600px;
    background: radial-gradient(circle, #e0e7ff 0%, transparent 70%);
    top: -15%;
    left: -10%;
    animation-delay: 0s;
  }

  &--2 {
    width: 500px;
    height: 500px;
    background: radial-gradient(circle, #d1fae5 0%, transparent 70%);
    bottom: -10%;
    right: -5%;
    animation-delay: -7s;
  }

  &--3 {
    width: 400px;
    height: 400px;
    background: radial-gradient(circle, #fef3c7 0%, transparent 70%);
    top: 40%;
    right: 20%;
    animation-delay: -14s;
  }
}

.main-container {
  width: 100vw;
  height: 100vh;
  min-height: 100vh;
  background: transparent;
  border: none;
  border-radius: 0;
  box-shadow: none;
}

.sidebar {
  width: 96px;
  min-width: 96px;
  padding: 30px 0 24px;
  background: transparent;
  border-right: 0;
  align-items: center;
}

.sidebar-logo {
  width: 100%;
  justify-content: center;
  padding: 0 0 72px;
  border-bottom: 0;
}

.logo-circle {
  width: 46px;
  height: 46px;
  border-radius: 16px 16px 8px 16px;
  background: #0d0a08;
  box-shadow: none;
  color: transparent;
  position: relative;

  &::before,
  &::after {
    content: '';
    position: absolute;
    background: #050403;
    border-radius: 4px;
  }

  &::before {
    width: 13px;
    height: 32px;
    left: 14px;
    top: 7px;
    transform: skewY(-28deg);
  }

  &::after {
    width: 29px;
    height: 10px;
    left: 14px;
    top: 10px;
    transform: skewX(28deg);
  }
}

.logo-text {
  position: absolute;
  width: 1px;
  max-width: 1px;
  overflow: hidden;
  opacity: 0;
}

.sidebar-nav {
  width: 100%;
  padding: 0 18px;
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.nav-group {
  display: contents;
}

.nav-item {
  position: relative;
  width: 54px;
  height: 54px;
  padding: 0;
  justify-content: center;
  border-radius: 18px;
  color: #111317;
  background: transparent;
  margin: 0 auto;

  &:hover {
    background: rgba(238, 245, 255, 0.48);
    color: #070605;
  }

  &:hover .nav-item__label {
    opacity: 0;
    pointer-events: none;
  }
}

.nav-item--active {
  background: rgba(239, 246, 255, 0.56);
  color: #0b0a08;
  box-shadow:
    inset 0 1px 0 rgba(255, 255, 255, 0.75),
    0 12px 30px rgba(86, 119, 186, 0.18);

  &:hover {
    background: rgba(239, 246, 255, 0.72);
    color: #0b0a08;
  }

  .nav-item__icon {
    color: #0b0a08;
  }
}

.nav-item__icon {
  width: 24px;
  height: 24px;
  color: currentColor;
}

.nav-item__label {
  position: absolute;
  left: 66px;
  top: 50%;
  z-index: 20;
  width: 1px;
  max-width: 1px;
  height: 1px;
  transform: translate(-8px, -50%);
  opacity: 0;
  pointer-events: none;
  overflow: hidden;
  white-space: nowrap;
  padding: 8px 12px;
  border-radius: 999px;
  background: rgba(8, 7, 5, 0.88);
  color: #fff;
  font-size: 12px;
  box-shadow: 0 14px 30px rgba(36, 43, 60, 0.22);
  transition: opacity 0.18s ease, transform 0.18s ease;
}

.content-area {
  margin: 0;
  padding: 30px 30px 30px 18px;
  border-radius: 0;
  background: transparent;
}

.content-header {
  min-height: 122px;
  padding: 0 16px 22px 0;
  background: transparent;
  border-bottom: 0;
  border-radius: 0;
  align-items: flex-start;
}

.header-left {
  display: none;
}

.header-title-stack h1 {
  margin: 0;
  color: #090a0e;
  font-size: 32px;
  line-height: 1.05;
  font-weight: 500;
  letter-spacing: 0;
}

.header-title-stack p {
  margin: 8px 0 0;
  color: rgba(45, 58, 96, 0.72);
  font-size: 16px;
  line-height: 1.35;
}

.breadcrumb {
  width: fit-content;
  max-width: min(52vw, 620px);
  padding: 8px 14px;
  border: 1px solid rgba(127, 149, 196, 0.32);
  border-radius: 999px;
  background: rgba(202, 217, 240, 0.28);
  color: rgba(31, 42, 71, 0.72);
  backdrop-filter: blur(16px);
}

.breadcrumb-current {
  color: #111317;
  font-weight: 500;
}

.breadcrumb-home:hover {
  color: #111317;
}

.header-center {
  flex: 0 1 330px;
  display: flex;
  justify-content: center;
  padding-top: 5px;
}

.route-chip {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 282px;
  max-width: 360px;
  height: 72px;
  padding: 0 28px;
  border: 1px solid rgba(109, 130, 181, 0.28);
  border-radius: 18px;
  background: rgba(177, 197, 232, 0.2);
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.25);
  color: #111317;
  font-size: 15px;
  white-space: nowrap;
  overflow: hidden;
}

.route-chip__dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #0b0a08;
  box-shadow: 14px 0 0 #0b0a08, 28px 0 0 #0b0a08, 42px 0 0 #0b0a08;
  margin-right: 44px;
  flex-shrink: 0;
}

.route-chip strong {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  font-weight: 500;
}

.header-right {
  gap: 14px;
  padding-top: 4px;
}

.header-icon-btn {
  height: 48px;
  padding: 0 18px;
  border: 1px solid rgba(255, 255, 255, 0.38);
  border-radius: 999px;
  background: rgba(235, 244, 255, 0.38);
  color: #0b0a08;
  box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.45);

  &:hover {
    border-color: rgba(255, 255, 255, 0.72);
    background: rgba(246, 250, 255, 0.58);
    color: #0b0a08;
  }
}

.user-btn {
  background: #0b0805;
  color: #fff;
  border-color: #0b0805;

  &:hover {
    background: #0b0805;
    border-color: #0b0805;
    color: #fff;
  }

  .user-name {
    color: #fff;
  }
}

.content-main {
  padding: 0 16px 6px 0;
  scrollbar-color: rgba(66, 87, 132, 0.24) transparent;
}

@media (max-width: 1280px) {
  .app-shell {
    padding: 0;
  }

  .main-container {
    min-height: 100vh;
  }

  .sidebar {
    width: 78px;
    min-width: 78px;
  }

  .content-area {
    padding: 22px 22px 22px 12px;
  }

  .header-center {
    display: none;
  }
}

@media (max-width: 1024px) {
  .sidebar {
    width: 70px;
    min-width: 70px;
    transform: none;
    position: relative;
  }

  .content-header {
    min-height: auto;
    padding-bottom: 18px;
    gap: 14px;
  }

  .header-title-stack h1 {
    font-size: 24px;
  }

  .breadcrumb {
    max-width: 46vw;
  }
}

@media (max-width: 768px) {
  .app-shell {
    padding: 0;
  }

  .main-container {
    min-height: 100vh;
    border-radius: 0;
  }

  .sidebar {
    width: 64px;
    min-width: 64px;
    left: auto;
    top: auto;
    z-index: 1;
  }

  .sidebar-logo {
    padding-bottom: 36px;
  }

  .content-area {
    padding: 18px 14px 18px 6px;
    border-radius: 0;
  }

  .content-header {
    flex-direction: column;
    align-items: stretch;
  }

  .header-right {
    padding-top: 0;
    justify-content: flex-end;
  }

  .breadcrumb {
    max-width: 100%;
  }
}

/* ===== 侧栏折叠/展开 ===== */
.sidebar {
  width: 268px;
  min-width: 268px;
  position: relative;
  overflow: hidden;
  transition: width 0.24s ease, min-width 0.24s ease;
}

.sidebar-topbar {
  display: flex;
  justify-content: flex-end;
  align-items: center;
  padding: 14px 14px 0;
}

.sidebar-logo {
  justify-content: flex-start;
  align-items: center;
  position: relative;
  padding: 14px 56px 24px 18px;
  border-bottom: 0;
  gap: 12px;
}

.logo-circle {
  color: #fff;
  font-size: 22px;
  font-weight: 800;
  line-height: 1;

  &::before,
  &::after {
    display: none;
  }
}

.logo-text {
  flex: 1;
  opacity: 1;
  position: static;
  width: auto;
  max-width: none;
  overflow: visible;
  color: #0d0f14;
  font-size: 20px;
  white-space: nowrap;
}

/* ===== Edge collapse trigger ===== */
.sidebar-edge-trigger {
  position: absolute;
  top: 0;
  right: 0;
  width: 12px;
  height: 100%;
  z-index: 10;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.sidebar-edge-line {
  position: absolute;
  top: 12px;
  bottom: 12px;
  right: 4px;
  width: 1px;
  border-radius: 0.5px;
  background: #e5e7eb;
  transition: background 0.3s ease;
}

.sidebar-edge-trigger--hovered .sidebar-edge-line {
  background: #cbd5e1;
}

.sidebar-edge-icon {
  position: absolute;
  top: 50%;
  right: 0;
  transform: translateY(-50%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #94a3b8;
  font-size: 11px;
  opacity: 0;
  transition: opacity 0.25s ease;
  pointer-events: none;
}

.sidebar-edge-trigger--hovered .sidebar-edge-icon {
  opacity: 1;
  color: #64748b;
}

.sidebar-nav {
  flex: 1 1 auto;
  min-height: 0;
  align-items: stretch;
  gap: 4px;
  padding: 0 12px 18px 12px;
  overflow-y: auto;
  overflow-x: hidden;
  scrollbar-width: none;
  transition: padding 0.32s cubic-bezier(0.22, 1, 0.36, 1), align-items 0.32s cubic-bezier(0.22, 1, 0.36, 1);

  &::-webkit-scrollbar {
    display: none;
  }
}

.nav-group {
  display: contents;
  margin-bottom: 0;
}

.nav-item {
  width: 100%;
  height: 50px;
  min-width: 0;
  min-height: 50px;
  justify-content: flex-start;
  padding: 0 14px;
  border-radius: 16px;
  margin: 0;
}

.nav-item__icon {
  width: 22px;
  height: 22px;
}

.nav-item__label {
  position: static;
  width: auto;
  max-width: none;
  height: auto;
  padding: 0;
  margin-left: 10px;
  transform: none;
  opacity: 1;
  pointer-events: auto;
  overflow: visible;
  white-space: nowrap;
  background: transparent;
  color: inherit;
  box-shadow: none;
  font-size: 14px;
  text-align: left;
}

.sidebar--collapsed {
  width: 72px;
  min-width: 72px;
}

.sidebar--collapsed .sidebar-logo {
  justify-content: center;
  padding: 20px 10px 24px 10px;
  gap: 0;
}

.sidebar--collapsed .logo-circle {
  width: 48px;
  height: 48px;
  font-size: 16px;
}

.sidebar--collapsed .logo-text {
  flex: none;
  opacity: 0;
  width: 0;
  overflow: hidden;
  transform: translateX(-8px);
  pointer-events: none;
}

.sidebar--collapsed .nav-item__label {
  opacity: 0;
  width: 0;
  overflow: hidden;
  transform: translateX(-8px);
  pointer-events: none;
  position: absolute;
}

.sidebar--collapsed .sidebar-nav {
  align-items: center;
  padding: 0 10px 18px 10px;
}

.sidebar--collapsed .nav-group {
  display: contents;
}

.sidebar--collapsed .nav-item {
  width: 48px;
  min-width: 48px;
  height: 44px;
  min-height: 44px;
  justify-content: center;
  padding: 0;
  margin: 0 auto 2px auto;
  border-radius: 12px;
  position: relative;
}

.sidebar--collapsed .nav-item:hover {
  background: #f0f4f9;
}

.sidebar--collapsed .nav-item--active {
  background: linear-gradient(135deg, #06b6d4, #0891b2);
  box-shadow: 0 2px 8px rgba(6, 182, 212, 0.3);
  color: white;
}

.sidebar--collapsed .nav-item--active:hover {
  background: linear-gradient(135deg, #0891b2, #0e7490);
}

.sidebar--collapsed .nav-item__icon {
  margin-left: 0;
  color: #64748b;
}

.sidebar--collapsed .nav-item--active .nav-item__icon {
  color: white;
}

.sidebar--collapsed .nav-item__label {
  opacity: 0;
  width: 0;
  overflow: hidden;
  transform: translateX(-8px);
  pointer-events: none;
  position: absolute;
}

/* Tooltip for collapsed nav items */
.sidebar--collapsed .nav-item::after {
  content: attr(data-label);
  position: absolute;
  left: calc(100% + 10px);
  top: 50%;
  transform: translateY(-50%) translateX(-6px);
  padding: 6px 12px;
  background: #1e293b;
  color: white;
  font-size: 12px;
  font-weight: 500;
  white-space: nowrap;
  border-radius: 8px;
  opacity: 0;
  pointer-events: none;
  transition:
    opacity 0.18s cubic-bezier(0.22, 1, 0.36, 1),
    transform 0.18s cubic-bezier(0.22, 1, 0.36, 1);
  z-index: 100;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  letter-spacing: 0;
}

.sidebar--collapsed .nav-item::before {
  content: '';
  position: absolute;
  left: calc(100% + 6px);
  top: 50%;
  transform: translateY(-50%);
  width: 0;
  height: 0;
  border-top: 4px solid transparent;
  border-bottom: 4px solid transparent;
  border-right: 4px solid #1e293b;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.18s cubic-bezier(0.22, 1, 0.36, 1);
  z-index: 100;
}

.sidebar--collapsed .nav-item:hover::after {
  opacity: 1;
  transform: translateY(-50%) translateX(0);
}

.sidebar--collapsed .nav-item:hover::before {
  opacity: 1;
}

@media (max-width: 1280px) {
  .sidebar {
    width: 236px;
    min-width: 236px;
  }

  .sidebar--collapsed {
    width: 64px;
    min-width: 64px;
  }
}

@media (max-width: 768px) {
  .sidebar {
    width: 72px;
    min-width: 72px;
  }

  .sidebar-logo {
    justify-content: center;
    padding: 16px 0 28px;
  }

  .logo-text,
  .sidebar-edge-trigger {
    display: none !important;
  }

  .nav-item {
    width: 54px;
    min-width: 54px;
    padding: 0;
    justify-content: center;
  }

  .nav-item__label {
    display: none !important;
  }
}
</style>
