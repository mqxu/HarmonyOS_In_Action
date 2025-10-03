import { StateManager } from '../utils/StateManager';

/**
 * SharedCard 组件
 * 演示 @Provide/@Consume 装饰器的使用 - 跨层级状态共享
 */
@Component
export struct SharedCard {
  build() {
    Column({ space: 12 }) {
      Text('跨层级共享演示')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .textAlign(TextAlign.Center)

      // 嵌套子组件
      SharedCountDisplay()
      SharedTextDisplay()
      SharedControl()

      Text('说明: @Provide/@Consume 可跨层级传递状态，无需逐层传递')
        .fontSize(12)
        .fontColor('#999999')
        .textAlign(TextAlign.Center)
        .width('100%')
        .margin({ top: 8 })
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(8)
    .shadow({ radius: 4, color: '#00000010', offsetY: 2 })
  }
}

/**
 * SharedCountDisplay 组件
 * 通过 @Consume 消费共享的计数状态
 */
@Component
struct SharedCountDisplay {
  // @Consume: 消费父组件通过 @Provide 提供的数据
  @Consume('sharedCount') sharedCount: number;

  build() {
    Row({ space: 8 }) {
      Text('共享计数:')
        .fontSize(14)
        .fontColor('#666666')

      Text(StateManager.formatCounter(this.sharedCount))
        .fontSize(18)
        .fontColor('#FF5722')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding(12)
    .backgroundColor('#FFF3E0')
    .borderRadius(6)
  }
}

/**
 * SharedTextDisplay 组件
 * 通过 @Consume 消费共享的文本状态
 */
@Component
struct SharedTextDisplay {
  // @Consume: 消费父组件通过 @Provide 提供的数据
  @Consume('sharedText') sharedText: string;

  build() {
    Row({ space: 8 }) {
      Text('共享文本:')
        .fontSize(14)
        .fontColor('#666666')

      Text(this.sharedText)
        .fontSize(18)
        .fontColor('#2196F3')
        .fontWeight(FontWeight.Bold)
    }
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding(12)
    .backgroundColor('#E3F2FD')
    .borderRadius(6)
  }
}

/**
 * SharedControl 组件
 * 通过 @Consume 消费并修改共享状态
 */
@Component
struct SharedControl {
  // @Consume: 消费父组件通过 @Provide 提供的数据
  @Consume('sharedCount') sharedCount: number;
  @Consume('sharedText') sharedText: string;

  /**
   * 增加共享计数
   */
  private incrementShared(): void {
    this.sharedCount++;
  }

  /**
   * 更新共享文本
   */
  private updateSharedText(): void {
    this.sharedText = `已更新 ${this.sharedCount} 次`;
  }

  /**
   * 重置共享状态
   */
  private resetShared(): void {
    this.sharedCount = StateManager.reset(this.sharedCount, 0);
    this.sharedText = '共享状态';
  }

  build() {
    Column({ space: 8 }) {
      Row({ space: 8 }) {
        Button('增加计数')
          .onClick(() => this.incrementShared())
          .fontSize(14)
          .width(100)
          .height(36)

        Button('更新文本')
          .onClick(() => this.updateSharedText())
          .backgroundColor('#673AB7')
          .fontSize(14)
          .width(100)
          .height(36)
      }
      .justifyContent(FlexAlign.Center)

      Button('重置全部')
        .onClick(() => this.resetShared())
        .backgroundColor('#FF9800')
        .fontSize(14)
        .width(150)
        .height(36)
    }
    .width('100%')
    .padding(12)
    .backgroundColor('#F5F5F5')
    .borderRadius(6)
  }
}
