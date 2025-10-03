import { Message, MessageType, Product } from '../models/Contact';
import { MockData } from '../utils/MockData';
import { BasicDataSource } from '../utils/DataSource';

/**
 * 消息数据源
 */
class MessageDataSource extends BasicDataSource<Message> {
  private dataArray: Message[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Message {
    return this.dataArray[index];
  }

  public addData(index: number, data: Message): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Message): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }
}

/**
 * 商品数据源
 */
class ProductDataSource extends BasicDataSource<Product> {
  private dataArray: Product[] = [];

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Product {
    return this.dataArray[index];
  }

  public addData(index: number, data: Product): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Product): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataDelete(index);
  }
}

/**
 * F003 - 列表性能优化页面
 * 演示多种列表类型和性能优化技巧
 */
@Entry
@Component
struct PerformancePage {
  @State private currentTab: number = 0;
  @State private messageDataSource: MessageDataSource = new MessageDataSource();
  @State private productDataSource: ProductDataSource = new ProductDataSource();
  @State private renderTime: number = 0;

  aboutToAppear(): void {
    this.initializeData();
  }

  /**
   * 初始化数据
   */
  private initializeData(): void {
    const startTime = Date.now();

    // 生成消息数据
    const messages = MockData.generateMessages(200);
    messages.forEach((msg: Message) => {
      this.messageDataSource.pushData(msg);
    });

    // 生成商品数据
    const products = MockData.generateProducts(100);
    products.forEach((product: Product) => {
      this.productDataSource.pushData(product);
    });

    this.renderTime = Date.now() - startTime;
  }

