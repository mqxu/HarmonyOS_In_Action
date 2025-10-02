/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { common } from '@kit.AbilityKit';
import { StringUtil } from '../utils/StringUtil';
import { I18nUtil } from '../utils/I18nUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello HarmonyOS';
  @State clickCount: number = 0;
  @State customMessage: string = '';
  @State showAnimation: boolean = false;
  @State currentLanguage: string = 'zh-CN';
  @State isDarkMode: boolean = false;
  private dataPreferences: preferences.Preferences | null = null;

  // 获取 Context
  getAbilityContext(): common.UIAbilityContext {
    return this.getUIContext().getHostContext() as common.UIAbilityContext;
  }

  // 组件即将出现时调用
  async aboutToAppear() {
    this.currentLanguage = I18nUtil.getSystemLanguage();
    const context = this.getAbilityContext();
    try {
      this.message = await context.resourceManager.getStringValue($r('app.string.hello_message').id);
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      hilog.error(0x0000, 'Index', `获取字符串资源失败, code: ${code}, message: ${message}`);
      this.message = 'Hello HarmonyOS'; // 降级处理
    }
    await this.initPreferences();
    await this.loadData();
  }

  // 初始化 Preferences
  async initPreferences() {
    try {
      const context = this.getAbilityContext();
      this.dataPreferences = await preferences.getPreferences(context, 'myStore');
      hilog.info(0x0000, 'Index', 'Preferences 初始化成功');
    } catch (err) {
      const error = err as BusinessError;
      hilog.error(0x0000, 'Index', `Preferences 初始化失败: ${error.message}`);
    }
  }

  // 加载保存的数据
  async loadData() {
    if (this.dataPreferences) {
      try {
        const count = await this.dataPreferences.get('clickCount', 0) as number;
        const darkMode = await this.dataPreferences.get('isDarkMode', false) as boolean;
        this.clickCount = count;
        this.isDarkMode = darkMode;
        if (count > 0) {
          const context = this.getAbilityContext();
          try {
            const helloMsg = await context.resourceManager.getStringValue($r('app.string.hello_message').id);
            this.message = StringUtil.formatMessage(helloMsg, count);
          } catch (error) {
            let code = (error as BusinessError).code;
            let message = (error as BusinessError).message;
            hilog.error(0x0000, 'Index', `获取字符串资源失败, code: ${code}, message: ${message}`);
            this.message = StringUtil.formatMessage('Hello HarmonyOS', count); // 降级处理
          }
        }
        hilog.info(0x0000, 'Index', `加载数据 - 点击次数: ${count}, 深色模式: ${darkMode}`);
      } catch (err) {
        const error = err as BusinessError;
        hilog.error(0x0000, 'Index', `加载数据失败: ${error.message}`);
      }
    }
  }

  // 保存数据
  async saveData() {
    if (this.dataPreferences) {
      try {
        await this.dataPreferences.put('clickCount', this.clickCount);
        await this.dataPreferences.put('isDarkMode', this.isDarkMode);
        await this.dataPreferences.flush();
        hilog.info(0x0000, 'Index', `保存数据 - 点击次数: ${this.clickCount}, 深色模式: ${this.isDarkMode}`);
      } catch (err) {
        const error = err as BusinessError;
        hilog.error(0x0000, 'Index', `保存数据失败: ${error.message}`);
      }
    }
  }

  // 增加计数
  incrementCount() {
    this.clickCount++;
    this.updateMessage();
    this.triggerAnimation();
    this.saveData();
  }

  // 减少计数
  decrementCount() {
    if (this.clickCount > 0) {
      this.clickCount--;
      this.updateMessage();
      this.triggerAnimation();
      this.saveData();
    }
  }

  // 重置
  async resetCount() {
    this.clickCount = 0;
    if (StringUtil.isNotEmpty(this.customMessage)) {
      this.message = this.customMessage;
    } else {
      const context = this.getAbilityContext();
      try {
        this.message = await context.resourceManager.getStringValue($r('app.string.hello_message').id);
      } catch (error) {
        let code = (error as BusinessError).code;
        let message = (error as BusinessError).message;
        hilog.error(0x0000, 'Index', `获取字符串资源失败, code: ${code}, message: ${message}`);
        this.message = 'Hello HarmonyOS'; // 降级处理
      }
    }
    this.customMessage = '';
    this.triggerAnimation();
    this.saveData();
  }

  // 更新消息
  async updateMessage() {
    let baseMessage: string;
    if (StringUtil.isNotEmpty(this.customMessage)) {
      baseMessage = this.customMessage;
    } else {
      const context = this.getAbilityContext();
      try {
        baseMessage = await context.resourceManager.getStringValue($r('app.string.hello_message').id);
      } catch (error) {
        let code = (error as BusinessError).code;
        let message = (error as BusinessError).message;
        hilog.error(0x0000, 'Index', `获取字符串资源失败, code: ${code}, message: ${message}`);
        baseMessage = 'Hello HarmonyOS'; // 降级处理
      }
    }
    this.message = this.clickCount === 0 ? baseMessage : StringUtil.formatMessage(baseMessage, this.clickCount);
  }

  // 切换深色模式
  toggleDarkMode() {
    this.isDarkMode = !this.isDarkMode;
    this.saveData();
  }

  // 切换语言
  async switchLanguage() {
    const newLanguage = this.currentLanguage.startsWith('zh') ? 'en-US' : 'zh-CN';
    const success = await I18nUtil.switchLanguage(newLanguage);
    if (success) {
      this.currentLanguage = newLanguage;
      // 重新加载以刷新界面文本
      setTimeout(async () => {
        await this.updateMessage();
      }, 100);
    }
  }

  // 触发动画
  triggerAnimation() {
    this.showAnimation = true;
    setTimeout(() => {
      this.showAnimation = false;
    }, 300);
  }

  build() {
    Column({ space: 15 }) {
      // 顶部工具栏
      Row() {
        // 语言切换
        Button(this.currentLanguage.startsWith('zh') ? $r('app.string.language_chinese') :
          $r('app.string.language_english'))
          .fontSize(14)
          .height(32)
          .backgroundColor('transparent')
          .fontColor(this.isDarkMode ? $r('app.color.text_primary_dark') : $r('app.color.text_primary_light'))
          .onClick(() => {
            this.switchLanguage();
          })

        Blank()

        // 深色模式切换
        Row() {
          Text(this.isDarkMode ? $r('app.string.dark_mode') : $r('app.string.light_mode'))
            .fontSize(14)
            .fontColor(this.isDarkMode ? $r('app.color.text_primary_dark') : $r('app.color.text_primary_light'))

          Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
            .selectedColor(this.isDarkMode ? $r('app.color.primary_blue_dark') : $r('app.color.primary_blue_light'))
            .margin({ left: 10 })
            .onChange(() => {
              this.toggleDarkMode();
            })
        }
      }
      .width('90%')
      .margin({ top: 20 })

      // Logo 区域
      Image($r('app.media.layered_image'))
        .width(100)
        .height(100)
        .borderRadius(50)
        .shadow({
          radius: this.showAnimation ? 20 : 10,
          color: this.isDarkMode ? $r('app.color.shadow_image_dark') : $r('app.color.shadow_image_light'),
          offsetX: 0,
          offsetY: 5
        })
        .animation({
          duration: 300,
          curve: Curve.EaseInOut
        })

      // 欢迎文字（带动画）
      Text(this.message)
        .fontSize(this.showAnimation ? 36 : 32)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.isDarkMode ? $r('app.color.primary_blue_dark') : $r('app.color.primary_blue_light'))
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .animation({
          duration: 300,
          curve: Curve.EaseInOut
        })

      // 点击次数显示
      Text($r('app.string.current_count', this.clickCount))
        .fontSize(20)
        .fontColor(this.isDarkMode ? $r('app.color.text_secondary_dark') : $r('app.color.text_secondary_light'))

      // 自定义消息输入框
      TextInput({ placeholder: $r('app.string.input_custom_message'), text: this.customMessage })
        .width('80%')
        .height(50)
        .fontSize(16)
        .borderRadius(25)
        .padding({ left: 20, right: 20 })
        .backgroundColor(this.isDarkMode ? $r('app.color.bg_input_dark') : $r('app.color.bg_input_light'))
        .placeholderColor(this.isDarkMode ? $r('app.color.placeholder_dark') : $r('app.color.placeholder_light'))
        .fontColor(this.isDarkMode ? $r('app.color.text_primary_dark') : $r('app.color.text_primary_light'))
        .shadow({
          radius: 8,
          color: this.isDarkMode ? $r('app.color.shadow_card_dark') : $r('app.color.shadow_card_light'),
          offsetX: 0,
          offsetY: 2
        })
        .onChange((value: string) => {
          this.customMessage = value;
          if (StringUtil.isNotEmpty(value)) {
            this.message = this.clickCount === 0 ? value : StringUtil.formatMessage(value, this.clickCount);
          } else {
            this.updateMessage();
          }
        })

      // 操作按钮组
      Row({ space: 15 }) {
        // 减少按钮
        Button($r('app.string.btn_decrement'))
          .width(60)
          .height(60)
          .fontSize(24)
          .borderRadius(30)
          .backgroundColor(this.isDarkMode ? $r('app.color.danger_red_dark') : $r('app.color.danger_red_light'))
          .fontColor(this.isDarkMode ? $r('app.color.bg_input_dark') : $r('app.color.bg_input_light'))
          .shadow({
            radius: 10,
            color: $r('app.color.shadow_danger'),
            offsetX: 0,
            offsetY: 4
          })
          .onClick(() => {
            this.decrementCount();
          })

        // 增加按钮
        Button($r('app.string.btn_increment'))
          .width(80)
          .height(80)
          .fontSize(32)
          .borderRadius(40)
          .backgroundColor(this.isDarkMode ? $r('app.color.primary_blue_dark') : $r('app.color.primary_blue_light'))
          .fontColor(this.isDarkMode ? $r('app.color.bg_input_dark') : $r('app.color.bg_input_light'))
          .shadow({
            radius: 15,
            color: $r('app.color.shadow_primary'),
            offsetX: 0,
            offsetY: 6
          })
          .onClick(() => {
            this.incrementCount();
          })

        // 重置按钮
        Button($r('app.string.btn_reset'))
          .width(60)
          .height(60)
          .fontSize(24)
          .borderRadius(30)
          .backgroundColor($r('app.color.success_green'))
          .fontColor(this.isDarkMode ? $r('app.color.bg_input_dark') : $r('app.color.bg_input_light'))
          .shadow({
            radius: 10,
            color: $r('app.color.shadow_success'),
            offsetX: 0,
            offsetY: 4
          })
          .onClick(async () => {
            await this.resetCount();
          })
      }
      .margin({ top: 20 })

      // 功能说明
      Column({ space: 8 }) {
        Text($r('app.string.features_title'))
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isDarkMode ? $r('app.color.text_primary_dark') : $r('app.color.text_primary_light'))

        Text($r('app.string.feature_persistence'))
          .fontSize(12)
          .fontColor(this.isDarkMode ? $r('app.color.text_secondary_dark') : $r('app.color.text_secondary_light'))

        Text($r('app.string.feature_custom'))
          .fontSize(12)
          .fontColor(this.isDarkMode ? $r('app.color.text_secondary_dark') : $r('app.color.text_secondary_light'))

        Text($r('app.string.feature_dark_mode'))
          .fontSize(12)
          .fontColor(this.isDarkMode ? $r('app.color.text_secondary_dark') : $r('app.color.text_secondary_light'))

        Text($r('app.string.feature_animation'))
          .fontSize(12)
          .fontColor(this.isDarkMode ? $r('app.color.text_secondary_dark') : $r('app.color.text_secondary_light'))
      }
      .width('80%')
      .padding(15)
      .borderRadius(12)
      .backgroundColor(this.isDarkMode ? $r('app.color.bg_card_dark') : $r('app.color.bg_card_light'))
      .margin({ top: 15 })

      // 版本信息
      Text($r('app.string.version_info'))
        .fontSize(12)
        .fontColor(this.isDarkMode ? $r('app.color.text_tertiary_dark') : $r('app.color.text_tertiary_light'))
        .margin({ top: 10 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isDarkMode ? $r('app.color.bg_page_dark') : $r('app.color.bg_page_light'))
    .animation({
      duration: 300,
      curve: Curve.EaseInOut
    })
  }
}
