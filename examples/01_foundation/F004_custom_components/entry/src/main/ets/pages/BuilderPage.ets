import { ArticleCard } from '../components/ArticleCard';
import { Article } from '../models/Article';
import hilog from '@ohos.hilog';

@Entry
@Component
struct BuilderPage {
  @State article: Article = new Article(
    1,
    '鸿蒙开发进阶：深入理解 @Builder 和 @BuilderParam',
    '技术专家',
    '🚀',
    '@Builder 用于创建轻量级的 UI 构建函数，而 @BuilderParam 允许组件接收外部传入的 UI 构建函数，实现高度的UI定制化。这是鸿蒙开发中非常重要的进阶技能...',
    ['Builder', 'BuilderParam', '进阶'],
    512,
    96
  );

  @State useCustomHeader: boolean = false;
  @State useCustomFooter: boolean = false;

  /**
   * 返回上一页
   */
  private goBack(): void {
    this.getUIContext().getRouter().back();
  }

  /**
   * 自定义文章头部
   */
  @Builder
  customArticleHeader() {
    Row({ space: 8 }) {
      Image('👤')
        .width(32)
        .height(32)
        .borderRadius(16)
        .backgroundColor($r('app.color.bg_secondary'))

      Column({ space: 2 }) {
        Text(this.article.author)
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))

        Text('专业技术博主 · 已关注')
          .fontSize(12)
          .fontColor($r('app.color.brand_primary'))
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding({ left: 16, right: 16, top: 12 })
  }

  /**
   * 自定义文章底部
   */
  @Builder
  customArticleFooter() {
    Column({ space: 8 }) {
      Row({ space: 12 }) {
        Button('点赞 👍')
          .fontSize(13)
          .backgroundColor($r('app.color.brand_primary'))
          .height(36)
          .layoutWeight(1)

        Button('评论 💬')
          .fontSize(13)
          .backgroundColor($r('app.color.bg_secondary'))
          .fontColor($r('app.color.text_primary'))
          .height(36)
          .layoutWeight(1)

        Button('分享 📤')
          .fontSize(13)
          .backgroundColor($r('app.color.bg_secondary'))
          .fontColor($r('app.color.text_primary'))
          .height(36)
          .layoutWeight(1)
      }
      .width('100%')

      Row() {
        Text(`${this.article.likes} 人点赞 · ${this.article.comments} 条评论`)
          .fontSize(12)
          .fontColor($r('app.color.text_tertiary'))
      }
      .width('100%')
    }
    .width('100%')
    .padding({ left: 16, right: 16, bottom: 12, top: 8 })
  }

  build() {
    Column() {
      // 导航栏
      Row() {
        Text('←')
          .fontSize(24)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            this.goBack()
          })

        Text('@Builder + @BuilderParam')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
          .margin({ left: 12 })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.bg_primary'))

      Scroll() {
        Column({ space: 24 }) {
          // 说明
          Column({ space: 8 }) {
            Text('装饰器说明')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Column({ space: 8 }) {
              this.ExplanationItem(
                '@Builder',
                '创建轻量级的 UI 构建函数，可以在组件内部定义可复用的 UI 片段'
              )
              this.ExplanationItem(
                '@BuilderParam',
                '允许组件接收外部传入的 Builder 函数，实现 UI 内容的定制化'
              )
            }

            Text('使用场景：')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .margin({ top: 12 })

            Column({ space: 4 }) {
              this.FeatureItem('组件内部的 UI 复用（@Builder）')
              this.FeatureItem('提供默认 UI 但允许定制（@BuilderParam）')
              this.FeatureItem('实现插槽（Slot）类似的功能')
              this.FeatureItem('构建复杂的可配置组件')
            }
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(8)

          // 实时预览
          Column({ space: 12 }) {
            Text('实时预览')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            // 根据开关显示不同的文章卡片
            if (this.useCustomHeader && this.useCustomFooter) {
              ArticleCard({
                article: this.article,
                customHeader: () => {
                  this.customArticleHeader()
                },
                customFooter: () => {
                  this.customArticleFooter()
                }
              })
            } else if (this.useCustomHeader) {
              ArticleCard({
                article: this.article,
                customHeader: () => {
                  this.customArticleHeader()
                }
              })
            } else if (this.useCustomFooter) {
              ArticleCard({
                article: this.article,
                customFooter: () => {
                  this.customArticleFooter()
                }
              })
            } else {
              ArticleCard({ article: this.article })
            }
          }
          .width('100%')

          // 控制面板
          Column({ space: 16 }) {
            Text('定制控制')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            // 自定义头部
            Row() {
              Text('使用自定义头部')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.useCustomHeader })
                .selectedColor($r('app.color.brand_primary'))
                .onChange((isOn: boolean) => {
                  this.useCustomHeader = isOn;
                })
            }
            .width('100%')

            // 自定义底部
            Row() {
              Text('使用自定义底部')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.useCustomFooter })
                .selectedColor($r('app.color.brand_primary'))
                .onChange((isOn: boolean) => {
                  this.useCustomFooter = isOn;
                })
            }
            .width('100%')
          }
          .width('100%')
          .padding(16)
          .backgroundColor($r('app.color.bg_primary'))
          .borderRadius(8)

          // 代码示例
          Column({ space: 8 }) {
            Text('代码示例')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text(`// 定义 Builder\n@Builder\ncustomHeader() {\n  // UI 内容\n}\n\n// 使用 BuilderParam\nArticleCard({\n  article: article,\n  customHeader: () => {\n    this.customHeader()\n  }\n})`)
              .fontSize(12)
              .fontFamily('monospace')
              .fontColor($r('app.color.text_secondary'))
              .padding(12)
              .backgroundColor($r('app.color.bg_secondary'))
              .borderRadius(4)
              .width('100%')
          }
          .width('100%')
        }
        .padding(16)
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.bg_secondary'))
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  FeatureItem(text: string) {
    Row({ space: 8 }) {
      Text('•')
        .fontSize(14)
        .fontColor($r('app.color.brand_primary'))
      Text(text)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
    }
  }

  @Builder
  ExplanationItem(title: string, description: string) {
    Column({ space: 4 }) {
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.brand_primary'))

      Text(description)
        .fontSize(13)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(20)
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .padding(12)
    .backgroundColor($r('app.color.bg_secondary'))
    .borderRadius(4)
  }
}
