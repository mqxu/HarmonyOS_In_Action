# F004 - 自定义组件与复用

## 📚 案例简介

本案例演示 HarmonyOS 中自定义组件的创建和复用技术，重点讲解三个核心装饰器：
- **@Component** - 创建自定义组件
- **@Builder** - 创建轻量级UI构建函数
- **@BuilderParam** - 实现组件内容定制

## 🎯 学习目标

- 掌握 `@Component` 装饰器创建可复用组件
- 学会使用 `@Prop` 接收父组件数据
- 理解 `@Builder` 的使用场景和优势
- 掌握 `@BuilderParam` 实现组件插槽功能
- 学习组件的属性默认值设置

## 🏗️ 项目结构

```
F004_custom_components/
├── entry/src/main/ets/
│   ├── models/
│   │   ├── User.ets              # 用户数据模型
│   │   └── Article.ets           # 文章数据模型
│   ├── components/
│   │   ├── UserCard.ets          # 用户卡片组件（@Component）
│   │   └── ArticleCard.ets       # 文章卡片组件（@Builder + @BuilderParam）
│   └── pages/
│       ├── Index.ets             # 主页（案例总览）
│       ├── CustomComponentPage.ets  # @Component 详解页
│       └── BuilderPage.ets       # @Builder + @BuilderParam 详解页
└── README.md
```

## 💡 核心知识点

### 1. @Component 自定义组件

`@Component` 用于创建可复用的自定义组件，封装 UI 结构和业务逻辑。

**UserCard.ets 示例**：

```typescript
@Component
export struct UserCard {
  @Prop user: User;            // 接收父组件数据
  @Prop cardWidth: number = 300; // 带默认值的属性
  @Prop showActions: boolean = true;

  build() {
    Column({ space: 12 }) {
      Image(this.user.avatar)
        .width(80)
        .height(80)
        .borderRadius(40)

      Text(this.user.name)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)

      if (this.showActions) {
        Row({ space: 12 }) {
          Button('关注')
          Button('私信')
        }
      }
    }
    .width(this.cardWidth)
    .padding(16)
  }
}
```

**使用组件**：

```typescript
UserCard({
  user: user,
  cardWidth: 300,
  showActions: true
})
```

### 2. @Builder 构建函数

`@Builder` 用于创建轻量级的 UI 构建函数，适合组件内部的 UI 复用。

**ArticleCard.ets 示例**：

```typescript
@Component
export struct ArticleCard {
  @Prop article: Article;

  // Builder 定义可复用的 UI 片段
  @Builder
  ActionButton(icon: string, text: string) {
    Row({ space: 4 }) {
      Text(icon).fontSize(16)
      Text(text).fontSize(13)
    }
  }

  @Builder
  defaultFooter() {
    Row({ space: 24 }) {
      this.ActionButton('❤️', this.article.likes.toString())
      this.ActionButton('💬', this.article.comments.toString())
      this.ActionButton('🔖', '收藏')
      this.ActionButton('📤', '分享')
    }
  }

  build() {
    Column() {
      // ... 文章内容
      this.defaultFooter()
    }
  }
}
```

### 3. @BuilderParam 插槽定制

`@BuilderParam` 允许组件接收外部传入的 Builder 函数，实现高度定制化。

**组件定义**：

```typescript
@Component
export struct ArticleCard {
  @Prop article: Article;
  @BuilderParam customHeader: () => void = this.defaultHeader;
  @BuilderParam customFooter: () => void = this.defaultFooter;

  @Builder
  defaultHeader() {
    // 默认头部 UI
  }

  @Builder
  defaultFooter() {
    // 默认底部 UI
  }

  build() {
    Column() {
      this.customHeader()  // 使用传入的或默认的头部
      // ... 文章内容
      this.customFooter()  // 使用传入的或默认的底部
    }
  }
}
```

**自定义使用**：

```typescript
// 定义自定义 Builder
@Builder
myCustomHeader() {
  Row() {
    Image('👤').width(32).height(32)
    Text(this.article.author)
  }
}

// 传入自定义 Builder
ArticleCard({
  article: article,
  customHeader: () => { this.myCustomHeader() }
})
```

## 🎨 设计模式

### 组件复用模式

1. **纯展示组件** - 只接收数据，不包含状态
2. **容器组件** - 管理状态，传递数据给子组件
3. **插槽组件** - 使用 @BuilderParam 提供定制点

### 颜色资源

使用统一的颜色资源系统（`$r('app.color.xxx')`）：

```typescript
.fontColor($r('app.color.text_primary'))    // 主文本颜色
.backgroundColor($r('app.color.bg_primary')) // 主背景色
.fontColor($r('app.color.brand_primary'))   // 品牌主色
```

## 🚀 运行项目

### 前置要求

- DevEco Studio ≥ 5.0.0
- HarmonyOS SDK ≥ 6.0.0 (API 20)

### 运行步骤

```bash
# 1. 进入项目目录
cd examples/01_foundation/F004_custom_components

# 2. 构建项目
hvigorw assembleHap

# 3. 安装到设备
hdc install entry/build/default/outputs/default/entry-default-unsigned.hap
```

## 📸 效果展示

### 主页
- 展示用户卡片组件（@Component）
- 展示文章卡片组件（@Builder + @BuilderParam）
- 导航到详细页面

### CustomComponentPage
- 实时预览用户卡片
- 动态调整组件属性（宽度、显示操作按钮）
- 切换用户数据

### BuilderPage
- 切换使用默认/自定义头部
- 切换使用默认/自定义底部
- 对比展示定制效果

## 🔑 关键技术点

### 1. 类型安全
- 所有变量强制类型声明
- 禁止使用 `any` 类型
- 使用数据模型类（User, Article）

### 2. 路由导航
- 使用新路由 API：`getUIContext().getRouter()`
- Promise 异常处理：`.catch((error: Error) => {...})`
- 使用 hilog 记录错误

### 3. 组件通信
- 父→子：通过 `@Prop` 传递数据
- 子→父：通过回调函数
- UI定制：通过 `@BuilderParam`

## 📖 扩展阅读

- [ArkTS 装饰器官方文档](https://developer.huawei.com/consumer/cn/doc/)
- [@Component 详解](https://developer.huawei.com/consumer/cn/doc/)
- [@Builder 和 @BuilderParam 使用指南](https://developer.huawei.com/consumer/cn/doc/)

## ⚠️ 注意事项

1. `@Prop` 装饰的属性是单向数据流，子组件不能直接修改
2. `@Builder` 函数不能有返回值
3. `@BuilderParam` 需要通过箭头函数传递：`() => { this.myBuilder() }`
4. Builder 函数内部可以访问组件的状态和属性

## 🎓 总结

本案例系统地演示了 HarmonyOS 自定义组件的三种核心技术：

- **@Component** - 创建封装完整功能的自定义组件
- **@Builder** - 在组件内部复用 UI 片段
- **@BuilderParam** - 实现组件的高度定制化

掌握这三个装饰器，是开发复杂鸿蒙应用的基础！

---

**案例编号**: F004
**难度级别**: 🟡 中级
**核心API**: @Component, @Builder, @BuilderParam
**相关案例**: F001(Hello World), F002(状态管理), F003(列表渲染)
