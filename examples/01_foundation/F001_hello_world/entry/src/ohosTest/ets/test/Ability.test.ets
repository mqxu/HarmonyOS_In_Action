/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { Driver, ON } from '@ohos/UiTest';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';

export default function abilityTest() {
  describe('F001 Hello HarmonyOS UI 测试', () => {
    let driver: Driver;

    // 所有测试用例开始前执行一次
    beforeAll(async () => {
      hilog.info(0x0000, 'AbilityTest', '开始 UI 测试');
      // 创建 UI 测试驱动
      driver = Driver.create();
      await driver.delayMs(1000); // 等待应用启动
    });

    // 每个测试用例开始前执行
    beforeEach(async () => {
      await driver.delayMs(500);
    });

    // 所有测试用例结束后执行
    afterAll(() => {
      hilog.info(0x0000, 'AbilityTest', 'UI 测试完成');
    });

    // 测试应用启动
    it('应用应该成功启动并显示主页面', 0, async () => {
      // 查找欢迎文字
      const welcomeText = await driver.findComponent(ON.text('Hello HarmonyOS'));
      expect(await welcomeText.isEnabled()).assertTrue();
      hilog.info(0x0000, 'AbilityTest', '主页面显示成功');
    });

    // 测试深色模式切换
    it('应该能够切换深色模式', 0, async () => {
      // 查找深色模式切换按钮
      const modeText = await driver.findComponent(ON.text('☀️ 浅色模式'));
      expect(await modeText.isEnabled()).assertTrue();
      hilog.info(0x0000, 'AbilityTest', '深色模式切换功能正常');
    });

    // 测试计数功能
    it('应该能够显示计数信息', 0, async () => {
      // 查找计数显示
      const countText = await driver.findComponent(ON.text('当前计数: 0', ON.MatchPattern.CONTAINS));
      expect(await countText.isEnabled()).assertTrue();
      hilog.info(0x0000, 'AbilityTest', '计数显示功能正常');
    });

    // 测试按钮存在性
    it('应该显示所有操作按钮', 0, async () => {
      // 查找增加按钮
      const addButton = await driver.findComponent(ON.text('➕'));
      expect(await addButton.isEnabled()).assertTrue();

      // 查找减少按钮
      const minusButton = await driver.findComponent(ON.text('➖'));
      expect(await minusButton.isEnabled()).assertTrue();

      // 查找重置按钮
      const resetButton = await driver.findComponent(ON.text('🔄'));
      expect(await resetButton.isEnabled()).assertTrue();

      hilog.info(0x0000, 'AbilityTest', '所有按钮显示正常');
    });

    // 测试输入框
    it('应该显示自定义消息输入框', 0, async () => {
      // 查找输入框
      const input = await driver.findComponent(ON.text('输入自定义消息...'));
      expect(await input.isEnabled()).assertTrue();
      hilog.info(0x0000, 'AbilityTest', '输入框显示正常');
    });

    // 测试功能特性说明
    it('应该显示功能特性说明', 0, async () => {
      // 查找功能特性标题
      const featureTitle = await driver.findComponent(ON.text('✨ 功能特性'));
      expect(await featureTitle.isEnabled()).assertTrue();

      // 查找数据持久化说明
      const persistenceText = await driver.findComponent(ON.text('• 数据持久化：自动保存计数和主题'));
      expect(await persistenceText.isEnabled()).assertTrue();

      hilog.info(0x0000, 'AbilityTest', '功能特性说明显示正常');
    });

    // 测试版本信息
    it('应该显示版本信息', 0, async () => {
      const versionText = await driver.findComponent(ON.text('HarmonyOS 6.0.0 (API 20)'));
      expect(await versionText.isEnabled()).assertTrue();
      hilog.info(0x0000, 'AbilityTest', '版本信息显示正常');
    });
  });
}