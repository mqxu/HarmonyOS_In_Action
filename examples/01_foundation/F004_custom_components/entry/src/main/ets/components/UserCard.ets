import { User } from '../models/User';

/**
 * 用户卡片组件
 * 演示 @Component 装饰器的使用
 */
@Component
export struct UserCard {
  @Prop user: User; // 父组件传递的用户数据
  @Prop cardWidth: number = 300; // 卡片宽度，带默认值
  @Prop showActions: boolean = true; // 是否显示操作按钮

  build() {
    Column({ space: 12 }) {
      // 用户头像
      Image(this.user.avatar)
        .width(80)
        .height(80)
        .borderRadius(40)
        .backgroundColor($r('app.color.bg_secondary'))

      // 用户信息
      Column({ space: 4 }) {
        Text(this.user.name)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Text(this.user.role)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))

        Text(this.user.description)
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 8 })
      }
      .alignItems(HorizontalAlign.Center)

      // 操作按钮
      if (this.showActions) {
        Row({ space: 12 }) {
          Button('关注')
            .fontSize(14)
            .backgroundColor($r('app.color.brand_primary'))
            .height(32)
            .layoutWeight(1)

          Button('私信')
            .fontSize(14)
            .backgroundColor($r('app.color.bg_secondary'))
            .fontColor($r('app.color.text_primary'))
            .height(32)
            .layoutWeight(1)
        }
        .width('100%')
      }
    }
    .width(this.cardWidth)
    .padding(16)
    .backgroundColor($r('app.color.bg_primary'))
    .borderRadius(12)
    .shadow({
      radius: 12,
      color: '#1F000000',
      offsetX: 0,
      offsetY: 4
    })
  }
}
