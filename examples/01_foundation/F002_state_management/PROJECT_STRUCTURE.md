# F002 项目结构说明

本文档详细说明 F002 状态管理进阶案例的项目结构和各文件职责。

## 📁 目录结构

```
F002_state_management/
├── entry/                                # 应用入口模块
│   ├── src/
│   │   ├── main/                         # 主代码
│   │   │   ├── ets/                      # ArkTS 源代码
│   │   │   │   ├── entryability/         # Ability 入口
│   │   │   │   │   └── EntryAbility.ets  # 应用入口 Ability
│   │   │   │   ├── pages/                # 页面
│   │   │   │   │   └── Index.ets         # 主页面 (167 行)
│   │   │   │   ├── components/           # 自定义组件
│   │   │   │   │   ├── CounterCard.ets   # @Prop 演示组件 (100 行)
│   │   │   │   │   ├── SyncCard.ets      # @Link 演示组件 (95 行)
│   │   │   │   │   └── SharedCard.ets    # @Provide/@Consume 演示组件 (160 行)
│   │   │   │   └── utils/                # 工具类
│   │   │   │       └── StateManager.ets  # 状态管理工具类 (127 行)
│   │   │   ├── resources/                # 资源文件
│   │   │   │   ├── base/                 # 默认资源
│   │   │   │   │   ├── element/
│   │   │   │   │   │   ├── string.json   # 基础字符串资源
│   │   │   │   │   │   └── color.json    # 颜色资源（24 个颜色定义）
│   │   │   │   │   ├── media/
│   │   │   │   │   │   ├── layered_image.json
│   │   │   │   │   │   └── startIcon.png
│   │   │   │   │   └── profile/
│   │   │   │   │       ├── main_pages.json
│   │   │   │   │       └── backup_config.json
│   │   │   │   ├── zh_CN/                # 中文资源
│   │   │   │   │   └── element/
│   │   │   │   │       └── string.json   # 中文字符串（23 个）
│   │   │   │   └── en_US/                # 英文资源
│   │   │   │       └── element/
│   │   │   │           └── string.json   # 英文字符串（23 个）
│   │   │   └── module.json5              # 模块配置
│   │   ├── test/                         # 单元测试
│   │   │   ├── StateManager.test.ets     # StateManager 测试（202 行，55 个测试用例）
│   │   │   └── List.test.ets             # 测试套件入口
│   │   └── ohosTest/                     # UI 自动化测试
│   │       ├── ets/
│   │       │   ├── test/
│   │       │   │   ├── Ability.test.ets
│   │       │   │   └── List.test.ets
│   │       │   ├── testability/
│   │       │   │   └── TestAbility.ets
│   │       │   └── testrunner/
│   │       │       └── OpenHarmonyTestRunner.ets
│   │       └── resources/
│   ├── build-profile.json5               # 构建配置
│   └── hvigorfile.ts                     # Hvigor 构建脚本
├── AppScope/                             # 应用全局配置
│   ├── resources/
│   │   └── base/
│   │       └── element/
│   │           └── string.json           # 应用名称等
│   └── app.json5                         # 应用配置
├── oh-package.json5                      # 依赖配置
├── hvigorfile.ts                         # 根构建脚本
├── build-profile.json5                   # 根构建配置
├── README.md                             # 项目说明文档
├── UNIT_TESTING.md                       # 单元测试文档
└── PROJECT_STRUCTURE.md                  # 本文档
```

## 📄 核心文件说明

### 1. Index.ets - 主页面

**文件路径**: `entry/src/main/ets/pages/Index.ets`
**行数**: 167 行
**职责**:

- 应用主页面，演示所有状态管理装饰器
- 管理全局状态（globalCounter、message、isExpanded）
- 通过 @Provide 向子组件提供共享状态
- 集成 CounterCard、SyncCard、SharedCard 三个子组件

**核心代码结构**:

```typescript
@Entry
@Component
struct Index {
  // @State 状态
  @State private globalCounter: number = 0;
  @State private message: string = '欢迎学习状态管理';
  @State private isExpanded: boolean = false;

  // @Provide 共享状态
  @Provide('sharedCount') sharedCount: number = 0;
  @Provide('sharedText') sharedText: string = '共享状态';

  // 状态操作方法
  private incrementGlobal(): void { ... }
  private decrementGlobal(): void { ... }
  private resetGlobal(): void { ... }
  private toggleExpand(): void { ... }

  // UI 构建
  build() { ... }
}
```

### 2. StateManager.ets - 状态管理工具类

**文件路径**: `entry/src/main/ets/utils/StateManager.ets`
**行数**: 127 行
**职责**:

- 提供状态验证、格式化、计算等工具方法
- 支持组件逻辑复用
- 所有方法都是静态方法，可直接调用

