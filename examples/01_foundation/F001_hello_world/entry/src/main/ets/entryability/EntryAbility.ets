/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', '设置颜色模式失败。原因: %{public}s', JSON.stringify(err));
    }
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 已创建');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 已销毁');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 主窗口已创建，设置此 Ability 的主页面
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'WindowStage 已创建');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', '加载页面失败。原因: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', '加载页面成功');
    });
  }

  onWindowStageDestroy(): void {
    // 主窗口已销毁，释放 UI 相关资源
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'WindowStage 已销毁');
  }

  onForeground(): void {
    // Ability 切换到前台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 切换到前台');
  }

  onBackground(): void {
    // Ability 切换到后台
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability 切换到后台');
  }
}