  /**
   * 根据 colorKey 获取颜色资源
   */
  private getColor(colorKey: string): Resource {
    const colorMap: Record<string, Resource> = {
      'brand_primary': $r('app.color.brand_primary'),
      'brand_success': $r('app.color.brand_success'),
      'brand_warning': $r('app.color.brand_warning'),
      'brand_danger': $r('app.color.brand_danger'),
      'brand_purple': $r('app.color.brand_purple'),
      'brand_cyan': $r('app.color.brand_cyan'),
      'brand_magenta': $r('app.color.brand_magenta'),
      'brand_blue': $r('app.color.brand_blue'),
      'brand_gold': $r('app.color.brand_gold')
    };
    return colorMap[colorKey] || $r('app.color.brand_primary');
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('← 返回')
          .fontSize(16)
          .fontColor('#F6F6F6')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })

        Text('性能优化示例')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F6F6F6')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('        ')
          .fontSize(16)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#722ED1')
      .justifyContent(FlexAlign.SpaceBetween)

      // 性能统计
      Row() {
        Text(`渲染耗时: ${this.renderTime} ms`)
          .fontSize(14)
          .fontColor('#666666')

        Text(`消息: ${this.messageDataSource.totalCount()} | 商品: ${this.productDataSource.totalCount()}`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
      .justifyContent(FlexAlign.SpaceBetween)

      // Tab 切换
      Tabs({ index: this.currentTab }) {
        // 消息列表 Tab
        TabContent() {
          this.MessageListView()
        }
        .tabBar('消息列表')

        // 商品列表 Tab
        TabContent() {
          this.ProductListView()
        }
        .tabBar('商品列表')

        // 性能建议 Tab
        TabContent() {
          this.PerformanceTipsView()
        }
        .tabBar('优化建议')
      }
      .width('100%')
      .layoutWeight(1)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentTab = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F6F6')
  }

  /**
   * 消息列表视图
   */
  @Builder
  MessageListView() {
    List({ space: 0 }) {
      LazyForEach(this.messageDataSource, (message: Message, _index: number) => {
        ListItem() {
          Row({ space: 12 }) {
            // 消息图标
            Text(this.getMessageIcon(message.type))
              .fontSize(24)
              .width(48)
              .height(48)
              .borderRadius(24)
              .backgroundColor(this.getMessageColor(message.type))
              .textAlign(TextAlign.Center)
              .fontColor('#F6F6F6')

            // 消息内容
            Column({ space: 4 }) {
              Row() {
                Text(message.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')
                  .flexGrow(1)

                if (!message.isRead) {
                  Text('未读')
                    .fontSize(12)
                    .fontColor('#F6F6F6')
                    .backgroundColor('#FF4D4F')
                    .padding({
                      left: 8,
                      right: 8,
                      top: 2,
                      bottom: 2
                    })
                    .borderRadius(2)
                }
              }
              .width('100%')

              Text(message.content)
                .fontSize(14)
                .fontColor('#666666')
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(message.time)
                .fontSize(12)
                .fontColor('#999999')
            }
            .alignItems(HorizontalAlign.Start)
            .flexGrow(1)
          }
          .width('100%')
          .padding(16)
          .backgroundColor(message.isRead ? '#F6F6F6' : '#F0F9FF')
        }
      }, (message: Message) => message.id)
    }
    .width('100%')
    .height('100%')
    .divider({ strokeWidth: 1, color: '#F0F0F0', startMargin: 76 })
    .edgeEffect(EdgeEffect.Spring)
  }

  /**
   * 商品列表视图 (Grid 布局)
   */
  @Builder
  ProductListView() {
    Grid() {
      LazyForEach(this.productDataSource, (product: Product) => {
        GridItem() {
          Column({ space: 8 }) {
            // 商品图标（使用 emoji + 背景色）
            Text(product.image)
              .fontSize(48)
              .width('100%')
              .height(120)
              .borderRadius(8)
              .backgroundColor(this.getColor(product.color))
              .textAlign(TextAlign.Center)
              .padding({ top: 36 })

            // 商品信息
            Column({ space: 4 }) {
              Text(product.name)
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .fontColor('#333333')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(product.description)
                .fontSize(12)
                .fontColor('#999999')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Row() {
                Text(`¥${product.price}`)
                  .fontSize(16)
                  .fontColor('#FF4D4F')
                  .fontWeight(FontWeight.Bold)

                Text(`库存: ${product.stock}`)
                  .fontSize(12)
                  .fontColor('#999999')
                  .layoutWeight(1)
                  .textAlign(TextAlign.End)
              }
              .width('100%')
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(12)
          .backgroundColor('#F6F6F6')
          .borderRadius(8)
          .shadow({ radius: 8, color: '#00000010' })
        }
      }, (product: Product) => product.id)
    }
    .width('100%')
    .height('100%')
    .columnsTemplate('1fr 1fr')
    .rowsGap(12)
    .columnsGap(12)
    .padding(12)
    .backgroundColor('#F5F5F5')
  }

  /**
   * 性能优化建议视图
   */
  @Builder
  PerformanceTipsView() {
    Scroll() {
      Column({ space: 16 }) {
        // 优化建议卡片
        this.TipCard(
          '使用 LazyForEach',
          '对于大数据量列表，使用 LazyForEach 代替 ForEach，实现按需加载和渲染',
          '#52C41A'
        )

        this.TipCard(
          '合理使用 cachedCount',
          'List 组件的 cachedCount 属性可以设置缓存的列表项数量，提升滚动性能',
          '#1890FF'
        )

        this.TipCard(
          '避免深层嵌套',
          '减少组件嵌套层级，使用扁平化的组件结构',
          '#FA8C16'
        )

        this.TipCard(
          '使用 @Reusable 装饰器',
          '为列表项组件添加 @Reusable 装饰器，实现组件复用',
          '#722ED1'
        )

        this.TipCard(
          '合理使用图片',
          '使用 alt 属性设置占位图，避免图片加载失败时的空白',
          '#13C2C2'
        )

        this.TipCard(
          '优化状态管理',
          '避免不必要的状态刷新，使用局部状态代替全局状态',
          '#EB2F96'
        )

        // 性能对比数据
        Column({ space: 8 }) {
          Text('性能对比数据')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')

          Row() {
            Text('ForEach (1000条):')
              .fontSize(14)
              .fontColor('#666666')
              .layoutWeight(1)

            Text('~800ms')
              .fontSize(14)
              .fontColor('#FF4D4F')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          Row() {
            Text('LazyForEach (1000条):')
              .fontSize(14)
              .fontColor('#666666')
              .layoutWeight(1)

            Text('~100ms')
              .fontSize(14)
              .fontColor('#52C41A')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          Row() {
            Text('性能提升:')
              .fontSize(14)
              .fontColor('#666666')
              .layoutWeight(1)

            Text('8x')
              .fontSize(14)
              .fontColor('#1890FF')
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
      }
      .width('100%')
      .padding(16)
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 提示卡片组件
   */
  @Builder
  TipCard(title: string, content: string, color: string) {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        Text('💡')
          .fontSize(20)

        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor(color)
      }
      .width('100%')

      Text(content)
        .fontSize(14)
        .fontColor('#666666')
        .lineHeight(20)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#F6F6F6')
    .borderRadius(8)
    .border({ width: 1, color: color, radius: 8 })
  }

  /**
   * 获取消息图标
   */
  private getMessageIcon(type: MessageType): string {
    switch (type) {
      case MessageType.SYSTEM:
        return '🔔';
      case MessageType.NOTICE:
        return '📢';
      case MessageType.MESSAGE:
        return '💬';
      default:
        return '📬';
    }
  }

  /**
   * 获取消息颜色
   */
  private getMessageColor(type: MessageType): string {
    switch (type) {
      case MessageType.SYSTEM:
        return '#1890FF';
      case MessageType.NOTICE:
        return '#FA8C16';
      case MessageType.MESSAGE:
        return '#52C41A';
      default:
        return '#999999';
    }
  }
}
