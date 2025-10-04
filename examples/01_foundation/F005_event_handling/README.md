# F005 - 事件处理与手势

## 📚 案例简介

本案例全面演示 HarmonyOS 中的事件处理机制和手势识别系统，涵盖基础事件（onClick、onTouch、onHover）和 7 种手势类型（Tap、LongPress、Pan、Swipe、Pinch、Rotation、手势组合）的实战应用。

## 🎯 学习目标

通过本案例，你将掌握：

- ✅ 基础事件处理（onClick、onTouch、onHover）
- ✅ 手势识别系统（TapGesture、LongPressGesture、PanGesture）
- ✅ 高级手势（SwipeGesture、PinchGesture、RotationGesture）
- ✅ 手势组合模式（并行、互斥、顺序）
- ✅ 事件冒泡与阻止机制
- ✅ 触摸事件的详细信息获取

## 📁 项目结构

```
F005_event_handling/
├── entry/src/main/ets/
│   └── pages/
│       ├── Index.ets                    # 主页面，导航入口
│       ├── BasicEventPage.ets           # 基础事件处理示例
│       ├── GesturePage.ets              # 手势识别示例
│       ├── AdvancedGesturePage.ets      # 高级手势示例
│       └── GestureGroupPage.ets         # 手势组合示例
└── entry/src/main/resources/
    └── base/element/
        └── color.json                    # 统一配色方案
```

## 💡 核心知识点

### 1. 基础事件处理

#### onClick - 点击事件
```typescript
Button('点击我')
  .onClick(() => {
    this.clickCount++;
    hilog.info(0x0000, 'F005', `点击次数: ${this.clickCount}`);
  })
```

**特点**：
- 最常用的交互事件
- 支持点击计数和状态更新
- 可以添加防抖处理

#### onTouch - 触摸事件
```typescript
Column()
  .onTouch((event: TouchEvent) => {
    const touch: TouchObject | undefined = event.touches[0];
    if (touch) {
      const eventInfo: TouchEventInfo = {
        type: event.type === TouchType.Down ? '按下' :
              event.type === TouchType.Move ? '移动' :
              event.type === TouchType.Up ? '抬起' : '取消',
        x: Math.round(touch.x),
        y: Math.round(touch.y),
        timestamp: event.timestamp
      };
      // 处理触摸事件
    }
  })
```

**触摸类型**：
- `TouchType.Down` - 手指按下
- `TouchType.Move` - 手指移动
- `TouchType.Up` - 手指抬起
- `TouchType.Cancel` - 触摸取消

#### onHover - 悬停事件
```typescript
Column()
  .onHover((isHover: boolean) => {
    this.hoverStatus = isHover ? '鼠标悬停中' : '鼠标已离开';
  })
```

**适用场景**：
- 桌面应用的鼠标交互
- 悬停提示效果
- UI 状态反馈

### 2. 手势识别

#### TapGesture - 点击手势
```typescript
// 单击
TapGesture({ count: 1 })
  .onAction(() => {
    hilog.info(0x0000, 'F005', '单击触发');
  })

// 双击
TapGesture({ count: 2 })
  .onAction(() => {
    hilog.info(0x0000, 'F005', '双击触发');
  })
```

**参数**：
- `count`: 点击次数（1=单击，2=双击，3=三击...）

#### LongPressGesture - 长按手势
```typescript
LongPressGesture({ duration: 500 })
  .onAction(() => {
    this.longPressStatus = '长按触发！';
  })
  .onActionEnd(() => {
    this.longPressStatus = '长按结束';
  })
```

**参数**：
- `duration`: 长按触发时长（毫秒，默认 500ms）

#### PanGesture - 拖动手势
```typescript
PanGesture({ fingers: 1, distance: 5 })
  .onActionStart(() => {
    this.panInfo = '开始拖动';
  })
  .onActionUpdate((event: GestureEvent) => {
    this.offsetX = event.offsetX;
    this.offsetY = event.offsetY;
  })
  .onActionEnd(() => {
    this.panInfo = '拖动结束';
  })
```

