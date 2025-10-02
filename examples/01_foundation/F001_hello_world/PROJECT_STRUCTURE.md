# F001_hello_world 项目结构详解

## 项目概述

这是一个 HarmonyOS 6.0 (API 20) 的基础示例项目，展示了以下核心功能：
- 数据持久化 (Preferences)
- 国际化 (i18n)
- 深浅色主题切换
- 自定义消息输入
- 交互动画
- 单元测试和 Mock 测试

---

## 一、根目录文件

### 1.1 配置文件

#### `oh-package.json5`
```json5
{
  "modelVersion": "5.0.0",
  "name": "f001_hello_world",
  "description": "F001 Hello World 示例",
  "main": "",
  "author": "",
  "license": "Apache-2.0",
  "dependencies": {
    "@ohos/hypium": "1.0.24",    // 单元测试框架
    "@ohos/hamock": "^1.0.0"     // Mock 测试框架
  }
}
```
**作用**: 定义项目元信息和依赖包

#### `oh-package-lock.json5`
**作用**: 锁定依赖包版本，确保团队成员使用相同的依赖版本

#### `hvigorfile.ts`
```typescript
// Hvigor 构建配置入口
export default {
  system: appTasks,
  plugins: []
}
```
**作用**: 项目级 Hvigor 构建工具配置

#### `hvigor/hvigor-config.json5`
**作用**: Hvigor 工具的详细配置，包括构建任务、依赖解析等

#### `local.properties`
```properties
sdk.dir=/path/to/HarmonyOS/SDK
```
**作用**: 本地环境配置，通常不提交到 Git

#### `code-linter.json5`
**作用**: 代码检查规则配置（ArkTS 语法检查、代码风格等）

---

## 二、AppScope 目录

### 2.1 `AppScope/app.json5`
```json5
{
  "app": {
    "bundleName": "com.example.f001helloworld",
    "vendor": "mqxu",
    "versionCode": 1000000,
    "versionName": "1.0.0",
    "icon": "$media:app_icon",
    "label": "$string:app_name",
    "targetAPIVersion": 20
  }
}
```
**作用**: 应用全局配置
- **bundleName**: 应用唯一标识（包名）
- **versionCode**: 版本号（数字），用于版本更新判断
- **versionName**: 版本名（字符串），用户可见
- **targetAPIVersion**: 目标 API 版本

### 2.2 `AppScope/resources/`
应用级资源目录，存放所有 Module 共享的资源

#### `base/element/string.json`
```json
{
  "string": [
    {
      "name": "app_name",
      "value": "F001_hello_world"
    }
  ]
}
```
**作用**: 应用名称等全局字符串资源

#### `base/media/`
- **foreground.png**: 应用图标前景层
- **background.png**: 应用图标背景层
- **layered_image.json**: 分层图标配置（用于自适应图标）

---

## 三、Entry Module 目录

### 3.1 `entry/hvigorfile.ts`
**作用**: Entry Module 的构建配置

### 3.2 `entry/oh-package.json5`
```json5
{
  "name": "entry",
  "version": "1.0.0",
  "description": "入口模块",
  "main": "Index.ets",
  "type": "entry",
  "dependencies": {}
}
```
**作用**: Entry Module 的配置和依赖

### 3.3 `entry/obfuscation-rules.txt`
**作用**: 代码混淆规则（发布时保护代码）

---

## 四、源代码目录 (`entry/src/main/`)

### 4.1 `module.json5`
```json5
{
  "module": {
    "name": "entry",
    "type": "entry",
    "description": "$string:module_desc",
    "mainElement": "EntryAbility",
    "deviceTypes": [
      "phone",
      "tablet",
      "2in1"
    ],
    "deliveryWithInstall": true,
    "installationFree": false,
    "pages": "$profile:main_pages",
    "abilities": [
      {
        "name": "EntryAbility",
        "srcEntry": "./ets/entryability/EntryAbility.ets",
        "description": "$string:EntryAbility_desc",
        "icon": "$media:layered_image",
        "label": "$string:EntryAbility_label",
        "startWindowIcon": "$media:startIcon",
        "startWindowBackground": "$color:start_window_background",
        "exported": true,
        "skills": [
          {
            "entities": [
              "entity.system.home"
            ],
            "actions": [
              "action.system.home"
            ]
          }
        ],
        "backupConfig": {
          "name": "EntryBackupAbility",
          "srcEntry": "./ets/entrybackupability/EntryBackupAbility.ets"
        }
      }
    ]
  }
}
```
**核心配置项说明**:
- **mainElement**: 主 Ability 名称
- **pages**: 页面路由配置引用
- **abilities**: Ability 配置数组
  - **exported: true**: 允许其他应用启动
  - **skills**: Intent 过滤器（定义可响应的操作）
  - **backupConfig**: 数据备份配置

