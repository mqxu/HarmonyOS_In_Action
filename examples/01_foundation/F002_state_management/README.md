# F002 - 状态管理进阶

## 📝 案例简介

深入学习 HarmonyOS 状态管理装饰器的使用，通过实战案例掌握 `@State`、`@Prop`、`@Link`、`@Watch`、`@Provide`、`@Consume` 的应用场景和最佳实践。

## 🎯 学习目标

- ✅ 掌握 @State 管理组件内部状态
- ✅ 理解 @Prop 单向数据传递
- ✅ 掌握 @Link 双向数据绑定
- ✅ 学会使用 @Watch 监听状态变化
- ✅ 掌握 @Provide/@Consume 跨层级状态共享
- ✅ 理解不同状态装饰器的适用场景

## 🔧 核心 API

| API        | 说明                                 | 文档链接                                                                                                   |
| ---------- | ------------------------------------ | ---------------------------------------------------------------------------------------------------------- |
| `@State`   | 组件内部状态，变化时触发 UI 刷新     | [@State 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state)                 |
| `@Prop`    | 单向数据传递，父组件传值给子组件     | [@Prop 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-prop)                   |
| `@Link`    | 双向数据绑定，子组件可修改父组件状态 | [@Link 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-link)                   |
| `@Watch`   | 监听状态变化并执行回调               | [@Watch 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-watch)                 |
| `@Provide` | 提供数据给后代组件                   | [@Provide 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-provide-and-consume) |
| `@Consume` | 消费祖先组件提供的数据               | [@Consume 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-provide-and-consume) |

## 📂 项目结构

```
F002_state_management/
├── entry/
│   ├── src/
│   │   ├── main/
│   │   │   ├── ets/
│   │   │   │   ├── entryability/
│   │   │   │   │   └── EntryAbility.ets
│   │   │   │   ├── pages/
│   │   │   │   │   └── Index.ets              # 主页面 - 演示各种装饰器
│   │   │   │   ├── components/
│   │   │   │   │   ├── CounterCard.ets        # @Prop 演示组件
│   │   │   │   │   ├── SyncCard.ets           # @Link 演示组件
│   │   │   │   │   └── SharedCard.ets         # @Provide/@Consume 演示组件
│   │   │   │   └── utils/
│   │   │   │       └── StateManager.ets       # 状态管理工具类
│   │   │   ├── resources/                     # 资源文件
│   │   │   │   ├── base/element/
│   │   │   │   │   ├── string.json
│   │   │   │   │   └── color.json
│   │   │   │   ├── zh_CN/element/             # 中文资源
│   │   │   │   └── en_US/element/             # 英文资源
│   │   │   └── module.json5
│   │   ├── test/                              # 单元测试
│   │   │   ├── StateManager.test.ets          # StateManager 测试（100% 覆盖率）
│   │   │   └── List.test.ets
│   │   └── ohosTest/                          # UI 测试
│   ├── build-profile.json5
│   └── hvigorfile.ts
├── AppScope/
│   ├── resources/
│   └── app.json5
├── oh-package.json5
├── README.md
├── UNIT_TESTING.md
└── PROJECT_STRUCTURE.md
```

## 💻 核心代码

### 1. StateManager.ets - 状态管理工具类

```typescript
export class StateManager {
  // 验证状态值是否有效
  static isValidState(
    value: number | string | boolean | null | undefined
  ): boolean {
    return value !== null && value !== undefined;
  }

  // 格式化计数器显示
  static formatCounter(count: number): string {
    if (count < 0) {
      return `计数: ${count} (负数)`;
    } else if (count === 0) {
      return `计数: ${count} (初始值)`;
    } else {
      return `计数: ${count}`;
    }
  }

  // 加减运算
  static add(a: number, b: number): number {
    return a + b;
  }
  static subtract(a: number, b: number): number {
    return a - b;
  }

  // 重置计数
  static reset(currentValue: number, resetValue: number = 0): number {
    return resetValue;
  }

  // 其他工具方法...
}
```

### 2. Index.ets - 主页面

