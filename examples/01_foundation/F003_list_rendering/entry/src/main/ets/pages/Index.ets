import { Contact } from '../models/Contact';
import { MockData } from '../utils/MockData';
import hilog from '@ohos.hilog';

/**
 * F003 - 列表渲染与优化主页面
 * 演示 List 组件的基础用法
 */
@Entry
@Component
struct Index {
  @State private contacts: Contact[] = [];
  @State private selectedIndex: number = -1;

  aboutToAppear(): void {
    // 生成模拟数据
    this.contacts = MockData.generateContacts(20);
  }

  /**
   * 导航到 LazyForEach 页面
   */
  private navigateToLazyPage(): void {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/LazyListPage'
    }).catch((error: Error) => {
      hilog.error(0x0000, 'F003', `Navigation failed: ${error.message}`);
    });
  }

  /**
   * 导航到性能优化页面
   */
  private navigateToPerformancePage(): void {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/PerformancePage'
    }).catch((error: Error) => {
      hilog.error(0x0000, 'F003', `Navigation failed: ${error.message}`);
    });
  }

  /**
   * 删除联系人
   */
  private deleteContact(index: number): void {
    this.contacts.splice(index, 1);
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('F003 - 列表渲染')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#F6F6F6')
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#1890FF')
      .justifyContent(FlexAlign.SpaceBetween)

      // 示例切换按钮
      Row({ space: 12 }) {
        Button('LazyForEach 示例')
          .fontSize(14)
          .onClick(() => this.navigateToLazyPage())
          .flexGrow(1)

        Button('性能优化示例')
          .fontSize(14)
          .onClick(() => this.navigateToPerformancePage())
          .flexGrow(1)
          .backgroundColor('#52C41A')
      }
      .width('100%')
      .padding(16)

      // List 基础用法演示
      Text('基础列表 (ForEach)')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .width('100%')
        .padding({ left: 16, right: 16, bottom: 8 })

      // 联系人列表
      List({ space: 0 }) {
        ForEach(this.contacts, (contact: Contact, index: number) => {
          ListItem() {
            Row({ space: 12 }) {
              // 头像
              Image(contact.avatar)
                .width(48)
                .height(48)
                .borderRadius(24)
                .alt($r('app.media.layered_image'))

              // 联系人信息
              Column({ space: 4 }) {
                Text(contact.name)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#333333')

                Text(contact.phone)
                  .fontSize(14)
                  .fontColor('#999999')

                Text(`分组: ${contact.group}`)
                  .fontSize(12)
                  .fontColor('#1890FF')
              }
              .alignItems(HorizontalAlign.Start)
              .flexGrow(1)

              // 右侧操作区
              Row({ space: 8 }) {
                Button('通话')
                  .fontSize(12)
                  .height(32)
                  .backgroundColor('#52C41A')

                Button('删除')
                  .fontSize(12)
                  .height(32)
                  .backgroundColor('#FF4D4F')
                  .onClick(() => {
                    this.deleteContact(index);
                  })
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor(this.selectedIndex === index ? '#F0F0F0' : '#FFFFFF')
          }
          .onClick(() => {
            this.selectedIndex = index;
          })
          .swipeAction({ end: this.deleteButton(index) })
        }, (contact: Contact) => contact.id)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: '#F0F0F0',
        startMargin: 76,
        endMargin: 16
      })
      .edgeEffect(EdgeEffect.Spring)

      // 底部统计信息
      Row() {
        Text(`共 ${this.contacts.length} 个联系人`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .height(48)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#F5F5F5')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F6F6F6')
  }

  /**
   * 滑动删除按钮
   */
  @Builder
  deleteButton(index: number) {
    Button('删除')
      .width(80)
      .height('100%')
      .fontSize(16)
      .fontColor('#F6F6F6')
      .backgroundColor('#FF4D4F')
      .onClick(() => {
        this.deleteContact(index);
      })
  }
}
