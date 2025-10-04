import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct AdvancedGesturePage {
  @State swipeDirection: string = '未滑动';
  @State pinchScale: number = 1;
  @State rotationAngle: number = 0;

  private goBack(): void {
    this.getUIContext().getRouter().back();
  }

  build() {
    Column() {
      // 顶部导航
      Row() {
        Button('返回')
          .onClick(() => this.goBack())
          .backgroundColor($r('app.color.brand_primary'))

        Text('高级手势')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('返回')
          .visibility(Visibility.Hidden)
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('app.color.bg_primary'))

      Scroll() {
        Column({ space: 24 }) {
          // SwipeGesture 滑动
          Column({ space: 12 }) {
            Text('1. SwipeGesture 滑动手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`滑动方向: ${this.swipeDirection}`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('在这里滑动')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
              Text('(上/下/左/右)')
                .fontSize(12)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 8 })
            }
            .width('100%')
            .height(150)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .gesture(
              SwipeGesture({ fingers: 1, direction: SwipeDirection.All })
                .onAction((event: GestureEvent) => {
                  const angle: number = event.angle || 0;
                  if (angle > -45 && angle <= 45) {
                    this.swipeDirection = '向右滑动';
                  } else if (angle > 45 && angle <= 135) {
                    this.swipeDirection = '向下滑动';
                  } else if (angle > 135 || angle <= -135) {
                    this.swipeDirection = '向左滑动';
                  } else {
                    this.swipeDirection = '向上滑动';
                  }
                  hilog.info(0x0000, 'F005', `滑动角度: ${angle}, 方向: ${this.swipeDirection}`);
                })
            )
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // PinchGesture 捏合
          Column({ space: 12 }) {
            Text('2. PinchGesture 捏合手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`缩放比例: ${this.pinchScale.toFixed(2)}x`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Stack() {
              Column()
                .width('100%')
                .height(250)
                .backgroundColor($r('app.color.bg_hover'))
                .borderRadius(8)

              Column() {
                Text('🖼️')
                  .fontSize(48)
              }
              .width(100)
              .height(100)
              .backgroundColor($r('app.color.brand_primary'))
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .scale({ x: this.pinchScale, y: this.pinchScale })
              .gesture(
                PinchGesture({ fingers: 2 })
                  .onActionUpdate((event: GestureEvent) => {
                    if (event.scale !== undefined) {
                      this.pinchScale = event.scale;
                    }
                  })
                  .onActionEnd(() => {
                    hilog.info(0x0000, 'F005', `最终缩放: ${this.pinchScale}`);
                  })
              )
            }
            .width('100%')
            .height(250)
            .alignContent(Alignment.Center)

            Button('重置缩放')
              .width('100%')
              .backgroundColor($r('app.color.brand_success'))
              .onClick(() => {
                this.pinchScale = 1;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // RotationGesture 旋转
          Column({ space: 12 }) {
            Text('3. RotationGesture 旋转手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`旋转角度: ${Math.round(this.rotationAngle)}°`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Stack() {
              Column()
                .width('100%')
                .height(250)
                .backgroundColor($r('app.color.bg_hover'))
                .borderRadius(8)

              Column() {
                Text('↑')
                  .fontSize(32)
                  .fontWeight(FontWeight.Bold)
              }
              .width(100)
              .height(100)
              .backgroundColor($r('app.color.brand_warning'))
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .rotate({ angle: this.rotationAngle })
              .gesture(
                RotationGesture({ fingers: 2 })
                  .onActionUpdate((event: GestureEvent) => {
                    if (event.angle !== undefined) {
                      this.rotationAngle = event.angle;
                    }
                  })
                  .onActionEnd(() => {
                    hilog.info(0x0000, 'F005', `最终角度: ${this.rotationAngle}`);
                  })
              )
            }
            .width('100%')
            .height(250)
            .alignContent(Alignment.Center)

            Button('重置角度')
              .width('100%')
              .backgroundColor($r('app.color.brand_success'))
              .onClick(() => {
                this.rotationAngle = 0;
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)
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
