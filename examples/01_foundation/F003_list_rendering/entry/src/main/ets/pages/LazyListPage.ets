import { Contact } from '../models/Contact';
import { MockData } from '../utils/MockData';
import { ContactDataSource } from '../utils/DataSource';
import hilog from '@ohos.hilog';

/**
 * F003 - LazyForEach 懒加载列表页面
 * 演示 LazyForEach 的使用和性能优化
 */
@Entry
@Component
struct LazyListPage {
  @State private dataSource: ContactDataSource = new ContactDataSource();
  @State private isLoading: boolean = false;
  @State private totalCount: number = 1000;

  aboutToAppear(): void {
    // 初始加载 100 条数据
    this.loadMoreData(100);
  }

  /**
   * 加载更多数据
   */
  private loadMoreData(count: number): void {
    this.isLoading = true;

    // 模拟网络延迟
    setTimeout(() => {
      const currentCount = this.dataSource.totalCount();
      const newContacts = MockData.generateContacts(count);

      newContacts.forEach((contact: Contact) => {
        this.dataSource.pushData(contact);
      });

      this.isLoading = false;
    }, 500);
  }

  /**
   * 删除联系人
   */
  private deleteContact(index: number): void {
    this.dataSource.deleteData(index);
  }

  /**
   * 清空所有数据
   */
  private clearAll(): void {
    const count = this.dataSource.totalCount();
    for (let i = count - 1; i >= 0; i--) {
      this.dataSource.deleteData(i);
    }
  }

  build() {
    Column() {
      // 顶部标题栏
      Row() {
        Text('← 返回')
          .fontSize(16)
          .fontColor('#FFFFFF')
          .onClick(() => {
            this.getUIContext().getRouter().back();
          })

        Text('LazyForEach 懒加载')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Text('        ')
          .fontSize(16)
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor('#52C41A')
      .justifyContent(FlexAlign.SpaceBetween)

      // 统计信息
      Row({ space: 16 }) {
        Text(`已加载: ${this.dataSource.totalCount()} 条`)
          .fontSize(14)
          .fontColor('#666666')

        Text(`总计: ${this.totalCount} 条`)
          .fontSize(14)
          .fontColor('#666666')
      }
      .width('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')

      // 操作按钮
      Row({ space: 12 }) {
        Button('加载 50 条')
          .fontSize(14)
          .onClick(() => this.loadMoreData(50))
          .flexGrow(1)
          .backgroundColor('#1890FF')

        Button('加载 100 条')
          .fontSize(14)
          .onClick(() => this.loadMoreData(100))
          .flexGrow(1)
          .backgroundColor('#52C41A')

        Button('清空数据')
          .fontSize(14)
          .onClick(() => this.clearAll())
          .flexGrow(1)
          .backgroundColor('#FF4D4F')
      }
      .width('100%')
      .padding({ left: 16, right: 16, bottom: 12 })

      // LazyForEach 列表
      List({ space: 0 }) {
        LazyForEach(this.dataSource, (contact: Contact, index: number) => {
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

                Row({ space: 8 }) {
                  Text(`分组: ${contact.group}`)
                    .fontSize(12)
                    .fontColor('#1890FF')

                  Text(`索引: ${index}`)
                    .fontSize(12)
                    .fontColor('#999999')
                }
              }
              .alignItems(HorizontalAlign.Start)
              .flexGrow(1)

              // 删除按钮
              Button('删除')
                .fontSize(12)
                .height(32)
                .backgroundColor('#FF4D4F')
                .onClick(() => {
                  this.deleteContact(index);
                })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
          }
        }, (contact: Contact) => contact.id)
      }
      .width('100%')
      .layoutWeight(1)
      .divider({
        strokeWidth: 1,
        color: '#F0F0F0',
        startMargin: 76,
        endMargin: 16
      })
      .edgeEffect(EdgeEffect.Spring)
      .onReachEnd(() => {
        // 滚动到底部时自动加载更多
        if (!this.isLoading && this.dataSource.totalCount() < this.totalCount) {
          this.loadMoreData(50);
        }
      })

      // 底部加载状态
      if (this.isLoading) {
        Row() {
          LoadingProgress()
            .width(24)
            .height(24)
            .color('#1890FF')

          Text('加载中...')
            .fontSize(14)
            .fontColor('#666666')
            .margin({ left: 8 })
        }
        .width('100%')
        .height(48)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