### 4.2 ETS 源代码 (`ets/`)

#### 4.2.1 `entryability/EntryAbility.ets`
```typescript
export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    // Ability 创建时的回调
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 窗口创建时加载主页面
    windowStage.loadContent('pages/Index', (err) => {
      // ...
    });
  }
}
```
**作用**:
- 应用的生命周期管理
- 页面加载入口
- 窗口管理

#### 4.2.2 `entrybackupability/EntryBackupAbility.ets`
```typescript
export default class EntryBackupAbility extends BackupExtensionAbility {
  async onBackup(): Promise<string> {
    // 数据备份逻辑
  }

  async onRestore(bundleVersion: BundleVersion): Promise<void> {
    // 数据恢复逻辑
  }
}
```
**作用**:
- 实现应用数据的备份和恢复功能
- 支持华为云备份

#### 4.2.3 `pages/Index.ets`
**主页面组件，包含**:
- 状态管理 (`@State`)
- Context 获取
- Preferences 数据持久化
- 国际化资源加载
- UI 渲染和交互

#### 4.2.4 `utils/StringUtil.ets`
```typescript
export class StringUtil {
  static isEmpty(str: string | null | undefined): boolean
  static isNotEmpty(str: string | null | undefined): boolean
  static formatMessage(template: string, count: number): string
  static capitalize(str: string): string
}
```
**作用**: 字符串工具类

#### 4.2.5 `utils/I18nUtil.ets`
```typescript
export class I18nUtil {
  static async switchLanguage(language: string): Promise<boolean>
  static getSystemLanguage(): string
  static isChineseLocale(): boolean
}
```
**作用**: 国际化工具类

### 4.3 资源目录 (`resources/`)

#### 4.3.1 目录结构说明
```
resources/
├── base/              # 默认资源（必须）
│   ├── element/       # 基础元素
│   │   ├── color.json      # 颜色资源
│   │   ├── string.json     # 字符串资源
│   │   └── float.json      # 浮点数资源
│   ├── media/         # 媒体资源（图片、音频等）
│   └── profile/       # 配置文件
│       ├── main_pages.json      # 页面路由配置
│       └── backup_config.json   # 备份配置
├── zh_CN/            # 中文资源
│   └── element/
│       └── string.json
├── en_US/            # 英文资源
│   └── element/
│       └── string.json
├── dark/             # 深色主题资源（可选）
│   └── element/
└── rawfile/          # 原始文件（不会被编译）
```

#### 4.3.2 `base/element/color.json`
```json
{
  "color": [
    {"name": "primary_blue_light", "value": "#007DFF"},
    {"name": "primary_blue_dark", "value": "#1890ff"},
    {"name": "text_primary_light", "value": "#333333"},
    {"name": "text_primary_dark", "value": "#ffffff"},
    // ... 更多颜色定义
  ]
}
```
**设计思路**:
- 使用 `_light` 和 `_dark` 后缀区分深浅色
- 在代码中通过条件判断选择对应颜色
- 统一管理所有颜色，避免硬编码

#### 4.3.3 `base/element/string.json`
```json
{
  "string": [
    {"name": "hello_message", "value": "Hello HarmonyOS"},
    {"name": "btn_increment", "value": "➕"},
    // ... 更多字符串
  ]
}
```

#### 4.3.4 `zh_CN/element/string.json`
```json
{
  "string": [
    {"name": "hello_message", "value": "Hello HarmonyOS"},
    {"name": "current_count", "value": "当前计数: %s"},
    {"name": "language_chinese", "value": "🇨🇳 中文"}
  ]
}
```

