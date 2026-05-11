<template>
  <div class="page-container">
    <div class="card-container">
      <div class="card-toolbar">
        <el-button type="primary">
          <el-icon><Plus /></el-icon>
          {{ $t('testSuite.newSuite') }}
        </el-button>
      </div>
      <div class="empty-state">
        <el-empty :description="$t('testSuite.inDevelopment')" />
      </div>
    </div>
  </div>
</template>

<script setup>
// 测试套件列表组件
</script>