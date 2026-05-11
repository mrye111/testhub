<template>
  <button
    :class="[
      'glass-btn',
      `glass-btn--${type}`,
      `glass-btn--${size}`,
      {
        'is-disabled': disabled,
        'is-loading': loading,
        'is-icon-only': iconOnly,
        'is-circle': circle
      }
    ]"
    :disabled="disabled || loading"
    type="button"
    @click="onClick"
  >
    <!-- 内部彩色流光 -->
    <span class="glass-btn__glow" />
    <!-- 顶部高光点 -->
    <span class="glass-btn__highlight" />
    <!-- 内容 -->
    <span class="glass-btn__content">
      <span v-if="loading" class="glass-btn__spinner" aria-hidden="true" />
      <slot v-else name="icon" />
      <span v-if="$slots.default" class="glass-btn__label"><slot /></span>
    </span>
  </button>
</template>

<script setup>
defineProps({
  type: {
    type: String,
    default: 'primary',
    validator: (v) => ['primary', 'success', 'danger', 'warning', 'neutral'].includes(v)
  },
  size: {
    type: String,
    default: 'default',
    validator: (v) => ['small', 'default', 'large'].includes(v)
  },
  disabled: { type: Boolean, default: false },
  loading: { type: Boolean, default: false },
  iconOnly: { type: Boolean, default: false },
  circle: { type: Boolean, default: false }
})

const emit = defineEmits(['click'])

const onClick = (e) => {
  emit('click', e)
}
</script>

<style lang="scss" scoped>
/* ============================================================
   GlassButton - 玻璃拟态按钮（统一风格）
   胶囊形圆角 + 半透明白底 + 背景模糊 + 内部偏移径向光晕
   ============================================================ */

.glass-btn {
  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 9999px;
  border: 1px solid rgba(255, 255, 255, 0.4);
  background: rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  box-shadow: 0 8px 24px 0 rgba(31, 38, 135, 0.07);
  cursor: pointer;
  overflow: hidden;
  font-weight: 600;
  letter-spacing: 0.2px;
  color: #334155;
  vertical-align: middle;
  transition: transform 0.25s ease, box-shadow 0.3s ease, background 0.3s ease, opacity 0.3s ease;

  &:hover {
    box-shadow: 0 8px 28px 0 rgba(31, 38, 135, 0.15);
    transform: scale(1.02);
    .glass-btn__glow { opacity: 0.85; }
  }

  &:active {
    transform: scale(0.98);
    box-shadow: 0 4px 14px 0 rgba(31, 38, 135, 0.08);
  }

  &.is-disabled,
  &:disabled {
    cursor: not-allowed;
    opacity: 0.5;
    transform: none !important;
    box-shadow: 0 4px 14px 0 rgba(31, 38, 135, 0.04);
    &:hover .glass-btn__glow { opacity: 0.6; }
  }

  & + .glass-btn {
    margin-left: 8px;
  }
}

/* ===== 尺寸 ===== */
.glass-btn--small {
  min-height: 26px;
  padding: 3px 14px;
  font-size: 12px;
  gap: 4px;

  &.is-icon-only { padding: 3px; width: 26px; }
}

.glass-btn--default {
  min-height: 32px;
  padding: 5px 18px;
  font-size: 13px;
  gap: 6px;

  &.is-icon-only { padding: 5px; width: 32px; }
}

.glass-btn--large {
  min-height: 40px;
  padding: 8px 22px;
  font-size: 14px;
  gap: 8px;

  &.is-icon-only { padding: 8px; width: 40px; }
}

.glass-btn.is-circle {
  border-radius: 50%;
}

/* ===== 光晕层 ===== */
.glass-btn__glow {
  position: absolute;
  inset: -8px;
  opacity: 0.6;
  filter: blur(22px);
  transform: translate(12px, 6px);
  transition: opacity 0.5s ease;
  pointer-events: none;
  border-radius: inherit;
}

.glass-btn__highlight {
  position: absolute;
  top: 0;
  left: 25%;
  width: 50%;
  height: 50%;
  background: rgba(255, 255, 255, 0.2);
  filter: blur(14px);
  border-radius: 9999px;
  pointer-events: none;
}

.glass-btn__content {
  position: relative;
  z-index: 1;
  display: inline-flex;
  align-items: center;
  gap: inherit;
  line-height: 1;

  :deep(.el-icon) {
    font-size: 1.05em;
  }
}

.glass-btn__label {
  display: inline-flex;
  align-items: center;
}

/* ===== 加载旋转 ===== */
.glass-btn__spinner {
  width: 1em;
  height: 1em;
  border-radius: 50%;
  border: 2px solid rgba(51, 65, 85, 0.25);
  border-top-color: currentColor;
  animation: glass-btn-spin 0.8s linear infinite;
}

@keyframes glass-btn-spin {
  to { transform: rotate(360deg); }
}

/* ============================================================
   主题配色 - 光晕渐变映射到语义
   ============================================================ */
.glass-btn--primary .glass-btn__glow {
  background: linear-gradient(
    135deg,
    rgba(96, 165, 250, 0.6) 0%,
    rgba(99, 102, 241, 0.5) 50%,
    rgba(168, 85, 247, 0.4) 100%
  );
}

.glass-btn--success .glass-btn__glow {
  background: linear-gradient(
    135deg,
    rgba(52, 211, 153, 0.6) 0%,
    rgba(20, 184, 166, 0.5) 50%,
    rgba(6, 182, 212, 0.4) 100%
  );
}

.glass-btn--danger .glass-btn__glow {
  background: linear-gradient(
    135deg,
    rgba(251, 113, 133, 0.6) 0%,
    rgba(239, 68, 68, 0.5) 50%,
    rgba(249, 115, 22, 0.4) 100%
  );
}

.glass-btn--warning .glass-btn__glow {
  background: linear-gradient(
    135deg,
    rgba(252, 211, 77, 0.6) 0%,
    rgba(251, 146, 60, 0.5) 50%,
    rgba(234, 179, 8, 0.4) 100%
  );
}

.glass-btn--neutral {
  background: rgba(255, 255, 255, 0.3);
  border-color: rgba(255, 255, 255, 0.5);
  color: #475569;

  .glass-btn__glow {
    opacity: 0.5;
    background: linear-gradient(
      135deg,
      rgba(226, 232, 240, 0.55) 0%,
      rgba(203, 213, 225, 0.45) 50%,
      rgba(148, 163, 184, 0.35) 100%
    );
  }
}
</style>
