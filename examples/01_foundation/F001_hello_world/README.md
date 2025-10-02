# F001 - Hello HarmonyOS

## 📝 案例简介

这是你的第一个 HarmonyOS 应用！通过这个案例,你将学会：
- 创建一个完整的 HarmonyOS 项目
- 理解 UIAbility 生命周期
- 使用基础 UI 组件（Text、Button）
- 掌握 ArkTS 基本语法

## 🎯 学习目标

- ✅ 了解 HarmonyOS 应用的基本结构
- ✅ 掌握 UIAbility 的创建和使用
- ✅ 学会使用声明式 UI（ArkUI）
- ✅ 理解状态管理基础（@State）
- ✅ 完成第一个可交互的应用

## 🔧 核心 API

| API | 说明 | 文档链接 |
|-----|------|----------|
| `UIAbility` | 应用的 UI 能力，包含生命周期管理 | [UIAbility](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability) |
| `Text` | 文本显示组件 | [Text 组件](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-text) |
| `Button` | 按钮组件 | [Button 组件](https://developer.huawei.com/consumer/cn/doc/harmonyos-references/ts-basic-components-button) |
| `@State` | 状态管理装饰器 | [@State 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state) |

## 📂 项目结构

```
F001_hello_world/
├── entry/                          # 应用入口模块
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/                # ArkTS 源代码
│   │   │   │   ├── entryability/   # UIAbility
│   │   │   │   │   └── EntryAbility.ets
│   │   │   │   └── pages/          # 页面
│   │   │   │       └── Index.ets
│   │   │   ├── resources/          # 资源文件
│   │   │   │   ├── base/
│   │   │   │   │   ├── element/    # 字符串、颜色等
│   │   │   │   │   └── media/      # 图片资源
│   │   │   │   ├── en_US/          # 英文资源
│   │   │   │   └── zh_CN/          # 中文资源
│   │   │   └── module.json5        # 模块配置
│   │   └── ohosTest/               # 测试代码
│   ├── build-profile.json5         # 构建配置
│   └── hvigorfile.ts               # 构建脚本
├── AppScope/                       # 应用全局配置
│   ├── resources/
│   └── app.json5
├── oh-package.json5                # 依赖配置
└── hvigorfile.ts                   # 根构建脚本
```

## 💻 核心代码

### 1. EntryAbility.ets - 应用入口

```typescript
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
```

**代码解析：**

1. **导入模块（HarmonyOS 6.0 新版 @kit 导入方式）**
   - `@kit.AbilityKit`: 能力框架工具包，包含 UIAbility、Want、AbilityConstant 等核心类
   - `@kit.PerformanceAnalysisKit`: 性能分析工具包，包含 hilog 日志工具
   - `@kit.ArkUI`: ArkUI 框架工具包，包含 window 窗口管理等

2. **生命周期方法**
   - `onCreate()`: Ability 第一次创建时调用，这里设置颜色模式并记录日志
   - `onWindowStageCreate()`: 窗口创建时调用，加载主页面 `pages/Index`
   - `onForeground()`: 应用切换到前台时调用
   - `onBackground()`: 应用切换到后台时调用
   - `onWindowStageDestroy()`: 窗口销毁时调用，释放 UI 相关资源
   - `onDestroy()`: Ability 销毁时调用，用于资源清理

3. **页面加载**
   ```typescript
   windowStage.loadContent('pages/Index', (err) => {...})
   ```
   - 加载 `pages/Index.ets` 作为应用的首页
   - 使用回调函数处理加载结果
   - 失败则记录错误日志，成功则记录成功日志

4. **颜色模式设置**
   - 在 `onCreate()` 中设置应用颜色模式为自动（跟随系统）
   - 使用 try-catch 捕获可能的错误

### 2. Index.ets - 主页面

```typescript
@Entry
@Component
struct Index {
  @State message: string = 'Hello HarmonyOS';
  @State clickCount: number = 0;

  build() {
    Column({ space: 20 }) {
      // Logo 区域
      Image($r('app.media.layered_image'))
        .width(120)
        .height(120)
        .margin({ top: 40 })

      // 欢迎文字
      Text(this.message)
        .fontSize(32)
        .fontWeight(FontWeight.Bold)
        .fontColor('#007DFF')
        .textAlign(TextAlign.Center)

      // 点击次数显示
      Text(`你已点击 ${this.clickCount} 次`)
        .fontSize(20)
        .fontColor('#666666')
        .margin({ top: 10 })

      // 交互按钮
      Button('点击我')
        .width(200)
        .height(50)
        .fontSize(18)
        .margin({ top: 20 })
        .onClick(() => {
          this.clickCount++;
          this.message = `Hello HarmonyOS ${this.clickCount}`;
        })

      // 重置按钮
      Button('重置')
        .width(200)
        .height(50)
        .fontSize(18)
        .backgroundColor('#FF6B6B')
        .margin({ top: 10 })
        .onClick(() => {
          this.clickCount = 0;
          this.message = 'Hello HarmonyOS';
        })

      // 版本信息
      Text('HarmonyOS 6.0.0 (API 20)')
        .fontSize(14)
        .fontColor('#999999')
        .margin({ top: 40 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#F5F5F5')
  }
}
```

<img src="https://infinityx7-oss.oss-cn-hangzhou.aliyuncs.com/md/image-20251002192430673.png" alt="image-20251002192430673" style="zoom:50%;" />

## 🔍 代码详解

### UIAbility 生命周期

```typescript
onCreate()          // Ability 创建时调用
  ↓
onWindowStageCreate()  // 窗口创建时调用，加载页面
  ↓
onForeground()      // 切换到前台时调用
  ↓
onBackground()      // 切换到后台时调用
  ↓
onWindowStageDestroy() // 窗口销毁时调用
  ↓
onDestroy()         // Ability 销毁时调用
```

### 声明式 UI 核心概念

1. **@Entry** - 标记这是一个页面入口组件
2. **@Component** - 声明这是一个自定义组件
3. **@State** - 状态变量，变化时会触发 UI 更新
4. **build()** - 构建 UI 的方法

### 状态管理

```typescript
@State message: string = 'Hello HarmonyOS';

// 修改状态会自动触发 UI 刷新
this.message = '新的消息';
```

## 🚀 运行步骤

### 1. 使用 DevEco Studio

1. 打开 DevEco Studio
2. File → Open → 选择 `F001_hello_world` 目录
3. 等待项目同步完成
4. 连接设备或启动模拟器
5. 点击 Run 按钮

### 2. 使用命令行

![image-20251002194302449](https://infinityx7-oss.oss-cn-hangzhou.aliyuncs.com/md/image-20251002194302449.png)

​																			给项目添加自动签名

```bash
# 进入项目目录
cd examples/01_foundation/F001_hello_world

# 安装依赖
ohpm install

# 构建项目
hvigorw assembleHap

# 安装到设备（添加自动签名）
hdc install entry/build/default/outputs/default/entry-default-signed.hap

# 启动应用
hdc shell aa start -a EntryAbility -b top.mqxu.f001helloharmonyos
```

## ✅ 测试验证

运行应用后，验证以下功能：

- [ ] 应用能够正常启动
- [ ] 显示 "Hello HarmonyOS" 文字
- [ ] 点击 "点击我" 按钮，计数增加
- [ ] 显示的文字随点击次数变化
- [ ] 点击 "重置" 按钮，计数归零
- [ ] 文字恢复为初始状态

## 📚 扩展练习

本项目已完整实现以下所有扩展功能，以下是详细的实现指南和代码解析。

### 练习 1: 样式优化

#### 目标
- 修改按钮颜色和圆角
- 添加阴影效果
- 实现深色模式切换

#### 实现步骤

**步骤 1: 创建颜色资源文件**

在 `entry/src/main/resources/base/element/color.json` 中定义颜色：

```json
{
  "color": [
    {
      "name": "primary_blue_light",
      "value": "#007DFF"
    },
    {
      "name": "primary_blue_dark",
      "value": "#1890ff"
    },
    {
      "name": "text_primary_light",
      "value": "#333333"
    },
    {
      "name": "text_primary_dark",
      "value": "#ffffff"
    },
    {
      "name": "bg_page_light",
      "value": "#F5F5F5"
    },
    {
      "name": "bg_page_dark",
      "value": "#121212"
    }
  ]
}
```

**步骤 2: 在组件中添加深色模式状态**

```typescript
@State isDarkMode: boolean = false;

// 切换深色模式
toggleDarkMode() {
  this.isDarkMode = !this.isDarkMode;
  this.saveData(); // 保存用户偏好
}
```

**步骤 3: 使用条件表达式选择颜色**

```typescript
Button('点击我')
  .backgroundColor(this.isDarkMode ?
    $r('app.color.primary_blue_dark') :
    $r('app.color.primary_blue_light'))
  .fontColor(this.isDarkMode ?
    $r('app.color.text_primary_dark') :
    $r('app.color.text_primary_light'))
  .borderRadius(30)  // 圆角
  .shadow({           // 阴影
    radius: 15,
    color: $r('app.color.shadow_primary'),
    offsetX: 0,
    offsetY: 6
  })
```

**步骤 4: 添加深色模式切换开关**

```typescript
Row() {
  Text(this.isDarkMode ? '🌙 深色' : '☀️ 浅色')
    .fontSize(14)

  Toggle({ type: ToggleType.Switch, isOn: this.isDarkMode })
    .selectedColor($r('app.color.primary_blue'))
    .onChange(() => {
      this.toggleDarkMode();
    })
}
```

#### 学习要点

1. **资源文件管理**: 使用 `color.json` 统一管理颜色，避免硬编码
2. **命名规范**: 使用 `_light` 和 `_dark` 后缀区分深浅色
3. **条件渲染**: 使用三元运算符根据状态选择不同资源
4. **阴影效果**: `shadow()` 方法可以为组件添加阴影
5. **圆角设置**: `borderRadius()` 设置组件圆角

### 练习 2: 功能增强

#### 目标
- 添加减少计数的按钮
- 添加输入框，让用户自定义消息
- 添加动画效果

#### 实现步骤

**步骤 1: 添加减少按钮**

```typescript
Row({ space: 15 }) {
  // 减少按钮
  Button('➖')
    .width(60)
    .height(60)
    .fontSize(24)
    .borderRadius(30)
    .backgroundColor($r('app.color.danger_red'))
    .onClick(() => {
      if (this.clickCount > 0) {
        this.clickCount--;
        this.updateMessage();
      }
    })

  // 增加按钮
  Button('➕')
    .width(80)
    .height(80)
    .fontSize(32)
    .borderRadius(40)
    .backgroundColor($r('app.color.primary_blue'))
    .onClick(() => {
      this.clickCount++;
      this.updateMessage();
    })

  // 重置按钮
  Button('🔄')
    .width(60)
    .height(60)
    .fontSize(24)
    .borderRadius(30)
    .backgroundColor($r('app.color.success_green'))
    .onClick(async () => {
      await this.resetCount();
    })
}
```

**步骤 2: 添加自定义消息输入框**

```typescript
@State customMessage: string = '';

// UI 中添加输入框
TextInput({
  placeholder: '输入自定义消息...',
  text: this.customMessage
})
  .width('80%')
  .height(50)
  .fontSize(16)
  .borderRadius(25)
  .padding({ left: 20, right: 20 })
  .backgroundColor(this.isDarkMode ?
    $r('app.color.bg_input_dark') :
    $r('app.color.bg_input_light'))
  .onChange((value: string) => {
    this.customMessage = value;
    if (StringUtil.isNotEmpty(value)) {
      this.message = this.clickCount === 0 ?
        value :
        StringUtil.formatMessage(value, this.clickCount);
    } else {
      this.updateMessage();
    }
  })
```

**步骤 3: 添加动画效果**

```typescript
@State showAnimation: boolean = false;

// 触发动画
triggerAnimation() {
  this.showAnimation = true;
  setTimeout(() => {
    this.showAnimation = false;
  }, 300);
}

// 在 UI 中使用动画
Text(this.message)
  .fontSize(this.showAnimation ? 36 : 32)  // 动画放大
  .fontWeight(FontWeight.Bold)
  .animation({
    duration: 300,
    curve: Curve.EaseInOut
  })

Image($r('app.media.layered_image'))
  .width(100)
  .height(100)
  .shadow({
    radius: this.showAnimation ? 20 : 10,  // 动画增强阴影
    color: $r('app.color.shadow_image'),
    offsetX: 0,
    offsetY: 5
  })
  .animation({
    duration: 300,
    curve: Curve.EaseInOut
  })
```

**步骤 4: 创建 StringUtil 工具类**

在 `entry/src/main/ets/utils/StringUtil.ets` 中：

```typescript
export class StringUtil {
  static isEmpty(str: string | null | undefined): boolean {
    return str === null || str === undefined || str.trim().length === 0;
  }

  static isNotEmpty(str: string | null | undefined): boolean {
    return !StringUtil.isEmpty(str);
  }

  static formatMessage(template: string, count: number): string {
    return `${template} ${count}`;
  }
}
```

#### 学习要点

1. **输入组件**: `TextInput` 用于用户输入，支持双向绑定
2. **动画**: 使用 `.animation()` 为属性变化添加过渡效果
3. **工具类**: 将通用逻辑抽取到工具类，提高代码复用性
4. **状态联动**: 多个状态变量协同工作，实现复杂交互
5. **条件判断**: 在逻辑中添加边界检查（如 `clickCount > 0`）

### 练习 3: 国际化 (i18n)

#### 目标
- 支持中英文切换
- 使用资源文件管理文本
- 实现运行时语言切换

#### 实现步骤

**步骤 1: 创建多语言资源文件**

`entry/src/main/resources/zh_CN/element/string.json`:
```json
{
  "string": [
    {
      "name": "hello_message",
      "value": "Hello HarmonyOS"
    },
    {
      "name": "current_count",
      "value": "当前计数: %s"
    },
    {
      "name": "input_custom_message",
      "value": "输入自定义消息..."
    },
    {
      "name": "language_chinese",
      "value": "🇨🇳 中文"
    },
    {
      "name": "language_english",
      "value": "🇺🇸 English"
    }
  ]
}
```

`entry/src/main/resources/en_US/element/string.json`:
```json
{
  "string": [
    {
      "name": "hello_message",
      "value": "Hello HarmonyOS"
    },
    {
      "name": "current_count",
      "value": "Count: %s"
    },
    {
      "name": "input_custom_message",
      "value": "Enter custom message..."
    },
    {
      "name": "language_chinese",
      "value": "🇨🇳 中文"
    },
    {
      "name": "language_english",
      "value": "🇺🇸 English"
    }
  ]
}
```

**步骤 2: 创建 I18nUtil 工具类**

在 `entry/src/main/ets/utils/I18nUtil.ets` 中：

```typescript
import { i18n } from '@kit.LocalizationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class I18nUtil {
  /**
   * 切换系统语言
   * @param language 语言代码，如 'zh-CN' 或 'en-US'
   */
  static async switchLanguage(language: string): Promise<boolean> {
    try {
      i18n.System.setAppPreferredLanguage(language);
      hilog.info(0x0000, 'I18nUtil', `语言已切换到: ${language}`);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      hilog.error(0x0000, 'I18nUtil', `切换语言失败: ${error.message}`);
      return false;
    }
  }

  /**
   * 获取当前系统语言
   */
  static getSystemLanguage(): string {
    return i18n.System.getAppPreferredLanguage();
  }

  /**
   * 判断是否为中文环境
   */
  static isChineseLocale(): boolean {
    const language = I18nUtil.getSystemLanguage();
    return language.startsWith('zh');
  }
}
```

**步骤 3: 在页面中使用资源**

```typescript
@State currentLanguage: string = 'zh-CN';

// 组件加载时获取资源
async aboutToAppear() {
  this.currentLanguage = I18nUtil.getSystemLanguage();
  const context = this.getAbilityContext();
  try {
    // 从资源文件加载文本
    this.message = await context.resourceManager
      .getStringValue($r('app.string.hello_message').id);
  } catch (error) {
    let code = (error as BusinessError).code;
    let message = (error as BusinessError).message;
    hilog.error(0x0000, 'Index',
      `获取字符串资源失败, code: ${code}, message: ${message}`);
    this.message = 'Hello HarmonyOS'; // 降级处理
  }
}

// 切换语言
async switchLanguage() {
  const newLanguage = this.currentLanguage.startsWith('zh') ?
    'en-US' : 'zh-CN';
  const success = await I18nUtil.switchLanguage(newLanguage);
  if (success) {
    this.currentLanguage = newLanguage;
    // 重新加载资源
    setTimeout(async () => {
      await this.updateMessage();
    }, 100);
  }
}
```

**步骤 4: 在 UI 中引用资源**

```typescript
// 语言切换按钮
Button(this.currentLanguage.startsWith('zh') ?
  $r('app.string.language_chinese') :
  $r('app.string.language_english'))
  .onClick(() => {
    this.switchLanguage();
  })

// 使用带占位符的字符串
Text($r('app.string.current_count', this.clickCount))
  .fontSize(20)
```

**步骤 5: 获取 Context 的正确方式 (HarmonyOS 6.0)**

```typescript
// 使用最新 API (API 18+)
getAbilityContext(): common.UIAbilityContext {
  return this.getUIContext().getHostContext() as common.UIAbilityContext;
}

// ❌ 过时的方式（API 18 已废弃）
// this.context = getContext(this) as common.UIAbilityContext;
```

#### 学习要点

1. **资源目录结构**:
   - `base/`: 默认资源（必须）
   - `zh_CN/`: 中文资源
   - `en_US/`: 英文资源

2. **资源引用方式**:
   - `$r('app.string.xxx')` 返回 Resource 对象
   - `$r('app.string.xxx').id` 返回资源 ID（用于 API 调用）

3. **占位符使用**:
   - 资源文件中使用 `%s` 作为占位符
   - 传递参数：`$r('app.string.current_count', this.clickCount)`

4. **Context 获取**:
   - HarmonyOS 6.0 使用 `getUIContext().getHostContext()`
   - 避免使用已废弃的 `getContext(this)`

5. **异常处理**:
   - 资源加载可能失败，需要 try-catch
   - 提供降级方案（fallback）

6. **语言切换**:
   - 使用 `i18n.System.setAppPreferredLanguage()`
   - 切换后需要重新加载资源

### 练习 4: 数据持久化

#### 目标
- 使用 Preferences 保存用户数据
- 应用重启后恢复数据
- 保存用户偏好设置

#### 实现步骤

**步骤 1: 初始化 Preferences**

```typescript
import { preferences } from '@kit.ArkData';

private dataPreferences: preferences.Preferences | null = null;

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
```

**步骤 2: 保存数据**

```typescript
async saveData() {
  if (this.dataPreferences) {
    try {
      await this.dataPreferences.put('clickCount', this.clickCount);
      await this.dataPreferences.put('isDarkMode', this.isDarkMode);
      await this.dataPreferences.flush(); // 持久化到磁盘
      hilog.info(0x0000, 'Index', `保存数据 - 点击次数: ${this.clickCount}`);
    } catch (err) {
      const error = err as BusinessError;
      hilog.error(0x0000, 'Index', `保存数据失败: ${error.message}`);
    }
  }
}
```

**步骤 3: 加载数据**

```typescript
async loadData() {
  if (this.dataPreferences) {
    try {
      const count = await this.dataPreferences.get('clickCount', 0) as number;
      const darkMode = await this.dataPreferences.get('isDarkMode', false) as boolean;
      this.clickCount = count;
      this.isDarkMode = darkMode;
      hilog.info(0x0000, 'Index', `加载数据 - 点击次数: ${count}`);
    } catch (err) {
      const error = err as BusinessError;
      hilog.error(0x0000, 'Index', `加载数据失败: ${error.message}`);
    }
  }
}
```

**步骤 4: 在生命周期中调用**

```typescript
async aboutToAppear() {
  this.currentLanguage = I18nUtil.getSystemLanguage();
  await this.initPreferences();
  await this.loadData(); // 恢复保存的数据
}
```

#### 学习要点

1. **Preferences API**: 轻量级键值对存储，适合保存用户偏好
2. **异步操作**: 所有数据库操作都是异步的，需要 await
3. **默认值**: `get()` 方法的第二个参数是默认值
4. **持久化**: 调用 `flush()` 确保数据写入磁盘
5. **错误处理**: 捕获异常并记录日志

### 完整功能清单

本项目完整实现了以下功能：

✅ **基础功能**
- [x] 计数器增加/减少/重置
- [x] 自定义消息输入
- [x] 交互动画效果

✅ **主题系统**
- [x] 深色/浅色主题切换
- [x] 资源化颜色管理
- [x] 平滑过渡动画

✅ **国际化**
- [x] 中英文切换
- [x] 资源文件管理
- [x] 运行时语言切换

✅ **数据持久化**
- [x] Preferences 存储
- [x] 应用重启恢复数据
- [x] 用户偏好保存

✅ **代码质量**
- [x] 工具类封装
- [x] 异常处理
- [x] 日志记录
- [x] 代码注释

### 进阶挑战 🚀

完成上述练习后，可以尝试：

1. **状态管理优化**
   - 使用 `@Provide/@Consume` 实现跨组件状态共享
   - 提取状态管理到单独的 ViewModel

2. **UI 优化**
   - 添加手势动画（滑动删除、长按等）
   - 实现自定义主题颜色选择
   - 添加触觉反馈 (Haptic Feedback)

3. **性能优化**
   - 使用 `@Lazy` 延迟加载组件
   - 优化资源加载性能
   - 实现虚拟滚动列表

4. **测试覆盖**
   - 编写单元测试（参见 `src/test/`）
   - 编写 UI 自动化测试（参见 `src/ohosTest/`）
   - 使用 Mock 框架隔离依赖

## 🎓 知识点总结

### 核心概念

1. **UIAbility**: HarmonyOS 应用的基本单位，管理应用的生命周期
2. **声明式 UI**: 使用 ArkTS 描述 UI 结构，框架自动管理 UI 更新
3. **状态管理**: 使用 @State 装饰器管理组件状态
4. **组件化**: 将 UI 拆分为可复用的组件

### 关键 API

| API | 用途 |
|-----|------|
| `Column` | 垂直布局容器 |
| `Row` | 水平布局容器 |
| `Text` | 文本显示 |
| `Button` | 按钮组件 |
| `Image` | 图片显示 |

### 最佳实践

1. **命名规范**: 组件名使用大驼峰（PascalCase）
2. **状态管理**: 只在需要响应式更新的变量上使用 @State
3. **代码结构**: 保持 build() 方法简洁，复杂逻辑提取到方法中
4. **资源管理**: 字符串、颜色等使用资源文件统一管理

## 🔗 参考资料

- [HarmonyOS 官方文档](https://developer.huawei.com/consumer/cn/doc/)
- [ArkTS 语言基础](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-overview)
- [UIAbility 组件](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/uiability)
- [ArkUI 组件库](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkui)

## ❓ 常见问题

### Q1: 为什么修改变量后 UI 没有更新？
**A**: 确保变量使用了 `@State` 装饰器。只有状态变量的变化才会触发 UI 重新渲染。

### Q2: 如何查看应用日志？
**A**: 使用命令 `hdc shell hilog` 查看设备日志。

### Q3: 应用安装失败怎么办？
**A**:
- 检查设备是否正确连接：`hdc list targets`
- 检查签名配置是否正确
- 查看错误日志定位问题

### Q4: 如何调试代码？
**A**:
- 使用 `hilog.info()` 打印日志
- 在 DevEco Studio 中设置断点
- 使用开发者工具查看 UI 层级

## 📝 下一步

完成本案例后，建议继续学习：
- **F002 - 状态管理进阶**: 深入学习 @Prop、@Link、@Provide/@Consume
- **U001 - Button 组件全解析**: 深入掌握按钮组件的各种用法
- **L001 - 布局基础**: 学习更多布局方式

---

**难度**: 🟢 基础
**预计时间**: 30 分钟
**前置知识**: TypeScript 基础
**适合人群**: HarmonyOS 初学者
