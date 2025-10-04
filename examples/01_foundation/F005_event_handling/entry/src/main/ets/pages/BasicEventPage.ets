import { hilog } from '@kit.PerformanceAnalysisKit';

interface TouchEventInfo {
  type: string;
  x: number;
  y: number;
  timestamp: number;
}

@Entry
@Component
struct BasicEventPage {
  @State clickCount: number = 0;
  @State touchInfo: string = '触摸区域查看 onTouch 事件';
  @State hoverStatus: string = '未悬停';
  @State touchEvents: TouchEventInfo[] = [];

  private handleClick(): void {
    this.clickCount++;
    hilog.info(0x0000, 'F005', `点击次数: ${this.clickCount}`);
  }

  private handleTouch(event: TouchEvent): void {
    const touch: TouchObject | undefined = event.touches[0];
    if (touch) {
      const eventInfo: TouchEventInfo = {
        type: event.type === TouchType.Down ? '按下' :
              event.type === TouchType.Move ? '移动' :
              event.type === TouchType.Up ? '抬起' : '取消',
        x: Math.round(touch.x),
        y: Math.round(touch.y),
        timestamp: event.timestamp
      };

      this.touchInfo = `${eventInfo.type} (${eventInfo.x}, ${eventInfo.y})`;

      // 保留最近 5 条事件
      this.touchEvents.unshift(eventInfo);
      if (this.touchEvents.length > 5) {
        this.touchEvents.pop();
      }
    }
  }

  private handleHover(isHover: boolean): void {
    this.hoverStatus = isHover ? '鼠标悬停中' : '鼠标已离开';
    hilog.info(0x0000, 'F005', `悬停状态: ${this.hoverStatus}`);
  }

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

        Text('基础事件处理')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        // 占位保持居中
        Button('返回')
          .visibility(Visibility.Hidden)
      }
      .width('100%')
      .padding(16)
      .backgroundColor($r('app.color.bg_primary'))

      Scroll() {
        Column({ space: 24 }) {
          // onClick 示例
          Column({ space: 12 }) {
            Text('1. onClick 点击事件')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`点击次数: ${this.clickCount}`)
              .fontSize(16)
              .fontColor($r('app.color.text_secondary'))

            Button('点击我')
              .width(200)
              .height(50)
              .fontSize(16)
              .backgroundColor($r('app.color.brand_primary'))
              .onClick(() => this.handleClick())
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // onTouch 示例
          Column({ space: 12 }) {
            Text('2. onTouch 触摸事件')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(this.touchInfo)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('触摸区域')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
            }
            .width('100%')
            .height(150)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .onTouch((event: TouchEvent) => this.handleTouch(event))

            // 触摸事件历史
            if (this.touchEvents.length > 0) {
              Column({ space: 8 }) {
                Text('事件历史:')
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))

                ForEach(this.touchEvents, (item: TouchEventInfo, index: number) => {
                  Text(`${item.type}: (${item.x}, ${item.y})`)
                    .fontSize(12)
                    .fontColor($r('app.color.text_tertiary'))
                }, (item: TouchEventInfo, index: number) => `${index}-${item.timestamp}`)
              }
              .width('100%')
              .alignItems(HorizontalAlign.Start)
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // onHover 示例
          Column({ space: 12 }) {
            Text('3. onHover 悬停事件')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`状态: ${this.hoverStatus}`)
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Text('鼠标悬停区域')
                .fontSize(16)
                .fontColor($r('app.color.text_primary'))
              Text('(需要鼠标设备)')
                .fontSize(12)
                .fontColor($r('app.color.text_tertiary'))
                .margin({ top: 8 })
            }
            .width('100%')
            .height(100)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .onHover((isHover: boolean) => this.handleHover(isHover))
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(12)
          .alignItems(HorizontalAlign.Start)

          // 事件冒泡示例
          Column({ space: 12 }) {
            Text('4. 事件冒泡')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('点击内部按钮观察事件冒泡')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))

            Column() {
              Button('内部按钮')
                .backgroundColor($r('app.color.brand_success'))
                .onClick(() => {
                  hilog.info(0x0000, 'F005', '内部按钮被点击');
                })
            }
            .width('100%')
            .height(150)
            .backgroundColor($r('app.color.bg_hover'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .onClick(() => {
              hilog.info(0x0000, 'F005', '外部容器被点击（冒泡）');
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
