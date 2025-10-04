import { Article } from '../models/Article';

/**
 * 文章卡片组件
 * 演示 @Builder 和 @BuilderParam 的使用
 */
@Component
export struct ArticleCard {
  @Prop article: Article;
  // 自定义头部构建器
  @BuilderParam customHeader: () => void = this.defaultHeader;
  // 自定义底部构建器
  @BuilderParam customFooter: () => void = this.defaultFooter;

  /**
   * 默认头部Builder
   */
  @Builder
  defaultHeader() {
    Row({ space: 8 }) {
      Text(this.article.author)
        .fontSize(14)
        .fontColor($r('app.color.text_primary'))
        .fontWeight(FontWeight.Medium)

      Text('·')
        .fontSize(14)
        .fontColor($r('app.color.text_tertiary'))

      Text('2小时前')
        .fontSize(12)
        .fontColor($r('app.color.text_tertiary'))
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12 })
  }

  /**
   * 默认底部Builder
   */
  @Builder
  defaultFooter() {
    Row({ space: 24 }) {
      this.ActionButton('❤️', this.article.likes.toString())
      this.ActionButton('💬', this.article.comments.toString())
      this.ActionButton('🔖', '收藏')
      this.ActionButton('📤', '分享')
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 12 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  /**
   * 操作按钮Builder
   */
  @Builder
  ActionButton(icon: string, text: string) {
    Row({ space: 4 }) {
      Text(icon)
        .fontSize(16)

      Text(text)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
    }
  }

  /**
   * 标签Builder
   */
  @Builder
  TagList() {
    Row({ space: 8 }) {
      ForEach(this.article.tags, (tag: string) => {
        Text(`# ${tag}`)
          .fontSize(12)
          .fontColor($r('app.color.brand_primary'))
          .padding({
            left: 8,
            right: 8,
            top: 4,
            bottom: 4
          })
          .backgroundColor($r('app.color.bg_secondary'))
          .borderRadius(4)
      }, (tag: string) => tag)
    }
  }

  build() {
    Column() {
      // 自定义或默认头部
      this.customHeader()

      // 文章内容
      Column({ space: 8 }) {
        // 标题
        Text(this.article.title)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // 摘要
        Text(this.article.summary)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 4 })

        // 封面图
        Image(this.article.coverImage)
          .width('100%')
          .height(160)
          .borderRadius(8)
          .objectFit(ImageFit.Cover)
          .backgroundColor($r('app.color.bg_secondary'))
          .margin({ top: 8 })

        // 标签
        this.TagList()
      }
      .alignItems(HorizontalAlign.Start)
      .padding({
        left: 16,
        right: 16,
        top: 8,
        bottom: 8
      })

      // 自定义或默认底部
      this.customFooter()
    }
    .width('100%')
    .backgroundColor($r('app.color.bg_primary'))
    .borderRadius(12)
    .margin({ bottom: 12 })
    .shadow({
      radius: 8,
      color: '#0F000000',
      offsetX: 0,
      offsetY: 2
    })
  }
}
