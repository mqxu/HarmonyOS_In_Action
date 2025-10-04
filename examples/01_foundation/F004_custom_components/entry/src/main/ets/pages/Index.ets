import { UserCard } from '../components/UserCard';
import { ArticleCard } from '../components/ArticleCard';
import { User } from '../models/User';
import { Article } from '../models/Article';
import hilog from '@ohos.hilog';

@Entry
@Component
struct Index {
  // 模拟用户数据
  private users: User[] = [
    new User(1, '张三', '👨‍💻', 'HarmonyOS 开发工程师', '专注于鸿蒙应用开发，分享技术心得'),
    new User(2, '李四', '👩‍🎨', 'UI/UX 设计师', '热爱设计，追求极致用户体验'),
    new User(3, '王五', '👨‍🏫', '技术讲师', '致力于鸿蒙技术推广和教育')
  ];

  // 模拟文章数据
  private articles: Article[] = [
    new Article(
      1,
      '深入理解 HarmonyOS 自定义组件开发',
      '张三',
      '📱',
      '本文将详细介绍 HarmonyOS 中自定义组件的开发技巧，包括 @Component、@Builder、@BuilderParam 等核心装饰器的使用方法...',
      ['HarmonyOS', 'ArkTS', '组件开发'],
      128,
      32
    ),
    new Article(
      2,
      'ArkTS 装饰器完全指南',
      '李四',
      '🎨',
      '装饰器是 ArkTS 中的核心特性，本文将系统地介绍各类装饰器的使用场景和最佳实践...',
      ['ArkTS', '装饰器', '最佳实践'],
      256,
      48
    )
  ];

  /**
   * 导航到自定义组件页面
   */
  private navigateToCustomComponent(): void {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/CustomComponentPage'
    }).catch((error: Error) => {
      hilog.error(0x0000, 'F004', `Navigation failed: ${error.message}`);
    });
  }

  /**
   * 导航到 Builder 页面
   */
  private navigateToBuilder(): void {
    this.getUIContext().getRouter().pushUrl({
      url: 'pages/BuilderPage'
    }).catch((error: Error) => {
      hilog.error(0x0000, 'F004', `Navigation failed: ${error.message}`);
    });
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text('自定义组件与复用')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor($r('app.color.bg_primary'))

      Scroll() {
        Column({ space: 16 }) {
          // 示例说明
          Text('本案例演示 HarmonyOS 自定义组件的三种核心技术：')
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .width('100%')
            .padding({ left: 16, right: 16 })

          // 导航卡片
          Column({ space: 12 }) {
            this.NavCard('1. @Component 组件', '创建可复用的自定义组件', () => {
              this.navigateToCustomComponent()
            })
            this.NavCard('2. @Builder 构建函数', '创建轻量级UI构建函数', () => {
              this.navigateToBuilder()
            })
            this.NavCard('3. @BuilderParam 参数', '实现组件内容定制', () => {
              this.navigateToBuilder()
            })
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 用户卡片示例
          Text('@Component 示例 - 用户卡片')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 8 })

          Row({ space: 12 }) {
            ForEach(this.users, (user: User) => {
              UserCard({
                user: user,
                cardWidth: 180,
                showActions: false
              })
            }, (user: User) => user.id.toString())
          }
          .width('100%')
          .padding({ left: 16, right: 16 })

          // 文章卡片示例
          Text('@Builder + @BuilderParam 示例 - 文章卡片')
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_primary'))
            .width('100%')
            .padding({ left: 16, right: 16 })
            .margin({ top: 8 })

          Column() {
            ForEach(this.articles, (article: Article) => {
              ArticleCard({ article: article })
            }, (article: Article) => article.id.toString())
          }
          .width('100%')
          .padding({ left: 16, right: 16 })
        }
        .padding({ top: 16, bottom: 16 })
      }
      .layoutWeight(1)
      .backgroundColor($r('app.color.bg_secondary'))
    }
    .width('100%')
    .height('100%')
  }

  /**
   * 导航卡片 Builder
   */
  @Builder
  NavCard(title: string, description: string, onClick: () => void) {
    Row({ space: 12 }) {
      Column({ space: 4 }) {
        Text(title)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_primary'))

        Text(description)
          .fontSize(13)
          .fontColor($r('app.color.text_secondary'))
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)

      Text('→')
        .fontSize(18)
        .fontColor($r('app.color.text_tertiary'))
    }
    .width('100%')
    .padding(16)
    .backgroundColor($r('app.color.bg_primary'))
    .borderRadius(8)
    .onClick(onClick)
  }
}