**方法列表**:
| 方法 | 功能 | 参数 | 返回值 |
|------|------|------|--------|
| `isValidState()` | 验证状态是否有效 | value | boolean |
| `formatCounter()` | 格式化计数器显示 | count | string |
| `add()` | 加法运算 | a, b | number |
| `subtract()` | 减法运算 | a, b | number |
| `reset()` | 重置计数器 | currentValue, resetValue | number |
| `isValidInput()` | 验证输入是否有效 | text | boolean |
| `syncValue()` | 同步状态值 | sourceValue, targetValue | T |
| `reachedThreshold()` | 检查是否达到阈值 | count, threshold | boolean |
| `formatPercentage()` | 格式化百分比 | value, max | string |
| `toggleBoolean()` | 切换布尔值 | current | boolean |
| `isInRange()` | 验证是否在范围内 | value, min, max | boolean |
| `clamp()` | 限制值在范围内 | value, min, max | number |

### 3. CounterCard.ets - @Prop 演示组件

**文件路径**: `entry/src/main/ets/components/CounterCard.ets`
**行数**: 100 行
**职责**:

- 演示 @Prop 装饰器的单向数据传递
- 展示父组件值和本地值的差异
- 提供同步功能，从父组件重新获取值

**核心代码结构**:

```typescript
@Component
export struct CounterCard {
  @Prop initialCount: number = 0;  // 从父组件接收的值（只读）
  @State private localCount: number = 0;  // 组件内部状态

  aboutToAppear(): void {
    this.localCount = this.initialCount;  // 初始化
  }

  private increment(): void { this.localCount++; }
  private decrement(): void { this.localCount--; }
  private syncFromParent(): void {
    this.localCount = this.initialCount;  // 从父组件同步
  }
}
```

### 4. SyncCard.ets - @Link 演示组件

**文件路径**: `entry/src/main/ets/components/SyncCard.ets`
**行数**: 95 行
**职责**:

- 演示 @Link 装饰器的双向数据绑定
- 子组件修改会自动同步到父组件
- 提供增加、减少、重置、设置特定值功能

**核心代码结构**:

```typescript
@Component
export struct SyncCard {
  @Link syncValue: number;  // 与父组件双向绑定

  private increment(): void {
    this.syncValue++;  // 修改会同步到父组件
  }

  private decrement(): void {
    this.syncValue--;
  }

  private reset(): void {
    this.syncValue = StateManager.reset(this.syncValue, 0);
  }

  private setValue(value: number): void {
    this.syncValue = value;
  }
}
```

### 5. SharedCard.ets - @Provide/@Consume 演示组件

**文件路径**: `entry/src/main/ets/components/SharedCard.ets`
**行数**: 160 行
**职责**:

- 演示 @Provide/@Consume 跨层级状态共享
- 包含三个子组件：SharedCountDisplay、SharedTextDisplay、SharedControl
- 展示如何在嵌套组件中消费祖先组件提供的状态

**组件结构**:

```
SharedCard (容器组件)
├── SharedCountDisplay (消费 sharedCount)
├── SharedTextDisplay (消费 sharedText)
└── SharedControl (消费并修改 sharedCount 和 sharedText)
```

**核心代码结构**:

```typescript
// 主组件
@Component
export struct SharedCard {
  build() {
    Column() {
      SharedCountDisplay()
      SharedTextDisplay()
      SharedControl()
    }
  }
}

// 显示组件
@Component
struct SharedCountDisplay {
  @Consume('sharedCount') sharedCount: number;  // 消费共享状态
}

// 控制组件
@Component
struct SharedControl {
  @Consume('sharedCount') sharedCount: number;
  @Consume('sharedText') sharedText: string;

  private incrementShared(): void {
    this.sharedCount++;  // 修改共享状态
  }
}
```

## 🧪 测试文件说明

### StateManager.test.ets

**文件路径**: `entry/src/test/StateManager.test.ets`
**行数**: 202 行
**测试用例数**: 55 个
**覆盖率**: 100%

**测试结构**:

```
StateManager_Test
├── isValidState_method (5 个测试)
├── formatCounter_method (3 个测试)
├── add_method (4 个测试)
├── subtract_method (4 个测试)
├── reset_method (2 个测试)
├── isValidInput_method (5 个测试)
├── syncValue_method (3 个测试)
├── reachedThreshold_method (3 个测试)
├── formatPercentage_method (5 个测试)
├── toggleBoolean_method (3 个测试)
├── isInRange_method (3 个测试)
└── clamp_method (4 个测试)
```

## 📦 资源文件说明

### 颜色资源 (color.json)

定义了 24 个颜色常量：

- 主题色: primary_blue, danger_red, success_green, warning_orange
- 功能色: purple, deep_purple, indigo, teal, pink, light_green, orange, light_blue, deep_orange
- 文本色: text_primary, text_secondary, text_tertiary
- 背景色: bg_page, bg_card, bg_light_gray, bg_medium_gray, bg_orange_light, bg_blue_light
- 阴影色: shadow_color

### 字符串资源 (string.json)

**base/element/string.json** (基础资源，3 个):

- module_desc: 模块描述
- EntryAbility_desc: Ability 描述
- EntryAbility_label: Ability 标签

**zh_CN/element/string.json** (中文资源，23 个):