**参数**：
- `fingers`: 手指数量
- `distance`: 最小识别距离（像素）

**应用场景**：
- 拖动元素
- 滑动控制
- 自定义滚动

### 3. 高级手势

#### SwipeGesture - 滑动手势
```typescript
SwipeGesture({ fingers: 1, direction: SwipeDirection.All })
  .onAction((event: GestureEvent) => {
    const angle: number = event.angle || 0;
    // 根据角度判断滑动方向
    if (angle > -45 && angle <= 45) {
      this.swipeDirection = '向右滑动';
    } else if (angle > 45 && angle <= 135) {
      this.swipeDirection = '向下滑动';
    }
    // ... 其他方向判断
  })
```

**滑动方向**：
- `SwipeDirection.Horizontal` - 水平
- `SwipeDirection.Vertical` - 垂直
- `SwipeDirection.All` - 所有方向

#### PinchGesture - 捏合手势
```typescript
PinchGesture({ fingers: 2 })
  .onActionUpdate((event: GestureEvent) => {
    if (event.scale !== undefined) {
      this.pinchScale = event.scale;
    }
  })
```

**应用场景**：
- 图片缩放
- 地图缩放
- 内容放大/缩小

#### RotationGesture - 旋转手势
```typescript
RotationGesture({ fingers: 2 })
  .onActionUpdate((event: GestureEvent) => {
    if (event.angle !== undefined) {
      this.rotationAngle = event.angle;
    }
  })
```

**应用场景**：
- 图片旋转
- 地图旋转
- 3D 模型控制

### 4. 手势组合

#### 并行识别 (Parallel)
```typescript
.parallelGesture(
  TapGesture().onAction(() => { /* 单击 */ }),
  LongPressGesture({ duration: 500 }).onAction(() => { /* 长按 */ })
)
```

**特点**：所有手势可以同时触发

#### 互斥识别 (Exclusive)
```typescript
.gesture(
  GestureGroup(GestureMode.Exclusive,
    TapGesture().onAction(() => { /* 单击 */ }),
    LongPressGesture({ duration: 500 }).onAction(() => { /* 长按 */ })
  )
)
```

**特点**：只能触发一个手势，优先级由声明顺序决定

#### 顺序识别 (Sequence)
```typescript
.gesture(
  GestureGroup(GestureMode.Sequence,
    LongPressGesture({ duration: 500 }).onAction(() => { /* 步骤1: 长按 */ }),
    TapGesture().onAction(() => { /* 步骤2: 单击 */ })
  )
)
```

**特点**：必须按顺序依次完成所有手势

## 🎨 设计模式

### 1. 统一颜色管理
所有颜色使用资源引用：
```typescript
.fontColor($r('app.color.text_primary'))
.backgroundColor($r('app.color.bg_primary'))
```

### 2. 事件日志记录
使用 `hilog` 记录事件信息：
```typescript
hilog.info(0x0000, 'F005', `点击次数: ${this.clickCount}`);
```

### 3. 类型安全
所有变量强类型声明：
```typescript
@State clickCount: number = 0;
@State touchInfo: string = '触摸区域';
private touchEvents: TouchEventInfo[] = [];
```

### 4. 新版路由 API
使用 `getUIContext().getRouter()`：
```typescript
this.getUIContext().getRouter().pushUrl({ url: 'pages/BasicEventPage' });
this.getUIContext().getRouter().back();
```

## 🚀 运行步骤

### 1. 安装依赖
```bash
cd examples/01_foundation/F005_event_handling
ohpm install
```

### 2. 构建项目
```bash
export DEVECO_SDK_HOME="/Applications/DevEco-Studio.app/Contents/sdk"
hvigorw assembleHap
```

