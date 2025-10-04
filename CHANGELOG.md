# 更新日志

本文档记录 **HarmonyOS_In_Action** 项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本 2.0.0](https://semver.org/lang/zh-CN/)。

---

## [Unreleased]

### 计划中
- 创建公共基础库（Logger、HttpClient、StorageUtil 等）
- 开发后续基础案例（F005-F015）
- 开发 UI 组件案例（U001-U025）

---

## [0.2.0] - 2025-10-04

### 新增

#### 案例开发
- ✅ **F001: Hello World** - 完成鸿蒙入门第一个示例
  - UIAbility 生命周期演示
  - Text、Button 基础组件使用
  - 完整的单元测试和文档

- ✅ **F002: 状态管理进阶** - 完成 5 种状态管理模式演示
  - @State 组件内状态管理
  - @Prop 单向数据传递
  - @Link 双向数据绑定
  - @Provide/@Consume 跨层级状态共享
  - 完整的交互式示例和最佳实践说明

- ✅ **F003: 列表渲染与优化** - 完成高性能列表开发案例
  - ForEach 基础渲染
  - LazyForEach + IDataSource 懒加载
  - 列表性能优化技巧（itemKeyGenerator、缓存计数、@Reusable）
  - 模拟 10000 条数据的性能测试

- ✅ **F004: 自定义组件与复用** - 完成组件化开发最佳实践
  - @Component 自定义组件封装
  - @Builder UI 构建函数复用
  - @BuilderParam 插槽式组件定制
  - UserCard、ArticleCard 真实业务组件示例
  - 统一资源配色系统（$r('app.color.xxx')）

#### 项目基础设施
- 创建基础项目模板 `templates/basic_harmonyos_project`
  - 标准目录结构
  - 配置文件模板
  - 资源文件示例

#### 文档完善
- 完成 182 个案例的完整规划文档
  - 13 个分类，每个案例包含难度、核心 API、状态标记
  - 更新 README.md 和 CLAUDE.md 中的案例索引
- 添加进度跟踪系统
  - 分类完成度统计
  - API 覆盖率实时更新
  - 已完成案例清单
- 添加仓库优化说明
  - .gitignore 配置说明
  - 仓库大小预估（182 案例预计 <100MB）

### 修改
- 修正 API 覆盖率目标：从 83%+ 调整为 80%+（更符合 182 案例的实际覆盖能力）
- 统一案例目录命名风格：使用下划线分隔（01_foundation、02_ui_components 等）
- 优化 Git 提交信息规范：移除 Claude Code 签名
- 强制 TypeScript 类型声明：禁止使用 `any` 类型和字面量变量
- 统一路由 API：使用新版 `getUIContext().getRouter()` 替代过时 API
- 统一颜色管理：强制使用资源颜色 `$r('app.color.xxx')`

### 项目进度
- **案例完成度**: 4/182 (2.2%)
  - 01-基础入门: 4/15 (26.7%)
- **API 覆盖率**:
  - OpenHarmony: 20/388 (5.2%)
  - HMS: 5/163 (3.1%)
  - UI组件: 18/120 (15%)
- **已完成案例**:
  - ✅ F001: Hello World
  - ✅ F002: 状态管理进阶
  - ✅ F003: 列表渲染与优化
  - ✅ F004: 自定义组件与复用

---

## [0.1.0] - 2025-10-02

### 新增

#### 项目基础设施
- 初始化项目目录结构（examples、common、docs、scripts、templates、tools）
- 创建 13 个案例分类目录（基础入门、UI 组件、布局导航等）
- 配置 `.gitignore` 忽略规则
- 为空目录添加 `.gitkeep` 占位文件

#### 核心文档
- 完成 `README.md` 主文档
  - 项目简介和特色
  - 完整案例索引（204 个案例规划）
  - 学习路径指南（初级/中级/高级）
  - 项目结构说明
- 完成 `CODE_STYLE.md` 开发规范 v1.0
  - 项目命名和目录规范
  - 代码规范细节（命名、状态管理、错误处理、日志、异步编程、注释）
  - 测试策略细节（覆盖率、测试用例、Mock 数据）
  - 案例完成检查清单
  - Git 工作流规范
- 完成 `CONTRIBUTING.md` 贡献指南
  - 贡献方式说明
  - 开发环境准备
  - 代码贡献流程
  - 案例开发规范
  - 提交规范（Conventional Commits）
  - Pull Request 指南
  - 问题反馈模板

#### 工具和辅助文档
- 创建 `scripts/verify_links.sh` 链接验证脚本
  - 自动扫描所有 Markdown 文件中的链接
  - 验证链接有效性并生成报告
- 创建 `docs/verified_links.md` 已验证链接库
  - 收录 100% 确认有效的官方链接
  - 提供安全链接策略
  - 链接维护流程说明
- 创建 `docs/naming_convention.md` 命名规范文档
  - HarmonyOS 项目命名限制详解
  - 项目、模块、文件命名规则
  - 迁移指南和常见错误解决方案
- 生成 `docs/link_verification_report.md` 链接验证报告

#### Git 仓库
- 初始化 Git 仓库
- 创建 `main` 主分支
- 创建 `develop` 开发分支
- 推送到远程仓库 `git@github.com:mqxu/HarmonyOS_In_Action.git`

### 修改
- 修正所有文档中的失效链接
- 统一中英文混排格式（添加空格）
- 更新 GitHub 仓库地址为正确的格式（使用下划线）

### 项目进度
- API 覆盖率：0/388 (0%) OpenHarmony + 0/163 (0%) HMS + 0/120 (0%) UI 组件
- 案例完成度：0/204 (0%)
- 文档完成度：核心文档 100%（README、CODE_STYLE、CONTRIBUTING）

---

## 版本说明

### 版本号规则

采用语义化版本号 `X.Y.Z`：

- **主版本号（X）**：大规模重构或不兼容的 API 变更
- **次版本号（Y）**：新增功能或案例批次（向下兼容）
- **修订号（Z）**：Bug 修复或文档更新

### 版本里程碑规划

- **v0.1.0** - 项目基础设施（已完成）
- **v0.2.0** - 公共基础库和工具
- **v0.3.0** - 第一批基础案例（F001-F010）
- **v0.4.0** - 第一批 UI 组件案例（U001-U010）
- **v0.5.0** - 布局导航案例
- **v1.0.0** - 正式发布（完成 100 个核心案例）
- **v2.0.0** - 完整版（完成全部 200+ 案例）

---

## 变更类型说明

- **新增（Added）**：新功能、新案例
- **修改（Changed）**：现有功能的变更
- **废弃（Deprecated）**：即将移除的功能
- **移除（Removed）**：已移除的功能
- **修复（Fixed）**：Bug 修复
- **安全（Security）**：安全相关更新

---

## 贡献者

感谢所有为本项目做出贡献的开发者！

<!-- ALL-CONTRIBUTORS-LIST:START -->
- [@mqxu](https://github.com/mqxu) - 项目发起者和维护者
<!-- ALL-CONTRIBUTORS-LIST:END -->

---

## 链接

- [项目主页](https://github.com/mqxu/HarmonyOS_In_Action)
- [问题反馈](https://github.com/mqxu/HarmonyOS_In_Action/issues)
- [贡献指南](CONTRIBUTING.md)
- [代码规范](CODE_STYLE.md)

---

**最后更新**：2025-10-04