#### 4.3.5 `en_US/element/string.json`
```json
{
  "string": [
    {"name": "hello_message", "value": "Hello HarmonyOS"},
    {"name": "current_count", "value": "Count: %s"},
    {"name": "language_english", "value": "🇺🇸 English"}
  ]
}
```

**国际化机制**:
1. 系统根据应用语言设置自动选择对应目录
2. 如果找不到对应语言资源，回退到 `base/` 目录
3. 使用 `$r('app.string.xxx').id` 引用资源

#### 4.3.6 `base/profile/main_pages.json`
```json
{
  "src": [
    "pages/Index"
  ]
}
```
**作用**: 定义应用的页面列表和默认首页

#### 4.3.7 `base/profile/backup_config.json`
```json
{
  "allowToBackupRestore": true,
  "includes": [],
  "excludes": [],
  "fullBackupOnly": false
}
```
**作用**: 配置数据备份行为

---

## 五、测试目录

### 5.1 单元测试 (`src/test/`)

#### `LocalUnit.test.ets`
```typescript
import { describe, it, expect } from '@ohos/hypium';

export default function localUnitTest() {
  describe('StringUtil测试', () => {
    it('isEmpty应返回true当输入为空字符串', () => {
      expect(StringUtil.isEmpty('')).assertTrue();
    });
  });
}
```
**作用**: 本地单元测试（不依赖设备环境）

#### `List.test.ets`
**作用**: 测试套件列表

### 5.2 设备测试 (`src/ohosTest/`)

#### `ohosTest/module.json5`
**作用**: 测试 Module 的配置

#### `ohosTest/ets/test/Ability.test.ets`
```typescript
import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it('testUiExample', 0, async (done: Function) => {
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text('Hello HarmonyOS'));
      done();
    });
  });
}
```
**作用**:
- 真机/模拟器上的集成测试
- UI 组件测试
- Ability 生命周期测试

### 5.3 Mock 测试 (`src/mock/`)

#### `mock-config.json5`
```json5
{
  "abilityContext": {
    "resourceManager": {
      "getStringValue": {
        "returnValue": "Mocked String"
      }
    }
  }
}
```
**作用**:
- Mock API 返回值
- 隔离外部依赖
- 提高测试稳定性

---

## 六、依赖模块 (`oh_modules/`)

### 6.1 `@ohos/hypium`
**功能**:
- HarmonyOS 官方测试框架
- 提供 describe、it、expect 等断言 API
- 支持异步测试

**主要 API**:
```typescript
describe('测试套件', () => {
  beforeAll(() => {})      // 所有测试前执行一次
  afterAll(() => {})       // 所有测试后执行一次
  beforeEach(() => {})     // 每个测试前执行
  afterEach(() => {})      // 每个测试后执行

  it('测试用例', () => {
    expect(value).assertEqual(expected);
    expect(value).assertTrue();
    expect(value).assertFalse();
  });
});
```

### 6.2 `@ohos/hamock`
**功能**:
- Mock 框架
- 模拟系统 API 行为
- 支持参数匹配和验证

**使用场景**:
```typescript
import { when, mockFunc, verify } from '@ohos/hamock';

let mockContext = mockFunc('resourceManager.getStringValue');
when(mockContext)('app.string.hello_message')
  .thenReturn('Mocked Hello');
```

---

## 七、项目构建流程

### 7.1 构建命令
```bash
# 清理构建产物
hvigorw clean

# 编译项目
hvigorw assembleHap

# 运行单元测试
hvigorw test

# 安装到设备
hdc install entry-default-signed.hap
```

### 7.2 构建产物目录
```
build/
└── default/
    └── outputs/
        └── default/
            └── entry-default-signed.hap
```

---

## 八、项目运行流程

### 8.1 应用启动流程
1. **系统启动 EntryAbility**
   ```
   onCreate() → onWindowStageCreate() → loadContent('pages/Index')
   ```

2. **Index 页面初始化**
   ```
   aboutToAppear()
   → getAbilityContext()
   → 加载国际化资源
   → initPreferences()
   → loadData()
   ```

3. **UI 渲染**
   ```
   build() → 根据状态变量渲染组件
   ```

### 8.2 交互流程示例

#### 切换深色模式
```
用户点击 Toggle
→ toggleDarkMode()
→ this.isDarkMode = !this.isDarkMode
→ saveData()
→ UI 自动重新渲染（根据新的 isDarkMode 值选择颜色）
```

