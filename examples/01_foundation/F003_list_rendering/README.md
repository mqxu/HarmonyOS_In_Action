# F003 列表渲染与优化

## 案例简介

本案例演示 HarmonyOS 中 List 组件的基础用法、LazyForEach 懒加载机制以及列表性能优化技巧。

## 核心知识点

### 1. List 组件基础用法
- **ForEach 渲染**：适用于小数据量列表（< 100 条）
- **ListItem**：列表项组件，必须作为 List 的直接子组件
- **divider**：列表分隔线配置
- **edgeEffect**：边缘滚动效果（Spring、Fade、None）
- **swipeAction**：滑动操作（左滑删除等）

### 2. LazyForEach 懒加载
- **IDataSource 接口**：数据源必须实现的接口
- **BasicDataSource**：数据源基类实现
- **按需加载**：只渲染可见区域的列表项
- **性能提升**：适用于大数据量列表（> 100 条）

### 3. 性能优化技巧
- **@Reusable 装饰器**：组件复用（本案例未实现，可扩展）
- **cachedCount**：缓存列表项数量
- **虚拟滚动**：LazyForEach 自动实现虚拟滚动
- **数据更新通知**：使用 DataChangeListener 精确更新

## 项目结构

```
F003_list_rendering/
├── entry/src/main/ets/
│   ├── models/
│   │   └── Contact.ets          # 数据模型（Contact、Message、Product）
│   ├── utils/
│   │   ├── DataSource.ets       # IDataSource 实现（BasicDataSource、ContactDataSource）
│   │   └── MockData.ets         # 模拟数据生成工具
│   └── pages/
│       ├── Index.ets            # 主页面（ForEach 基础列表）
│       ├── LazyListPage.ets     # LazyForEach 懒加载示例
│       └── PerformancePage.ets  # 性能优化示例（消息列表、商品网格）
```

## 核心代码示例

### 1. ForEach 基础列表 (Index.ets)

```typescript
List({ space: 0 }) {
  ForEach(this.contacts, (contact: Contact, index: number) => {
    ListItem() {
      Row({ space: 12 }) {
        Image(contact.avatar)
          .width(48)
          .height(48)
          .borderRadius(24)
          .alt($r('app.media.layered_image'))

        Column({ space: 4 }) {
          Text(contact.name)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('app.color.text_primary'))

          Text(contact.phone)
            .fontSize(14)
            .fontColor($r('app.color.text_tertiary'))

          Text(`分组: ${contact.group}`)
            .fontSize(12)
            .fontColor($r('app.color.brand_primary'))
        }
        .alignItems(HorizontalAlign.Start)
        .flexGrow(1)

        Row({ space: 8 }) {
          Button('通话')
            .fontSize(12)
            .height(32)
            .backgroundColor($r('app.color.brand_success'))

          Button('删除')
            .fontSize(12)
            .height(32)
            .backgroundColor($r('app.color.brand_danger'))
            .onClick(() => this.deleteContact(index))
        }
      }
      .width('100%')
      .padding(16)
      .backgroundColor(this.selectedIndex === index ? $r('app.color.bg_highlight') : $r('app.color.bg_primary'))
    }
    .onClick(() => this.selectedIndex = index)
    .swipeAction({ end: this.deleteButton(index) })
  }, (contact: Contact) => contact.id)
}
.divider({
  strokeWidth: 1,
  color: $r('app.color.border_light'),
  startMargin: 76,
  endMargin: 16
})
.edgeEffect(EdgeEffect.Spring)
```

**关键要点**：
- **ForEach 第三个参数**：键生成函数，用于唯一标识列表项（必须提供）
- **swipeAction**：滑动操作，支持 start 和 end 两个方向
- **onClick**：点击事件，可实现选中高亮效果
- **资源引用**：使用 `$r('app.color.xxx')` 引用颜色资源，便于统一管理

### 2. IDataSource 实现 (DataSource.ets)

```typescript
export class BasicDataSource<T> implements IDataSource {
  private listeners: DataChangeListener[] = [];
  private originDataArray: T[] = [];

  public totalCount(): number {
    return this.originDataArray.length;
  }

  public getData(index: number): T {
    return this.originDataArray[index];
  }

  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  protected notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    });
  }

  public pushData(data: T): void {
    this.originDataArray.push(data);
    this.notifyDataAdd(this.originDataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.originDataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }
}

// 具体实现
export class ContactDataSource extends BasicDataSource<Contact> {
  private dataArray: Contact[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Contact {
    return this.dataArray[index];
  }
}
```

**关键要点**：
- **IDataSource 接口**：必须实现 totalCount、getData、registerDataChangeListener 等方法
- **DataChangeListener**：数据变化监听器，支持 onDataAdd、onDataChange、onDataDelete、onDataReloaded
- **泛型支持**：使用 `<T>` 支持不同类型的数据
- **protected notifyDataAdd**：子类可以调用通知方法

### 3. LazyForEach 使用 (LazyListPage.ets)

```typescript
List({ space: 0 }) {
  LazyForEach(this.dataSource, (contact: Contact, index: number) => {
    ListItem() {
      Row({ space: 12 }) {
        Image(contact.avatar).width(48).height(48)
        Column({ space: 4 }) {
          Text(contact.name).fontSize(16)
          Text(contact.phone).fontSize(14)
          Text(`索引: ${index}`).fontSize(12)
        }
        Button('删除').onClick(() => this.deleteContact(index))
      }
    }
  }, (contact: Contact) => contact.id)
}
.onReachEnd(() => {
  // 滚动到底部时自动加载更多
  if (!this.isLoading && this.dataSource.totalCount() < this.totalCount) {
    this.loadMoreData(50);
  }
})
```