```typescript
@Entry
@Component
struct Index {
  // @State: 组件内部状态
  @State private globalCounter: number = 0;
  @State private message: string = '欢迎学习状态管理';
  @State private isExpanded: boolean = false;

  // @Provide: 向子组件提供数据
  @Provide('sharedCount') sharedCount: number = 0;
  @Provide('sharedText') sharedText: string = '共享状态';

  build() {
    Column({ space: 16 }) {
      // 全局状态展示
      Text(StateManager.formatCounter(this.globalCounter))

      // @Prop 演示
      CounterCard({ initialCount: this.globalCounter })

      // @Link 演示
      SyncCard({ syncValue: this.globalCounter })

      // @Provide/@Consume 演示
      if (this.isExpanded) {
        SharedCard()
      }
    }
  }
}
```

### 3. CounterCard.ets - @Prop 演示

```typescript
@Component
export struct CounterCard {
  // @Prop: 只读，单向数据传递
  @Prop initialCount: number = 0;
  @State private localCount: number = 0;

  aboutToAppear(): void {
    this.localCount = this.initialCount;  // 初始化本地状态
  }

  build() {
    Column() {
      Text(`父组件值: ${this.initialCount}`)
      Text(`本地值: ${this.localCount}`)

      Button('同步')
        .onClick(() => {
          this.localCount = this.initialCount;  // 从父组件同步
        })

      Text('说明: @Prop 只能单向接收，本地修改不影响父组件')
    }
  }
}
```

### 4. SyncCard.ets - @Link 演示

```typescript
@Component
export struct SyncCard {
  // @Link: 双向绑定，修改会同步到父组件
  @Link syncValue: number;

  build() {
    Column() {
      Text(StateManager.formatCounter(this.syncValue))

      Button('增加')
        .onClick(() => {
          this.syncValue++;  // 修改会同步到父组件
        })

      Text('说明: @Link 双向绑定，子组件修改会同步到父组件')
    }
  }
}
```

### 5. SharedCard.ets - @Provide/@Consume 演示

```typescript
@Component
export struct SharedCard {
  build() {
    Column() {
      SharedCountDisplay()   // 嵌套子组件，消费共享状态
      SharedControl()        // 控制组件，修改共享状态
    }
  }
}

@Component
struct SharedCountDisplay {
  // @Consume: 消费父组件提供的数据
  @Consume('sharedCount') sharedCount: number;

  build() {
    Text(`共享计数: ${this.sharedCount}`)
  }
}

@Component
struct SharedControl {
  @Consume('sharedCount') sharedCount: number;

  build() {
    Button('增加计数')
      .onClick(() => {
        this.sharedCount++;  // 修改共享状态
      })
  }
}
```

## 🔍 装饰器对比

### @State vs @Prop vs @Link

| 特性           | @State       | @Prop            | @Link            |
| -------------- | ------------ | ---------------- | ---------------- |
| 数据流向       | 组件内部     | 父 → 子（单向）  | 父 ↔ 子（双向）  |
| 子组件可修改   | ✅           | ❌               | ✅               |
| 修改影响父组件 | N/A          | ❌               | ✅               |
| 适用场景       | 组件私有状态 | 父组件配置子组件 | 表单输入、开关等 |

### @Provide vs @Consume

| 特性     | @Provide               | @Consume       |
| -------- | ---------------------- | -------------- |
| 作用     | 提供数据               | 消费数据       |
| 层级限制 | 无（可跨多层）         | 无（可跨多层） |
| 数据流向 | 祖先 → 后代            | 后代 ← 祖先    |
| 修改影响 | ✅ 影响所有消费者      | ✅ 影响提供者  |
| 适用场景 | 主题、国际化等全局状态 | 跨层级数据共享 |

## 🚀 运行步骤

### 1. 使用 DevEco Studio

1. 打开 DevEco Studio
2. File → Open → 选择 `F002_state_management` 目录
3. 等待项目同步完成
4. 连接设备或启动模拟器
5. 点击 Run 按钮

### 2. 使用命令行

```bash
# 进入项目目录
cd examples/01_foundation/F002_state_management

# 安装依赖
ohpm install

# 构建项目（需配置环境变量）
export DEVECO_SDK_HOME="/Applications/DevEco-Studio.app/Contents/sdk"
hvigorw assembleHap

# 安装到设备
hdc install entry/build/default/outputs/default/entry-default-unsigned.hap

# 启动应用
hdc shell aa start -a EntryAbility -b top.mqxu.f002statemanagement
```

### 3. 运行单元测试

```bash
# 运行所有测试
npm run test

# 查看测试覆盖率
npm run test:coverage
```

## ✅ 功能验证

运行应用后，验证以下功能：

### 基础功能

