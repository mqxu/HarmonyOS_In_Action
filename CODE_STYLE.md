# HarmonyOS-In-Action 代码规范 v1.0

本文档定义了 **HarmonyOS-In-Action** 项目的完整开发规范，所有贡献者必须严格遵守。

---

## 📚 目录

1. [项目命名和目录规范](#1-项目命名和目录规范)
2. [代码规范细节](#2-代码规范细节)
3. [测试策略细节](#3-测试策略细节)
4. [案例质量标准](#4-案例质量标准)
5. [依赖管理](#5-依赖管理)
6. [Git 工作流](#6-git-工作流)
7. [案例优先级](#7-案例优先级)
8. [文档标准](#8-文档标准)

---

## 1. 项目命名和目录规范

### ⚠️ 重要提示

**鸿蒙项目命名有严格限制**：只能使用字母、数字和下划线，**禁止使用连字符 `-`**！

详细规范请参考：[命名规范文档](docs/naming_convention.md)

### 1.1 案例编号规则

**格式**: `<分类目录>/<编号>_<名称>`

**示例**:
```
examples/01_foundation/F001_hello_world/
examples/02_ui_components/U001_button_showcase/
examples/07_ai_capabilities/A001_face_detection/
```

**编号前缀**:
- `F` - Foundation (基础入门)
- `U` - UI Components (UI组件)
- `L` - Layout & Navigation (布局导航)
- `D` - Data Persistence (数据持久化)
- `N` - Network & Cloud (网络云服务)
- `M` - Multimedia (多媒体)
- `A` - AI Capabilities (AI能力)
- `H` - Device & Hardware (设备硬件)
- `DS` - Distributed (分布式)
- `S` - Security & Auth (安全认证)
- `P` - Performance (性能优化)
- `E` - Enterprise (企业功能)
- `MP` - Mini Projects (综合项目)

### 1.2 文件和目录命名规则

#### ETS/TS 文件命名

```typescript
// ✅ 推荐
EntryAbility.ets           // Ability: PascalCase
HomePage.ets               // Page: PascalCase + Page后缀
UserCard.ets               // Component: PascalCase
UserViewModel.ets          // ViewModel: PascalCase + ViewModel
UserModel.ets              // Model: PascalCase + Model
UserService.ets            // Service: PascalCase + Service
dateUtil.ts                // Util: camelCase + Util
AppConstants.ets           // Constants: PascalCase + Constants
UserService.test.ets       // Test: <FileName>.test.ets

// ❌ 避免
user_card.ets
USER_CARD.ets
usercard.ets
UserService_test.ets
```

#### 目录命名

```
✅ 推荐:
pages/           # 全小写
components/      # 全小写
viewmodel/       # 全小写
constants/       # 全小写

❌ 避免:
Pages/
view-model/
view_model/
```

#### 文件扩展名规则

- **UI 相关**: 使用 `.ets` (包含 `@Component`、`@Entry` 的文件)
- **纯逻辑**: 使用 `.ts` (工具类、模型类、服务类)
- **测试文件**: 使用 `.ets` 或 `.ts` (根据被测试文件类型)

---

## 2. 代码规范细节

### 2.1 TypeScript 严格模式

**tsconfig.json 配置**:

```json
{
  "compilerOptions": {
    "strict": true,
    "strictNullChecks": true,
    "noImplicitAny": true,
    "noUnusedLocals": true,
    "noUnusedParameters": false
  }
}
```

**说明**:
- `noUnusedParameters` 设为 `false`，因为某些回调函数参数可能不使用

### 2.2 命名规范

```typescript
// 类名: PascalCase
class UserService { }

// 接口: PascalCase, 可选 I 前缀
interface UserInfo { }
interface IUserService { }

// 方法/变量: camelCase
function getUserInfo() { }
const userName: string = '';

// 常量: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';

// 私有属性: 下划线前缀
class MyClass {
  private _userId: string;
  private readonly _logger = new Logger();
}

// 布尔变量: is/has/can 前缀
const isLoading: boolean = false;
const hasPermission: boolean = true;
const canEdit: boolean = false;
```

### 2.3 状态管理风格

**单组件状态**:
```typescript
@Entry
@Component
struct HomePage {
  // 本地状态
  @State count: number = 0;

  // 全局存储
  @StorageLink('theme') theme: string = 'light';

  // 从 AppStorage 读取
  @StorageProp('userName') userName: string = '';

  build() {
    Column() {
      Text(`Count: ${this.count}`)
      Button('Add').onClick(() => {
        this.count++;  // 直接修改
      })
    }
  }
}
```

**跨组件状态**:
```typescript
// 父子组件: @Provide/@Consume
@Component
struct ParentComponent {
  @Provide('userData') userData: UserData = new UserData();
}

@Component
struct ChildComponent {
  @Consume('userData') userData: UserData;
}

// 全局状态: AppStorage
AppStorage.setOrCreate('currentUser', new User());

// 页面级状态: LocalStorage
const storage = new LocalStorage({ count: 0 });
```

### 2.4 错误处理方式

**推荐**: 使用 `BusinessError` 标准错误类型

```typescript
import { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';

const TAG = 'UserService';
const DOMAIN = 0x0001;

async getUserInfo(userId: string): Promise<UserInfo> {
  try {
    const result = await http.request({ url: `/users/${userId}` });
    return result.data as UserInfo;
  } catch (err) {
    const error = err as BusinessError;
    hilog.error(DOMAIN, TAG, `Failed to get user: code=${error.code}, message=${error.message}`);

    // 重新抛出标准错误
    throw {
      code: error.code || -1,
      message: error.message || 'Unknown error'
    } as BusinessError;
  }
}
```

**UI 层转换为 Result 模式**:
```typescript
interface Result<T> {
  success: boolean;
  data?: T;
  error?: {
    code: number;
    message: string;
  };
}

async loadUserInfo(): Promise<void> {
  const result = await this.wrapResult(() =>
    this.userService.getUserInfo('123')
  );

  if (result.success) {
    this.userInfo = result.data!;
  } else {
    this.showError(result.error!.message);
  }
}

private async wrapResult<T>(fn: () => Promise<T>): Promise<Result<T>> {
  try {
    const data = await fn();
    return { success: true, data };
  } catch (err) {
    const error = err as BusinessError;
    return {
      success: false,
      error: {
        code: error.code || -1,
        message: error.message || '未知错误'
      }
    };
  }
}
```

### 2.5 日志规范

**统一使用 hilog**:

```typescript
import hilog from '@ohos.hilog';

class UserService {
  private readonly TAG = 'UserService';
  private readonly DOMAIN = 0x0001;  // 每个模块一个 DOMAIN

  getUserInfo(userId: string): UserInfo {
    // 调试日志
    hilog.debug(this.DOMAIN, this.TAG, `Getting user info: userId=%{public}s`, userId);

    // 信息日志
    hilog.info(this.DOMAIN, this.TAG, 'User info loaded successfully');

    // 警告日志
    hilog.warn(this.DOMAIN, this.TAG, 'User cache expired');

    // 错误日志
    hilog.error(this.DOMAIN, this.TAG, 'Failed to load user: %{public}s', error.message);

    // 致命错误
    hilog.fatal(this.DOMAIN, this.TAG, 'Critical system error');
  }
}
```

**日志级别使用**:
- `debug`: 开发调试信息
- `info`: 一般信息（如用户操作）
- `warn`: 警告（如数据异常但可恢复）
- `error`: 错误（如网络请求失败）
- `fatal`: 致命错误（如系统崩溃）

**敏感信息保护**:
```typescript
// ✅ 公开信息
hilog.info(DOMAIN, TAG, 'User login: %{public}s', userName);

// ✅ 敏感信息
hilog.info(DOMAIN, TAG, 'Password hash: %{private}s', passwordHash);
```

### 2.6 异步编程风格

**推荐**: 统一使用 `async/await`

```typescript
// ✅ 推荐: async/await
async loadData(): Promise<void> {
  this.loading = true;
  try {
    const users = await this.userService.getUserList();
    const posts = await this.postService.getPostList();
    this.processData(users, posts);
  } catch (err) {
    this.showError(err);
  } finally {
    this.loading = false;
  }
}

// ✅ 并发请求
async loadDataConcurrently(): Promise<void> {
  try {
    const [users, posts] = await Promise.all([
      this.userService.getUserList(),
      this.postService.getPostList()
    ]);
    this.processData(users, posts);
  } catch (err) {
    this.showError(err);
  }
}

// ❌ 避免: Promise 链式调用（除非特殊场景）
loadData(): void {
  this.loading = true;
  this.userService.getUserList()
    .then(users => this.processUsers(users))
    .catch(err => this.showError(err))
    .finally(() => this.loading = false);
}
```

### 2.7 注释规范

#### 类注释（必须）

```typescript
/**
 * 用户信息管理服务
 *
 * 提供用户增删改查、认证、权限管理等功能。
 * 支持本地缓存和分布式同步。
 *
 * @author mqxu
 * @since 1.0.0
 * @syscap SystemCapability.Account.OsAccount
 *
 * @example
 * ```ts
 * const userService = new UserService();
 * const user = await userService.getUserInfo('123');
 * ```
 */
export class UserService {
  // ...
}
```

#### 公开方法注释（必须）

```typescript
/**
 * 获取用户信息
 *
 * 根据用户ID从服务器获取用户详细信息。如果本地缓存存在且未过期，
 * 则直接返回缓存数据。
 *
 * @param userId - 用户唯一标识，不能为空
 * @returns 用户信息对象，若用户不存在返回 null
 * @throws {BusinessError} 401 - 参数错误: userId 为空或格式不正确
 * @throws {BusinessError} 12300001 - 用户不存在
 * @throws {BusinessError} 12300002 - 网络请求失败
 * @throws {BusinessError} 12300003 - 服务器内部错误
 *
 * @example
 * ```ts
 * try {
 *   const user = await userService.getUserInfo('123');
 *   if (user) {
 *     console.log(user.name);
 *   }
 * } catch (err) {
 *   console.error(err.message);
 * }
 * ```
 */
async getUserInfo(userId: string): Promise<UserInfo | null> {
  // 实现
}
```

#### 私有方法注释（可选，复杂逻辑必须）

```typescript
/**
 * 验证用户ID格式
 * @param userId - 用户ID
 * @returns 是否有效
 */
private validateUserId(userId: string): boolean {
  return /^[0-9]{6,10}$/.test(userId);
}
```

#### 行内注释（关键逻辑必须）

```typescript
// ✅ 好的注释：解释为什么
// 延迟 300ms 防止用户快速输入时频繁触发搜索
await sleep(300);

// 使用二分查找优化性能，数据量 >1000 时明显提升
const index = this.binarySearch(list, target);

// ❌ 不必要的注释：重复代码
// 设置用户名
this.userName = 'John';

// 创建按钮
Button('Click me')
```

#### 常量注释（必须）

```typescript
/** API 请求超时时间（毫秒） */
const REQUEST_TIMEOUT = 5000;

/** 列表每页显示数量 */
const PAGE_SIZE = 20;

/** 用户会话有效期（秒） */
const SESSION_EXPIRE_TIME = 7200;
```

### 2.8 代码格式

```typescript
// 缩进: 2空格
@Component
struct MyComponent {
  @State count: number = 0;

  build() {
    Column() {
      Text('Hello')
    }
  }
}

// 单行最大长度: 120字符
// 如果超出，合理换行
const message = `This is a very long string that exceeds the maximum ` +
  `line length and should be split into multiple lines`;

// 对象字面量: 每个属性一行（超过3个属性时）
const user = {
  id: '123',
  name: 'John',
  age: 25,
  email: 'john@example.com'
};

// 数组: 简短可以单行，较长换行
const colors = ['red', 'green', 'blue'];
const longArray = [
  'item1',
  'item2',
  'item3',
  'item4'
];

// 函数参数: 超过3个换行
function createUser(
  id: string,
  name: string,
  age: number,
  email: string
): User {
  // ...
}
```

---

## 3. 测试策略细节

### 3.1 测试覆盖率要求

| 代码类型 | 覆盖率要求 | 说明 |
|---------|-----------|------|
| Utils/Services | 100% | 核心业务逻辑必须全覆盖 |
| ViewModels | ≥90% | 业务逻辑尽量覆盖 |
| Components | ≥70% | UI组件测试交互逻辑 |
| Pages | ≥50% | 页面主要流程 |

### 3.2 测试文件命名和组织

```
src/
├── service/
│   └── UserService.ts
└── ohosTest/
    └── ets/
        └── test/
            └── UserService.test.ets
```

### 3.3 测试用例编写规范

```typescript
import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';
import { UserService } from '../../service/UserService';

export default function UserServiceTest() {
  describe('UserService', () => {
    let userService: UserService;

    // 所有测试前执行一次
    beforeAll(() => {
      console.info('=== UserService Test Start ===');
    });

    // 所有测试后执行一次
    afterAll(() => {
      console.info('=== UserService Test End ===');
    });

    // 每个测试前执行
    beforeEach(() => {
      userService = new UserService();
    });

    // 每个测试后执行
    afterEach(() => {
      userService = null;
    });

    /**
     * @tc.number   : TEST_USER_SERVICE_001
     * @tc.name     : 测试获取用户信息
     * @tc.desc     : 验证 getUserInfo 方法返回正确的用户数据
     * @tc.size     : MediumTest
     * @tc.type     : Function
     * @tc.level    : Level 1
     */
    it('getUserInfo_should_return_valid_user', 0, async () => {
      // Arrange: 准备测试数据
      const userId = '123';

      // Act: 执行被测试方法
      const user = await userService.getUserInfo(userId);

      // Assert: 验证结果
      expect(user).assertNotNull();
      expect(user.id).assertEqual(userId);
      expect(user.name).assertNotNull();
    });

    /**
     * @tc.number   : TEST_USER_SERVICE_002
     * @tc.name     : 测试用户不存在异常
     * @tc.desc     : 验证用户不存在时抛出正确的异常
     * @tc.size     : MediumTest
     * @tc.type     : Function
     * @tc.level    : Level 1
     */
    it('getUserInfo_should_throw_when_user_not_exist', 0, async () => {
      try {
        await userService.getUserInfo('invalid_id');
        expect().assertFail();  // 不应该执行到这里
      } catch (err) {
        expect(err.code).assertEqual(12300001);
        expect(err.message).assertContain('用户不存在');
      }
    });

    /**
     * @tc.number   : TEST_USER_SERVICE_003
     * @tc.name     : 测试参数校验
     * @tc.desc     : 验证空参数时抛出参数错误
     * @tc.size     : MediumTest
     * @tc.type     : Function
     * @tc.level    : Level 1
     */
    it('getUserInfo_should_throw_when_userId_empty', 0, async () => {
      try {
        await userService.getUserInfo('');
        expect().assertFail();
      } catch (err) {
        expect(err.code).assertEqual(401);
      }
    });
  });
}
```

### 3.4 Mock 数据管理

**创建 Mock 工厂**:

```typescript
// test/mock/UserFactory.ts
export class UserFactory {
  /**
   * 创建单个用户
   */
  static createUser(overrides?: Partial<User>): User {
    return {
      id: '123',
      name: '张三',
      age: 25,
      email: 'zhangsan@example.com',
      avatar: 'https://example.com/avatar.jpg',
      ...overrides
    };
  }

  /**
   * 创建用户列表
   */
  static createUserList(count: number): User[] {
    return Array.from({ length: count }, (_, i) =>
      this.createUser({
        id: `${i + 1}`,
        name: `用户${i + 1}`
      })
    );
  }

  /**
   * 创建空用户
   */
  static createEmptyUser(): User {
    return {
      id: '',
      name: '',
      age: 0,
      email: '',
      avatar: ''
    };
  }
}
```

**使用 Hamock 框架**:

```typescript
import { when, mockFunc } from '@ohos/hamock';

it('should_use_mock_service', 0, async () => {
  // Mock 方法返回值
  when(userService.getUserInfo)('123')
    .afterReturn(UserFactory.createUser({ id: '123' }));

  // 调用方法
  const user = await userService.getUserInfo('123');

  // 验证
  expect(user.id).assertEqual('123');
});
```

### 3.5 性能测试

```typescript
/**
 * @tc.number   : PERF_LIST_RENDER_001
 * @tc.name     : 测试列表渲染性能
 * @tc.desc     : 1000条数据渲染时间应 <500ms
 * @tc.size     : LargeTest
 * @tc.type     : Performance
 * @tc.level    : Level 2
 */
it('list_render_performance', 0, async () => {
  const dataList = UserFactory.createUserList(1000);

  const startTime = Date.now();
  await renderList(dataList);
  const duration = Date.now() - startTime;

  hilog.info(DOMAIN, TAG, `Render time: ${duration}ms`);
  expect(duration).assertLess(500);
});
```

---

## 4. 案例完成检查清单

每个案例必须完成以下所有项：

#### ✅ 文件结构
- [ ] README.md（完整说明）
- [ ] 完整可运行的代码
- [ ] 测试文件（覆盖率达标）
- [ ] screenshots/（至少2张效果图）
- [ ] docs/api-usage.md（API详解，可选）

#### ✅ README 内容
- [ ] 功能描述（1-2段）
- [ ] 效果截图/视频
- [ ] 涉及 API 清单（带官方文档链接）
- [ ] 运行步骤
- [ ] 学习目标（3-5条）
- [ ] 前置知识
- [ ] 核心代码解析
- [ ] 关键知识点
- [ ] 扩展学习方向
- [ ] 常见问题 FAQ

#### ✅ 代码质量
- [ ] 通过 ESLint 检查
- [ ] 通过 ArkTS Linter 检查
- [ ] 所有公开方法有 JSDoc 注释
- [ ] 关键逻辑有行内注释
- [ ] 无 console.log（使用 hilog）
- [ ] 无硬编码魔法值（使用常量）
- [ ] 无重复代码（DRY 原则）

#### ✅ 测试质量
- [ ] 单元测试覆盖率达标
- [ ] 所有测试用例通过
- [ ] 性能测试通过（如适用）
- [ ] 边界条件测试
- [ ] 异常情况测试

#### ✅ 其他
- [ ] API 使用正确（参考官方文档）
- [ ] 适配多设备（手机、平板，如适用）
- [ ] 无明显性能问题
- [ ] 代码可直接运行（一键启动）

---

## 5. 依赖管理

### 5.1 允许使用的依赖

**✅ 允许**:
- `@ohos/*` - OpenHarmony 官方库
- `@hms/*` - HMS 官方库
- 工具库（仅在特定案例演示时使用）:
  - `lodash-es` - JavaScript 工具库
  - `dayjs` - 日期处理库
  - `uuid` - UUID 生成

**❌ 禁止**:
- UI 组件库（应该自己实现）
- 重量级框架（如 Redux，应该用鸿蒙原生方案）
- `axios`（应该封装 `@ohos.net.http`）

### 5.2 版本管理

```json
{
  "name": "Harmonyos_In_Action",
  "version": "1.0.0",
  "dependencies": {
    "@ohos/hypium": "1.0.21",     // 锁定版本
    "@ohos/hamock": "1.0.0"
  }
}
```

**语义化版本规则**:
- 主版本号（1.x.x）：大规模重构
- 次版本号（x.1.x）：新增案例批次
- 修订号（x.x.1）：Bug 修复

---

## 6. Git 工作流

### 6.1 分支策略

采用 **GitHub Flow** 简化模型：

```
main           # 主分支，只接受 PR 合并
├── feature/*  # 功能分支
```

### 6.2 Commit 信息规范

**格式**: `<type>(<scope>): <subject>`

**类型（type）**:
- `feat`: 新增案例或功能
- `fix`: 修复 Bug
- `docs`: 文档更新
- `style`: 代码格式（不影响功能）
- `refactor`: 重构
- `test`: 测试相关
- `chore`: 构建/工具配置

**范围（scope）**:
- `foundation` / `ui-components` / `ai` 等分类名
- `common` - 公共库
- `scripts` - 脚本工具
- `docs` - 文档

**主题（subject）**: 简短描述（中文）

**示例**:
```bash
feat(foundation): 新增 F001 Hello World 案例
fix(ui-components): 修复 U005 对话框关闭问题
docs(readme): 更新快速开始指南
test(network): 补充 HTTP 请求边界测试
chore(scripts): 优化案例创建脚本
```

### 6.3 PR 流程

1. **Fork 仓库** 并克隆到本地
2. 创建功能分支: `git checkout -b feature/F020_timer_app`
3. 开发案例并确保通过所有检查
4. 提交代码: `git commit -m "feat(foundation): 新增 F020 计时器应用"`
5. 推送到远程: `git push origin feature/F020_timer_app`
6. 创建 Pull Request
7. 等待 Code Review
8. 根据反馈修改
9. 合并到 main

---

## 7. 案例优先级

### 7.1 优先级定义

| 优先级 | 说明 | 案例数量 |
|--------|------|---------|
| **P0** | 必须覆盖，入门必备 | ~40 |
| **P1** | 推荐覆盖，常用功能 | ~80 |
| **P2** | 可选覆盖，高级特性 | ~84 |

### 7.2 难度标签

```
🟢 [BASIC]    - 基础：10-50行核心代码
🟡 [INTER]    - 中级：50-200行核心代码
🔴 [ADVANCED] - 高级：200+行核心代码
⚫ [EXPERT]   - 专家：复杂架构
```

---

## 8. 文档标准

### 8.1 语言规范

- **文档内容**: 中文
- **代码标识符**: 英文（类名、方法名、变量名）
- **技术术语**: 中英混合（首次出现标注英文）

**示例**:
```markdown
## 状态管理 (State Management)

使用 `@State` 装饰器 (Decorator) 可以将变量标记为响应式状态...
```

### 8.2 图片视频规范

**截图**:
- 格式: PNG 或 JPG
- 尺寸: 宽度 ≤ 800px
- 命名: 描述性英文（`initial-state.png`）
- 位置: `screenshots/` 目录
- 大小: ≤ 500KB

**视频**:
- 格式: MP4
- 时长: ≤ 30秒
- 分辨率: 1080x2340 或 720x1560
- 帧率: 30fps
- 大小: ≤ 5MB

### 8.3 术语统一

| 中文 | 英文 | 说明 |
|-----|------|------|
| 能力集 | Ability | 应用组件 |
| 装饰器 | Decorator | @State 等 |
| 状态管理 | State Management | 数据绑定 |
| 生命周期 | Lifecycle | 组件/Ability 生命周期 |

---

## ✅ 检查清单

在提交 PR 前，请确认：

- [ ] 代码符合所有命名规范
- [ ] 所有公开方法有完整注释
- [ ] 测试覆盖率达标
- [ ] 通过 Lint 检查
- [ ] README 完整
- [ ] 有效果截图
- [ ] Commit 信息符合规范
- [ ] 代码可直接运行

---

## 📞 联系方式

如对规范有疑问，请：
- 提交 Issue
- 在 Discussion 中讨论
- 联系项目维护者

---

**最后更新**: 2025-10-02
**版本**: v1.0.0