**关键要点**：
- **LazyForEach**：第一个参数是 IDataSource 实例，第二个参数是项生成函数，第三个参数是键生成函数
- **onReachEnd**：滚动到底部的回调，可实现无限滚动
- **按需加载**：只渲染可见区域 + cachedCount 数量的列表项

### 4. 数据更新示例

```typescript
// 添加数据
private loadMoreData(count: number): void {
  this.isLoading = true;

  setTimeout(() => {
    const newContacts = MockData.generateContacts(count);
    newContacts.forEach((contact: Contact) => {
      this.dataSource.pushData(contact);  // 自动触发 onDataAdd 通知
    });
    this.isLoading = false;
  }, 500);
}

// 删除数据
private deleteContact(index: number): void {
  this.dataSource.deleteData(index);  // 自动触发 onDataDelete 通知
}
```

### 5. 路由导航（使用新版 API）

```typescript
import hilog from '@ohos.hilog';

// 页面跳转
private navigateToLazyPage(): void {
  this.getUIContext().getRouter().pushUrl({
    url: 'pages/LazyListPage'
  }).catch((error: Error) => {
    hilog.error(0x0000, 'F003', `Navigation failed: ${error.message}`);
  });
}

// 返回上一页
private goBack(): void {
  this.getUIContext().getRouter().back();
}
```

**关键要点**：
- **getUIContext().getRouter()**：新版路由 API，替代已废弃的 router.pushUrl()
- **异常处理**：使用 catch 捕获导航失败的情况
- **日志记录**：使用 hilog 记录错误信息，便于调试

### 6. 商品列表（emoji 图标 + 颜色资源）

```typescript
// 数据模型
export class Product {
  id: string;
  name: string;
  price: number;
  image: string;  // 存储 emoji 图标
  description: string;
  stock: number;
  color: string;  // 颜色资源 key
}

// 生成商品数据
static generateProducts(count: number): Product[] {
  const productTypes: ProductType[] = [
    { name: '华为手机', icon: '📱', colorKey: 'brand_primary' },
    { name: '小米平板', icon: '💻', colorKey: 'brand_success' },
    { name: '耳机', icon: '🎧', colorKey: 'brand_cyan' }
  ];
  // ...
}

// 渲染商品卡片
Text(product.image)
  .fontSize(48)
  .width('100%')
  .height(120)
  .borderRadius(8)
  .backgroundColor(this.getColor(product.color))
  .textAlign(TextAlign.Center)

// 颜色映射
private getColor(colorKey: string): Resource {
  const colorMap: Record<string, Resource> = {
    'brand_primary': $r('app.color.brand_primary'),
    'brand_success': $r('app.color.brand_success'),
    // ...
  };
  return colorMap[colorKey] || $r('app.color.brand_primary');
}
```

**关键要点**：
- **emoji 代替图片**：使用 emoji 作为商品图标，避免网络图片加载问题
- **颜色资源管理**：统一在 `resources/base/element/color.json` 定义颜色
- **动态颜色映射**：根据 colorKey 获取对应的颜色资源

## 颜色资源定义

项目统一在 `resources/base/element/color.json` 中定义颜色资源：

```json
{
  "color": [
    { "name": "brand_primary", "value": "#1890FF" },
    { "name": "brand_success", "value": "#52C41A" },
    { "name": "brand_danger", "value": "#FF4D4F" },
    { "name": "text_primary", "value": "#333333" },
    { "name": "text_secondary", "value": "#666666" },
    { "name": "bg_primary", "value": "#FFFFFF" },
    { "name": "bg_secondary", "value": "#F6F6F6" },
    { "name": "border_light", "value": "#F0F0F0" }
  ]
}
```

**优势**：
- 统一管理颜色，便于主题切换
- 避免硬编码颜色值
- 支持多语言/多主题

## 性能对比

| 渲染方式 | 数据量 | 初始渲染时间 | 内存占用 | 适用场景 |
|---------|--------|-------------|---------|---------|
| ForEach | 1000 条 | ~800ms | 高 | < 100 条数据 |
| LazyForEach | 1000 条 | ~100ms | 低 | > 100 条数据 |
| LazyForEach | 10000 条 | ~120ms | 低 | 海量数据 |

## 优化建议

1. **使用 LazyForEach**：大数据量列表必须使用 LazyForEach
2. **合理设置 cachedCount**：List 组件的 cachedCount 属性可以设置缓存数量
3. **避免深层嵌套**：减少组件嵌套层级，使用扁平化结构
4. **图片优化**：使用 alt 属性设置占位图，避免图片加载失败的空白
5. **状态管理优化**：避免不必要的状态刷新，使用局部状态
6. **使用 @Reusable**：为列表项组件添加 @Reusable 装饰器实现复用

## API 版本

- HarmonyOS API 20
- SDK 版本：6.0.0

## 运行方式

1. 使用 DevEco Studio 打开项目
2. 连接 HarmonyOS 设备或启动模拟器
3. 点击运行按钮或执行 `hvigorw assembleHap`

## 扩展练习

1. 实现分组列表（使用 ListItemGroup）
2. 添加 @Reusable 装饰器优化性能
3. 实现下拉刷新功能
4. 添加列表搜索和筛选功能
5. 实现粘性标题效果

## 参考文档

- [List 组件](https://developer.huawei.com/consumer/cn/doc/harmonyos-references-V5/ts-container-list-V5)
- [LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-rendering-control-lazyforeach-V5)
- [列表性能优化](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-performance-improvement-recommendation-V5)