- [ ] 全局计数器增加/减少/重置功能正常
- [ ] 页面切换和状态保持正常

### @Prop 演示

- [ ] CounterCard 显示父组件值
- [ ] CounterCard 本地修改不影响父组件
- [ ] 点击"同步"按钮可从父组件同步值

### @Link 演示

- [ ] SyncCard 修改值时父组件同步更新
- [ ] 父组件修改时 SyncCard 同步更新
- [ ] 设置特定值功能正常

### @Provide/@Consume 演示

- [ ] SharedCard 展示共享计数和文本
- [ ] 修改共享状态时所有消费者同步更新
- [ ] 跨层级数据传递正常

## 📚 进阶练习

### 练习 1: 添加 @Watch 监听器

**目标**: 监听全局计数变化并记录日志

**实现步骤**:

```typescript
@Entry
@Component
struct Index {
  @State @Watch('onCounterChange') globalCounter: number = 0;

  private onCounterChange(): void {
    console.log(`计数器变化: ${this.globalCounter}`);
    // 可以在这里执行副作用操作
  }
}
```

### 练习 2: 实现计数器历史记录

**目标**: 使用 @State 管理历史记录数组

**实现步骤**:

```typescript
@State private history: number[] = [];

private addToHistory(): void {
  this.history.push(this.globalCounter);
}
```

### 练习 3: 实现多主题切换

**目标**: 使用 @Provide/@Consume 管理主题状态

**实现步骤**:

```typescript
@Provide('currentTheme') currentTheme: string = 'light';

// 子组件消费主题
@Consume('currentTheme') currentTheme: string;
```

## 🎓 知识点总结

### 核心概念

1. **@State**: 组件私有状态，适用于组件内部数据
2. **@Prop**: 单向数据流，父组件配置子组件
3. **@Link**: 双向绑定，适用于表单输入、开关等
4. **@Provide/@Consume**: 跨层级状态共享，避免逐层传递

### 最佳实践

1. **选择合适的装饰器**:

   - 数据只在组件内部使用 → `@State`
   - 子组件只读数据 → `@Prop`
   - 子组件需要修改父组件数据 → `@Link`
   - 跨多层组件传递数据 → `@Provide/@Consume`

2. **避免过度使用 @Link**:

   - @Link 会增加组件耦合度
   - 如果不需要双向绑定，优先使用 @Prop

3. **合理使用 @Provide/@Consume**:

   - 适用于全局状态（主题、国际化）
   - 避免滥用，导致数据流难以追踪

4. **性能优化**:
   - 只在必要的状态上使用装饰器
   - 避免在大对象上使用 @State（会导致全量更新）
   - 使用 @ObjectLink/@Observed 处理复杂对象

## 🔗 参考资料

- [ArkTS 状态管理概述](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state-management-overview)
- [@State 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-state)
- [@Prop 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-prop)
- [@Link 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-link)
- [@Provide/@Consume 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-provide-and-consume)
- [@Watch 装饰器](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/arkts-watch)

## ❓ 常见问题

### Q1: @Prop 和 @Link 如何选择？

**A**:

- 如果子组件只需要读取父组件的值，使用 `@Prop`
- 如果子组件需要修改父组件的值，使用 `@Link`

### Q2: @Provide/@Consume 和 props 逐层传递如何选择？

**A**:

- 层级少于 3 层：使用 props 逐层传递（更清晰）
- 层级大于等于 3 层：使用 @Provide/@Consume（避免中间层传递）

### Q3: @State 修改对象属性为什么不触发更新？

**A**:
@State 只监听对象引用变化，不监听属性变化。解决方案：

- 方案 1: 使用 `this.obj = { ...this.obj, prop: newValue }`（创建新对象）
- 方案 2: 使用 `@Observed` 和 `@ObjectLink` 装饰器

### Q4: 如何调试状态变化？

**A**:

- 使用 `@Watch` 监听状态变化并打印日志
- 使用 DevEco Studio 的调试工具查看状态

## 📝 下一步

完成本案例后，建议继续学习：

- **F003 - 列表渲染与优化**: 学习 List、LazyForEach 的使用
- **F004 - 网络请求**: 掌握 HTTP 请求和数据处理
- **U002 - List 高性能列表**: 深入学习列表优化技巧

---

**难度**: 🟡 中级
**预计时间**: 60 分钟
**前置知识**: F001 基础知识、TypeScript
**适合人群**: 有 HarmonyOS 基础的开发者
