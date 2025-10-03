import { StateManager } from '../utils/StateManager';
import { CounterCard } from '../components/CounterCard';
import { SyncCard } from '../components/SyncCard';
import { SharedCard } from '../components/SharedCard';

/**
 * F002 - 状态管理进阶案例主页面
 * 演示 @State、@Prop、@Link、@Watch、@Provide、@Consume 装饰器的使用
 */
@Entry
@Component
struct Index {
  // @State: 组件内部状态，变化时触发UI刷新
  @State private globalCounter: number = 0;
  @State private message: string = '欢迎学习状态管理';
  @State private isExpanded: boolean = false;
  // @Provide: 向子组件提供数据（用于跨层级传递）
  @Provide('sharedCount') sharedCount: number = 0;
  @Provide('sharedText') sharedText: string = '共享状态';

  /**
   * 增加全局计数
   */
  private incrementGlobal(): void {
    this.globalCounter++;
  }

  /**
   * 减少全局计数
   */
  private decrementGlobal(): void {
    this.globalCounter--;
  }

  /**
   * 重置全局计数
   */
  private resetGlobal(): void {
    this.globalCounter = StateManager.reset(this.globalCounter, 0);
  }

  /**
   * 更新共享计数
   */
  private updateSharedCount(value: number): void {
    this.sharedCount = value;
  }

  /**
   * 更新共享文本
   */
  private updateSharedText(text: string): void {
    if (StateManager.isValidInput(text)) {
      this.sharedText = text;
    }
  }

  /**
   * 切换展开状态
   */
  private toggleExpand(): void {
    this.isExpanded = StateManager.toggleBoolean(this.isExpanded);
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 顶部标题区
        Column({ space: 8 }) {
          Text('F002 - 状态管理进阶')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .fontColor('#1890FF')

          Text(this.message)
            .fontSize(16)
            .fontColor('#666666')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#F5F5F5')
        .borderRadius(8)

        // 全局状态展示区
        Column({ space: 12 }) {
          Text('全局状态 (@State)')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)

          Text(StateManager.formatCounter(this.globalCounter))
            .fontSize(20)
            .fontColor('#333333')

          Row({ space: 12 }) {
            Button('增加')
              .onClick(() => this.incrementGlobal())
              .width(80)

            Button('减少')
              .onClick(() => this.decrementGlobal())
              .backgroundColor('#FF6B6B')
              .width(80)

            Button('重置')
              .onClick(() => this.resetGlobal())
              .backgroundColor('#51CF66')
              .width(80)
          }
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(8)
        .shadow({ radius: 4, color: '#00000010', offsetY: 2 })

        // CounterCard 演示区 (@Prop)
        Text('子组件状态传递 (@Prop)')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .padding({ left: 16, right: 16 })

        CounterCard({ initialCount: this.globalCounter })

        // SyncCard 演示区 (@Link)
        Text('双向同步 (@Link)')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .width('100%')
          .padding({ left: 16, right: 16 })

        SyncCard({ syncValue: this.globalCounter })

        // 展开/收起高级示例
        Button(this.isExpanded ? '收起高级示例 ▲' : '展开高级示例 ▼')
          .onClick(() => this.toggleExpand())
          .width('90%')
          .backgroundColor('#F0F0F0')
          .fontColor('#333333')

        if (this.isExpanded) {
          // SharedCard 演示区 (@Provide/@Consume)
          Column({ space: 12 }) {
            Text('跨层级状态共享 (@Provide/@Consume)')
              .fontSize(18)
              .fontWeight(FontWeight.Medium)

            SharedCard()
          }
          .width('100%')
          .padding(16)
        }

        // 底部说明
        Text('HarmonyOS 6.0.0 (API 20)')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 20 })
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F0F2F5')
    }
    .width('100%')
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
  }
}