#### 切换语言
```
用户点击语言按钮
→ switchLanguage()
→ I18nUtil.switchLanguage('en-US')
→ i18n.System.setAppPreferredLanguage()
→ updateMessage()
→ 重新加载资源
```

---

## 九、资源引用方式

### 9.1 在代码中引用
```typescript
// 字符串资源
$r('app.string.hello_message')           // 返回 Resource 对象
$r('app.string.hello_message').id        // 返回资源 ID（用于 API 调用）

// 颜色资源
$r('app.color.primary_blue_light')

// 媒体资源
$r('app.media.layered_image')

// 浮点数资源
$r('app.float.font_size')
```

### 9.2 条件选择资源
```typescript
// 根据深色模式选择颜色
.fontColor(this.isDarkMode ?
  $r('app.color.text_primary_dark') :
  $r('app.color.text_primary_light'))

// 根据语言选择文本
Button(this.currentLanguage.startsWith('zh') ?
  $r('app.string.language_chinese') :
  $r('app.string.language_english'))
```

---

## 十、最佳实践总结

### 10.1 资源管理
✅ **推荐**:
- 所有字符串使用资源文件
- 所有颜色使用资源文件
- 图片使用 media 目录
- 配置使用 profile 目录

❌ **避免**:
- 硬编码字符串
- 硬编码颜色值
- 直接在代码中写路径

### 10.2 国际化
✅ **推荐**:
- 为每种语言创建独立的资源目录
- base 目录提供默认值
- 使用占位符 `%s` 处理动态文本

### 10.3 状态管理
✅ **推荐**:
- 使用 `@State` 管理 UI 状态
- 将业务逻辑提取到方法中
- 使用 Preferences 持久化关键数据

### 10.4 测试
✅ **推荐**:
- 单元测试覆盖工具类
- 集成测试覆盖关键流程
- 使用 Mock 隔离外部依赖

---

## 十一、常见问题

### Q1: 为什么有 dark 目录但是为空？
A: 本项目采用在同一个资源文件中定义 light/dark 变体的方式，通过代码条件判断选择。dark 目录可以删除。

### Q2: 如何添加新的页面？
A:
1. 在 `ets/pages/` 下创建新的 `.ets` 文件
2. 在 `main_pages.json` 中添加页面路径
3. 使用 `router.pushUrl()` 导航

### Q3: 如何调试？
A:
- 使用 `hilog.info()` 打印日志
- 使用 DevEco Studio 的调试器
- 查看 hdc shell hilog

### Q4: 资源 ID 如何生成？
A: 构建时自动生成在 `build/` 目录下的 `ResourceTable.ets` 文件中

---

## 十二、文件清单速查表

| 路径 | 类型 | 作用 |
|------|------|------|
| `oh-package.json5` | 配置 | 项目依赖 |
| `hvigorfile.ts` | 构建 | 构建配置 |
| `AppScope/app.json5` | 配置 | 应用全局配置 |
| `entry/module.json5` | 配置 | Module 配置 |
| `EntryAbility.ets` | 代码 | 应用生命周期 |
| `EntryBackupAbility.ets` | 代码 | 数据备份 |
| `Index.ets` | 代码 | 主页面 |
| `StringUtil.ets` | 代码 | 字符串工具 |
| `I18nUtil.ets` | 代码 | 国际化工具 |
| `color.json` | 资源 | 颜色定义 |
| `string.json` | 资源 | 文本定义 |
| `main_pages.json` | 配置 | 页面路由 |
| `LocalUnit.test.ets` | 测试 | 单元测试 |
| `Ability.test.ets` | 测试 | 集成测试 |
| `mock-config.json5` | 测试 | Mock 配置 |

---

## 总结

本项目展示了 HarmonyOS 应用开发的完整结构：
- **清晰的目录分层**: AppScope（应用级）→ Module（模块级）→ 源码/资源/测试
- **完善的资源管理**: 国际化、主题化、类型化
- **规范的代码组织**: Ability、Page、Utils 分离
- **完整的测试体系**: 单元测试、集成测试、Mock 测试
- **标准的构建流程**: Hvigor 工具链

这个项目结构是 HarmonyOS 应用的标准模板，理解它对后续开发至关重要。
