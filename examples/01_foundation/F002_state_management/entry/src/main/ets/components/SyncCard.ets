import { StateManager } from '../utils/StateManager';

/**
 * SyncCard 组件
 * 演示 @Link 装饰器的使用 - 双向数据绑定
 */
@Component
export struct SyncCard {
  // @Link: 与父组件双向绑定，修改会同步到父组件
  @Link syncValue: number;

  /**
   * 增加同步值
   */
  private increment(): void {
    this.syncValue++;
  }

  /**
   * 减少同步值
   */
  private decrement(): void {
    this.syncValue--;
  }

  /**
   * 重置同步值
   */
  private reset(): void {
    this.syncValue = StateManager.reset(this.syncValue, 0);
  }

  /**
   * 设置为特定值
   */
  private setValue(value: number): void {
    this.syncValue = value;
  }

  build() {
    Column({ space: 12 }) {
      Text('当前同步值:')
        .fontSize(14)
        .fontColor('#666666')

      Text(StateManager.formatCounter(this.syncValue))
        .fontSize(24)
        .fontColor('#4CAF50')
        .fontWeight(FontWeight.Bold)

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

        Button('重置')
          .onClick(() => this.reset())
          .backgroundColor('#FFC107')
          .width(80)
          .height(40)
      }
      .justifyContent(FlexAlign.Center)

      Row({ space: 8 }) {
        Button('设为 10')
          .onClick(() => this.setValue(10))
          .backgroundColor('#3F51B5')
          .fontSize(14)
          .width(80)
          .height(36)

        Button('设为 100')
          .onClick(() => this.setValue(100))
          .backgroundColor('#009688')
          .fontSize(14)
          .width(80)
          .height(36)
      }
      .justifyContent(FlexAlign.Center)

      Text('说明: @Link 双向绑定，子组件修改会同步到父组件')
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
