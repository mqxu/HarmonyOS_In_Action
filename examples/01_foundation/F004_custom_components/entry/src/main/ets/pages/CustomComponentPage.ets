import { UserCard } from '../components/UserCard';
import { User } from '../models/User';
import hilog from '@ohos.hilog';

@Entry
@Component
struct CustomComponentPage {
  @State currentUser: User = new User(
    1,
    '赵六',
    '👨‍💼',
    '产品经理',
    '关注用户需求，打造极致产品体验'
  );
  @State cardWidth: number = 300;
  @State showActions: boolean = true;

  /**
   * 返回上一页
   */
  private goBack(): void {
    this.getUIContext().getRouter().back();
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

        Text('@Component 自定义组件')
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
            Text('@Component 装饰器说明')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            Text('@Component 用于创建自定义组件，可以封装UI结构和业务逻辑，实现代码复用。')
              .fontSize(14)
              .fontColor($r('app.color.text_secondary'))
              .lineHeight(22)

            Text('核心特性：')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor($r('app.color.text_primary'))
              .margin({ top: 8 })

            Column({ space: 4 }) {
              this.FeatureItem('1. 使用 @Prop 接收父组件传递的数据')
              this.FeatureItem('2. 支持属性的默认值设置')
              this.FeatureItem('3. 可以包含状态管理和生命周期')
              this.FeatureItem('4. 完全支持 ArkTS 的所有特性')
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

            UserCard({
              user: this.currentUser,
              cardWidth: this.cardWidth,
              showActions: this.showActions
            })
          }
          .width('100%')

          // 控制面板
          Column({ space: 16 }) {
            Text('属性控制')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor($r('app.color.text_primary'))

            // 卡片宽度
            Column({ space: 8 }) {
              Row() {
                Text('卡片宽度')
                  .fontSize(14)
                  .fontColor($r('app.color.text_secondary'))
                Blank()
                Text(`${this.cardWidth}px`)
                  .fontSize(14)
                  .fontColor($r('app.color.brand_primary'))
              }
              .width('100%')

              Slider({
                value: this.cardWidth,
                min: 200,
                max: 400,
                step: 10
              })
                .blockColor($r('app.color.brand_primary'))
                .trackColor($r('app.color.bg_secondary'))
                .selectedColor($r('app.color.brand_primary'))
                .onChange((value: number) => {
                  this.cardWidth = value;
                })
            }

            // 显示操作按钮
            Row() {
              Text('显示操作按钮')
                .fontSize(14)
                .fontColor($r('app.color.text_secondary'))
              Blank()
              Toggle({ type: ToggleType.Switch, isOn: this.showActions })
                .selectedColor($r('app.color.brand_primary'))
                .onChange((isOn: boolean) => {
                  this.showActions = isOn;
                })
            }
            .width('100%')

            // 更改用户数据
            Button('切换用户数据')
              .width('100%')
              .backgroundColor($r('app.color.brand_primary'))
              .onClick(() => {
                const users: User[] = [
                  new User(1, '张三', '👨‍💻', 'HarmonyOS 开发工程师', '专注于鸿蒙应用开发，分享技术心得'),
                  new User(2, '李四', '👩‍🎨', 'UI/UX 设计师', '热爱设计，追求极致用户体验'),
                  new User(3, '王五', '👨‍🏫', '技术讲师', '致力于鸿蒙技术推广和教育'),
                  new User(4, '赵六', '👨‍💼', '产品经理', '关注用户需求，打造极致产品体验')
                ];
                const randomIndex: number = Math.floor(Math.random() * users.length);
                this.currentUser = users[randomIndex];
              })
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

            Text(`// 使用自定义组件\nUserCard({\n  user: user,\n  cardWidth: 300,\n  showActions: true\n})`)
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
}
