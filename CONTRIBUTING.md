# 贡献指南

感谢你对 **HarmonyOS_In_Action** 项目的关注！我们非常欢迎各种形式的贡献。

## 📋 目录

- [贡献方式](#-贡献方式)
- [开发环境准备](#-开发环境准备)
- [代码贡献流程](#-代码贡献流程)
- [案例开发规范](#-案例开发规范)
- [提交规范](#-提交规范)
- [Pull Request 指南](#-pull-request-指南)

---

## 🤝 贡献方式

你可以通过以下方式为项目做出贡献：

### 1. 代码贡献
- **新增案例**：开发新的鸿蒙应用案例
- **完善现有案例**：优化代码、补充注释、改进测试
- **修复 Bug**：修复已知问题
- **性能优化**：提升案例性能表现

### 2. 文档贡献
- **完善文档**：改进 README、添加教程
- **补充注释**：为代码添加详细注释

### 3. 问题反馈
- **报告 Bug**：提交 Issue 描述问题
- **功能建议**：提出新功能或改进建议

---

## 🛠 开发环境准备

### 前置要求

- **DevEco Studio** ≥ 5.0.0
- **HarmonyOS SDK** ≥ 6.0.0 (API 20)
- **Node.js** ≥ 18.x
- **Git** ≥ 2.30
- **OHPM** ≥ 5.x

### 环境配置

1. **安装 DevEco Studio**

   访问 [DevEco Studio 官网](https://developer.huawei.com/consumer/cn/deveco-studio/) 下载并安装

2. **Fork 和克隆仓库**

   ```bash
   # 1. 在 GitHub 上 Fork 本仓库
   # 2. 克隆你的 Fork 仓库
   git clone git@github.com:YOUR_USERNAME/HarmonyOS_In_Action.git
   cd HarmonyOS_In_Action

   # 3. 添加上游仓库
   git remote add upstream git@github.com:mqxu/HarmonyOS_In_Action.git

   # 4. 切换到 develop 分支
   git checkout develop
   ```

---

## 💻 代码贡献流程

### 1. 创建功能分支

```bash
# 确保在 develop 分支
git checkout develop

# 拉取最新代码
git pull upstream develop

# 创建功能分支（命名规范见下文）
git checkout -b feature/F020_timer_example
```

### 2. 开发你的功能

- 严格遵循 [CODE_STYLE.md](CODE_STYLE.md) 中的开发规范
- 确保代码通过 Lint 检查
- 编写完整的单元测试（覆盖率 ≥90%）
- 添加详细的代码注释

### 3. 提交代码

```bash
# 添加文件
git add .

# 提交（遵循提交规范）
git commit -m "feat(foundation): 新增 F020 计时器案例"
```

### 4. 推送并创建 Pull Request

```bash
# 推送到你的 Fork 仓库
git push origin feature/F020_timer_example

# 在 GitHub 上创建 Pull Request
```

---

## 📝 案例开发规范

### 代码质量要求

1. **命名规范**
   - 使用下划线命名：`F020_timer_example`
   - 禁止使用连字符：`F020-timer-example` ❌

2. **代码风格**
   - 严格遵循 [CODE_STYLE.md](CODE_STYLE.md)

3. **测试要求**
   - 单元测试覆盖率 ≥90%
   - 使用 Hypium 测试框架

---

## 📋 提交规范

### Commit Message 格式

采用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<类型>(<范围>): <简短描述>
```

### 类型（type）

- `feat`: 新功能、新案例
- `fix`: 修复 Bug
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建配置、依赖更新

### 示例

```bash
# 新增案例
git commit -m "feat(foundation): 新增 F020 计时器案例"

# 修复 Bug
git commit -m "fix(ui): 修复 Button 组件点击无响应问题"

# 更新文档
git commit -m "docs: 完善 CONTRIBUTING.md 贡献指南"
```

---

## 🔀 Pull Request 指南

### PR 标题格式

与 Commit Message 保持一致：

```
feat(foundation): 新增 F020 计时器案例
```

### PR 描述模板

```markdown
## 📝 变更说明

简要描述本次 PR 的内容

## 🎯 变更类型

- [ ] 新功能/新案例
- [ ] Bug 修复
- [ ] 文档更新
- [ ] 其他

## 📋 变更清单

- [ ] 新增 F020 计时器案例
- [ ] 添加完整测试（覆盖率 ≥90%）
- [ ] 更新案例索引文档

## ✅ 检查清单

- [ ] 代码遵循 [CODE_STYLE.md](CODE_STYLE.md) 规范
- [ ] 通过 `npm run lint` 检查
- [ ] 通过 `npm run test` 测试
```

---

## 🙏 致谢

感谢所有为项目做出贡献的开发者！

---

## 📞 联系我们

- **项目地址**: https://github.com/mqxu/HarmonyOS_In_Action
- **问题反馈**: https://github.com/mqxu/HarmonyOS_In_Action/issues

---

**最后更新**: 2025-10-02
**版本**: v1.0.0
