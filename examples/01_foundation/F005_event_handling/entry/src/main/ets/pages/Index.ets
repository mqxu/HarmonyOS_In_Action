import { hilog } from '@kit.PerformanceAnalysisKit';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = '事件处理与手势';

  private navToPage(url: string): void {
    try {
      this.getUIContext().getRouter().pushUrl({ url: url });
    } catch (err) {
      hilog.error(0x0000, 'F005', `导航失败: ${JSON.stringify(err)}`);
    }
  }

  @Builder
  NavCard(title: string, description: string, url: string) {
    Column() {
      Text(title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 8 })

      Text(description)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ bottom: 16 })

      Button('查看示例')
        .width('100%')
        .height(40)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => this.navToPage(url))
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.bg_primary'))
    .borderRadius(12)
    .margin({ bottom: 16 })
  }

  build() {
    Column() {
      // 标题
      Text(this.message)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_primary'))
        .margin({ bottom: 24 })

      Scroll() {
        Column({ space: 16 }) {
          // 基础事件
          this.NavCard(
            '基础事件处理',
            '演示 onClick、onTouch、onHover 等基础事件',
            'pages/BasicEventPage'
          )

          // 手势识别
          this.NavCard(
            '手势识别',
            '演示 TapGesture、LongPressGesture、PanGesture 等',
            'pages/GesturePage'
          )

          // 高级手势
          this.NavCard(
            '高级手势',
            '演示 SwipeGesture、PinchGesture、RotationGesture',
            'pages/AdvancedGesturePage'
          )

          // 手势组合
          this.NavCard(
            '手势组合',
            '演示手势的并行、互斥、顺序组合',
            'pages/GestureGroupPage'
          )
        }
        .width('100%')
        .padding(16)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.bg_page'))
  }
}
