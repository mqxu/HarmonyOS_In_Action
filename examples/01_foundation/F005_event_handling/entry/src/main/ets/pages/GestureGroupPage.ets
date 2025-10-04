import { hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct GestureGroupPage {
  @State parallelInfo: string = '同时识别区域';
  @State exclusiveInfo: string = '互斥识别区域';
  @State sequentialInfo: string = '顺序识别区域';
  @State sequentialStep: number = 0;

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

        Text('手势组合')
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
          // 并行识别 - GestureMode.Parallel
          Column({ space: 12 }) {
            Text('1. 并行识别 (Parallel)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('可以同时触发单击和长按')
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))

            Text(this.parallelInfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('单击或长按')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(120)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .gesture(
              GestureGroup(GestureMode.Parallel,
                TapGesture()
                  .onAction(() => {
                    this.parallelInfo = '单击触发';
                    hilog.info(0x0000, 'F005', '并行: 单击');
                  }),
                LongPressGesture({ duration: 500 })
                  .onAction(() => {
                    this.parallelInfo = '长按触发';
                    hilog.info(0x0000, 'F005', '并行: 长按');
                  })
              )
            )
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 互斥识别 - GestureMode.Exclusive
          Column({ space: 12 }) {
            Text('2. 互斥识别 (Exclusive)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('只能触发一个手势，先识别到的优先')
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))

            Text(this.exclusiveInfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('单击或长按')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(120)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .gesture(
              GestureGroup(GestureMode.Exclusive,
                TapGesture()
                  .onAction(() => {
                    this.exclusiveInfo = '单击触发（互斥）';
                    hilog.info(0x0000, 'F005', '互斥: 单击');
                  }),
                LongPressGesture({ duration: 500 })
                  .onAction(() => {
                    this.exclusiveInfo = '长按触发（互斥）';
                    hilog.info(0x0000, 'F005', '互斥: 长按');
                  })
              )
            )
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 顺序识别 - GestureMode.Sequence
          Column({ space: 12 }) {
            Text('3. 顺序识别 (Sequence)')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('必须按顺序完成: 先长按 → 再单击')
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))

            Text(this.sequentialInfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Text(`步骤: ${this.sequentialStep}/2`)
              .fontSize(12)
              .fontColor($r('app.color.text_tertiary'))

            Column() {
              Text('先长按，再单击')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(120)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .gesture(
              GestureGroup(GestureMode.Sequence,
                LongPressGesture({ duration: 500 })
                  .onAction(() => {
                    this.sequentialStep = 1;
                    this.sequentialInfo = '步骤1: 长按完成，请单击';
                    hilog.info(0x0000, 'F005', '顺序: 长按完成');
                  }),
                TapGesture()
                  .onAction(() => {
                    if (this.sequentialStep === 1) {
                      this.sequentialStep = 2;
                      this.sequentialInfo = '步骤2: 单击完成，全部完成！';
                      hilog.info(0x0000, 'F005', '顺序: 单击完成');
                    }
                  })
              )
            )

            Button('重置顺序')
              .width('100%')
              .backgroundColor($r('app.color.brand_success'))
              .onClick(() => {
                this.sequentialStep = 0;
                this.sequentialInfo = '已重置，请重新开始';
              })
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 组合示例说明
          Column({ space: 12 }) {
            Text('📌 手势组合说明')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Column({ space: 8 }) {
              Text('• Parallel (并行): 所有手势同时识别，可以同时触发')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))

              Text('• Exclusive (互斥): 只能触发一个，优先级由声明顺序决定')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))

              Text('• Sequence (顺序): 必须按声明顺序依次完成所有手势')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
            }
            .width('100%')
            .alignItems(HorizontalAlign.Start)
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_secondary'))
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
