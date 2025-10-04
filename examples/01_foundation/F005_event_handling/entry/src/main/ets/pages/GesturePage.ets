import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct GesturePage {
  @State tapCount: number = 0;
  @State longPressStatus: string = '长按区域';
  @State panInfo: string = '拖动区域';
  @State offsetX: number = 0;
  @State offsetY: number = 0;

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

        Text('手势识别')
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
          // TapGesture 单击/双击
          Column({ space: 12 }) {
            Text('1. TapGesture 点击手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`单击次数: ${this.tapCount}`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Row({ space: 16 }) {
              // 单击
              Column() {
                Text('单击')
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))
              }
              .width(150)
              .height(100)
              .backgroundColor($r('app.color.bg_hover'))
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .gesture(
                TapGesture({ count: 1 })
                  .onAction(() => {
                    this.tapCount++;
                    hilog.info(0x0000, 'F005', '单击手势触发');
                  })
              )

              // 双击
              Column() {
                Text('双击')
                  .fontSize(16)
                  .fontColor($r('app.color.text_primary'))
              }
              .width(150)
              .height(100)
              .backgroundColor($r('app.color.bg_hover'))
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .gesture(
                TapGesture({ count: 2 })
                  .onAction(() => {
                    this.tapCount += 2;
                    hilog.info(0x0000, 'F005', '双击手势触发');
                  })
              )
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // LongPressGesture 长按
          Column({ space: 12 }) {
            Text('2. LongPressGesture 长按手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`状态: ${this.longPressStatus}`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('长按这里 (500ms)')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(120)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .gesture(
              LongPressGesture({ duration: 500 })
                .onAction(() => {
                  this.longPressStatus = '长按触发！';
                  hilog.info(0x0000, 'F005', '长按手势触发');
                })
                .onActionEnd(() => {
                  this.longPressStatus = '长按结束';
                })
            )
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // PanGesture 拖动
          Column({ space: 12 }) {
            Text('3. PanGesture 拖动手势')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.panInfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Stack() {
              // 拖动区域背景
              Column()
                .width('100%')
                .height(250)
                .backgroundColor($r('app.color.bg_hover'))
                .borderRadius(8)

              // 可拖动的方块
              Column() {
                Text('拖动我')
                  .fontSize(14)
                  .fontColor($r('app.color.text_primary'))
              }
              .width(80)
              .height(80)
              .backgroundColor($r('app.color.brand_primary'))
              .borderRadius(8)
              .justifyContent(FlexAlign.Center)
              .translate({ x: this.offsetX, y: this.offsetY })
              .gesture(
                PanGesture({ fingers: 1, distance: 5 })
                  .onActionStart(() => {
                    this.panInfo = '开始拖动';
                  })
                  .onActionUpdate((event: GestureEvent) => {
                    if (event.offsetX !== undefined && event.offsetY !== undefined) {
                      this.offsetX = event.offsetX;
                      this.offsetY = event.offsetY;
                      this.panInfo = `偏移: (${Math.round(this.offsetX)}, ${Math.round(this.offsetY)})`;
                    }
                  })
                  .onActionEnd(() => {
                    this.panInfo = '拖动结束';
                    hilog.info(0x0000, 'F005', `最终偏移: (${this.offsetX}, ${this.offsetY})`);
                  })
              )
            }
            .width('100%')
            .height(250)
            .alignContent(Alignment.Center)

            Button('重置位置')
              .width('100%')
              .backgroundColor($r('app.color.brand_success'))
              .onClick(() => {
                this.offsetX = 0;
                this.offsetY = 0;
                this.panInfo = '已重置';
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
