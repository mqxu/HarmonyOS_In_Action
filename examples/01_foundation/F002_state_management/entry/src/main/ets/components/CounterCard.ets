import { StateManager } from '../utils/StateManager';

/**
 * CounterCard 组件
 * 演示 @Prop 装饰器的使用 - 单向数据传递
 */
@Component
export struct CounterCard {
  // @Prop: 接收父组件传入的值，只读（单向）
  @Prop initialCount: number = 0;

  // 组件内部状态
  @State private localCount: number = 0;

  /**
   * 组件即将出现时初始化本地计数
   */
  aboutToAppear(): void {
    this.localCount = this.initialCount;
  }

  /**
   * 增加本地计数
   */
  private increment(): void {
    this.localCount++;
  }

  /**
   * 减少本地计数
   */
  private decrement(): void {
    this.localCount--;
  }

  /**
   * 从父组件同步值
   */
  private syncFromParent(): void {
    this.localCount = this.initialCount;
  }

  build() {
    Column({ space: 12 }) {
      Row({ space: 8 }) {
        Text('父组件值:')
          .fontSize(14)
          .fontColor('#666666')

        Text(StateManager.formatCounter(this.initialCount))
          .fontSize(14)
          .fontColor('#1890FF')
          .fontWeight(FontWeight.Medium)
      }

      Row({ space: 8 }) {
        Text('本地值:')
          .fontSize(14)
          .fontColor('#666666')

        Text(StateManager.formatCounter(this.localCount))
          .fontSize(14)
          .fontColor('#E91E63')
          .fontWeight(FontWeight.Medium)
      }

      Row({ space: 8 }) {
        Button('➕')
          .onClick(() => this.increment())
          .width(60)
          .height(40)

        Button('➖')
          .onClick(() => this.decrement())
          .backgroundColor('#FF6B6B')
          .width(60)
          .height(40)

        Button('同步')
          .onClick(() => this.syncFromParent())
          .backgroundColor('#9C27B0')
          .width(80)
          .height(40)
      }
      .justifyContent(FlexAlign.Center)

      Text('说明: @Prop 只能单向接收，本地修改不影响父组件')
        .fontSize(12)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)
        .width('100%')
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({ radius: 4, color: '#00000010', offsetY: 2 })
  }
}