- 页面文本: welcome_message, global_state, prop_demo, link_demo 等
- 按钮文本: button_increment, button_decrement, button_reset, button_sync
- 说明文本: prop_description, link_description, provide_consume_description

**en_US/element/string.json** (英文资源，23 个):

- 对应中文资源的英文翻译

## 🏗️ 构建配置说明

### oh-package.json5

```json5
{
  name: "f002-state-management",
  version: "1.0.0",
  description: "HarmonyOS 状态管理进阶案例",
  modelVersion: "6.0.0",
  dependencies: {},
  devDependencies: {
    "@ohos/hypium": "1.0.24", // 单元测试框架
    "@ohos/hamock": "1.0.0", // Mock 框架
  },
}
```

### app.json5

```json5
{
  app: {
    bundleName: "top.mqxu.f002statemanagement",
    vendor: "mqxu",
    versionCode: 1000000,
    versionName: "1.0.0",
  },
}
```

## 📊 代码统计

| 文件类型   | 文件数 | 总行数       |
| ---------- | ------ | ------------ |
| ArkTS 源码 | 9      | 839 行       |
| 单元测试   | 2      | 204 行       |
| 资源文件   | 10     | 350 行       |
| 文档       | 3      | 800+ 行      |
| **总计**   | **24** | **2193+ 行** |

### 详细统计

**源码文件**:

- Index.ets: 167 行
- StateManager.ets: 127 行
- CounterCard.ets: 100 行
- SyncCard.ets: 95 行
- SharedCard.ets: 160 行
- EntryAbility.ets: 50 行
- EntryBackupAbility.ets: 60 行
- TestAbility.ets: 40 行
- OpenHarmonyTestRunner.ets: 40 行

**测试文件**:

- StateManager.test.ets: 202 行
- List.test.ets: 2 行

**文档文件**:

- README.md: 500+ 行
- PROJECT_STRUCTURE.md (本文档): 200+ 行
- UNIT_TESTING.md: 100+ 行

## 🎯 关键设计决策

### 1. 为什么选择 @Provide/@Consume？

在 SharedCard 中使用 @Provide/@Consume 而不是 props 逐层传递，原因：

- ✅ 避免中间组件传递不需要的数据
- ✅ 简化组件接口
- ✅ 更灵活的组件组合
- ✅ 更好的可维护性

### 2. 为什么 StateManager 使用静态方法？

- ✅ 工具类无需实例化，直接调用
- ✅ 更好的性能（无需创建对象）
- ✅ 更清晰的调用方式 `StateManager.method()`
- ✅ 符合函数式编程范式

### 3. 为什么分离 @Prop 和 @Link 示例？

- ✅ 清晰展示两者的区别
- ✅ 避免混淆概念
- ✅ 更好的学习体验
- ✅ 独立的演示场景

### 4. 为什么使用多语言资源？

- ✅ 展示国际化最佳实践
- ✅ 演示 @Provide/@Consume 的应用场景
- ✅ 提供完整的项目示例
- ✅ 为后续多语言案例铺垫

## 📝 命名规范

### 组件命名

- **页面组件**: Index（大驼峰）
- **自定义组件**: CounterCard、SyncCard、SharedCard（大驼峰）
- **私有组件**: SharedCountDisplay、SharedTextDisplay（大驼峰）

### 文件命名

- **ArkTS 文件**: PascalCase.ets（如 `CounterCard.ets`）
- **测试文件**: PascalCase.test.ets（如 `StateManager.test.ets`）
- **配置文件**: kebab-case.json5（如 `build-profile.json5`）
- **文档文件**: SCREAMING_SNAKE_CASE.md（如 `README.md`）

### 变量命名

- **状态变量**: camelCase（如 `globalCounter`）
- **私有变量**: private camelCase（如 `private localCount`）
- **常量**: SCREAMING_SNAKE_CASE（如 `MAX_COUNT`）
- **方法**: camelCase（如 `incrementGlobal()`）

### 资源命名

- **颜色**: snake_case（如 `primary_blue`）
- **字符串**: snake_case（如 `welcome_message`）
- **图片**: snake_case（如 `layered_image.png`）

## 🔗 文件依赖关系

```
Index.ets
├── import StateManager from '../utils/StateManager'
├── import CounterCard from '../components/CounterCard'
├── import SyncCard from '../components/SyncCard'
└── import SharedCard from '../components/SharedCard'

CounterCard.ets
└── import StateManager from '../utils/StateManager'

SyncCard.ets
└── import StateManager from '../utils/StateManager'

SharedCard.ets
└── import StateManager from '../utils/StateManager'

StateManager.test.ets
└── import StateManager from '../../../main/ets/utils/StateManager'
```

## 📖 扩展阅读

- [HarmonyOS 项目结构](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/start-overview)
- [ArkTS 模块化开发](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-module)
- [资源文件管理](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/resource-categories-and-access)

---

**更新时间**: 2025-10-04
**项目版本**: 1.0.0
**HarmonyOS 版本**: 6.0.0 (API 20)