### 3. 运行
- 使用 DevEco Studio 打开项目
- 连接鸿蒙设备或启动模拟器
- 点击运行按钮

## 📊 功能演示

### 基础事件页面
- ✅ onClick 点击计数
- ✅ onTouch 触摸轨迹记录
- ✅ onHover 鼠标悬停状态
- ✅ 事件冒泡演示

### 手势识别页面
- ✅ 单击 / 双击手势
- ✅ 长按手势（500ms）
- ✅ 拖动手势（实时位置）

### 高级手势页面
- ✅ 四向滑动识别
- ✅ 双指捏合缩放
- ✅ 双指旋转

### 手势组合页面
- ✅ 并行手势（同时触发）
- ✅ 互斥手势（优先级）
- ✅ 顺序手势（步骤控制）

## 🔑 关键技术点

### 1. 触摸事件详细信息
```typescript
interface TouchEventInfo {
  type: string;        // 事件类型: 按下/移动/抬起/取消
  x: number;          // X 坐标
  y: number;          // Y 坐标
  timestamp: number;  // 时间戳
}
```

### 2. 手势事件数据
```typescript
interface GestureEvent {
  offsetX?: number;    // X 偏移量（PanGesture）
  offsetY?: number;    // Y 偏移量（PanGesture）
  scale?: number;      // 缩放比例（PinchGesture）
  angle?: number;      // 旋转角度（RotationGesture）
}
```

### 3. 手势优先级
- 优先级顺序：parallelGesture > gesture > 子组件手势
- 互斥模式下，先声明的手势优先级更高
- 顺序模式必须严格按声明顺序完成

### 4. 性能优化
- 使用 `@State` 管理状态更新
- 避免在 onActionUpdate 中执行耗时操作
- 合理使用手势识别参数（distance、duration）

## 📝 常见问题

### 1. 为什么长按手势不触发？
- 检查 `duration` 参数设置
- 确保手指在长按期间不移动
- 注意与拖动手势的冲突

### 2. 拖动手势不流畅？
- 减小 `distance` 参数（最小识别距离）
- 使用 `onActionUpdate` 实时更新位置
- 避免在更新回调中执行复杂计算

### 3. 手势组合不生效？
- 检查 GestureMode 是否正确
- 确认手势声明顺序
- 注意 parallelGesture 和 gesture 的区别

### 4. 触摸事件丢失？
- 检查事件是否被子组件拦截
- 注意事件冒泡和阻止传播
- 确认 onTouch 返回值

## 🎯 扩展建议

1. **自定义手势识别器** - 封装常用手势模式
2. **手势录制回放** - 记录并回放用户操作
3. **多点触控** - 实现更复杂的多指手势
4. **手势冲突解决** - 优化手势识别策略
5. **手势反馈** - 添加震动、音效等反馈

## 📚 相关 API 文档

### OpenHarmony API
- [@ohos.multimodalInput.mouseEvent](https://developer.huawei.com/consumer/cn/doc/) - 鼠标事件
- [@ohos.multimodalInput.touchEvent](https://developer.huawei.com/consumer/cn/doc/) - 触摸事件

### ArkUI 组件
- [TapGesture](https://developer.huawei.com/consumer/cn/doc/) - 点击手势
- [LongPressGesture](https://developer.huawei.com/consumer/cn/doc/) - 长按手势
- [PanGesture](https://developer.huawei.com/consumer/cn/doc/) - 拖动手势
- [SwipeGesture](https://developer.huawei.com/consumer/cn/doc/) - 滑动手势
- [PinchGesture](https://developer.huawei.com/consumer/cn/doc/) - 捏合手势
- [RotationGesture](https://developer.huawei.com/consumer/cn/doc/) - 旋转手势
- [GestureGroup](https://developer.huawei.com/consumer/cn/doc/) - 手势组合

---

**开发环境**：HarmonyOS 6.0.0 (API 20)
**作者**：mqxu
**最后更新**：2025-10-04
