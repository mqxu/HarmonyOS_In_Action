# 已验证有效链接库

> **最后验证时间**: 2025-10-02
> **验证方式**: 人工访问确认 + 自动化脚本验证
> **更新频率**: 建议每月验证一次

---

## ⚠️ 使用说明

1. **本文档只收录100%确认有效的链接**
2. **所有链接都经过实际访问验证**
3. **标注了验证日期，过期请重新验证**
4. **优先使用一级域名，深层链接容易失效**

---

## 🔗 官方链接（已验证）

### 华为开发者联盟

| 分类 | 名称 | 链接 | 验证日期 | 说明 |
|------|------|------|---------|------|
| 🏠 首页 | HarmonyOS 开发者官网 | https://developer.huawei.com/consumer/cn/ | 2025-10-02 | ✅ 主页，长期稳定 |
| 🛠️ 工具 | DevEco Studio 下载 | https://developer.huawei.com/consumer/cn/deveco-studio/ | 2025-10-02 | ✅ IDE下载页 |
| 📚 文档 | 文档中心首页 | https://developer.huawei.com/consumer/cn/doc/ | 2025-10-02 | ✅ 文档入口 |
| 🌐 HMS | HMS Core 服务 | https://developer.huawei.com/consumer/cn/hms/ | 2025-10-02 | ✅ HMS 服务介绍 |
| 💬 社区 | 开发者论坛 | https://developer.huawei.com/consumer/cn/forum/ | 2025-10-02 | ✅ 技术交流论坛 |

### OpenHarmony 社区

| 分类 | 名称 | 链接 | 验证日期 | 说明 |
|------|------|------|---------|------|
| 📖 文档 | OpenHarmony 文档中心 | https://docs.openharmony.cn/pages/v5.1/zh-cn/release-notes/OpenHarmony-v5.1.0-release.md | 2025-10-02 | ✅ 开源鸿蒙文档（需要JS） |
| 📦 包管理 | OHPM 三方库中心 | https://ohpm.openharmony.cn/ | 2025-10-02 | ✅ 鸿蒙包管理（需要JS） |

---

## ⚠️ 注意：深层链接容易失效

以下链接虽然 curl 返回 200，但**实际访问可能失效或重定向**，请谨慎使用：

### 文档类（需要手动验证）

```
❓ https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-get-started-V5
❓ https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-style-guide-V5
❓ https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-hvigor-V5
❓ https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-project-structure-V5
```

**问题**: 华为官网可能会：
1. 重定向到登录页
2. 改变URL结构
3. 需要JavaScript才能正确显示

**建议**:
- 优先链接到文档中心首页：`https://developer.huawei.com/consumer/cn/doc/`
- 在文档中说明：「请在文档中心搜索"ArkTS 入门"等关键词」
- 或标注为：`文档链接待确认`

---

## ❌ 已确认失效的链接

| 原链接 | 失效原因 | 替代方案 |
|-------|---------|---------|
| `https://www.openatom.org/openharmony` | 404 页面不存在 | 暂无官方页面，删除此链接 |
| `https://github.com/mqxu/HarmonyOS-In-Action.git` | 仓库未创建 | 待仓库创建后更新 |

---

## ✅ 推荐的安全链接策略

### 策略1：只使用一级域名

```markdown
✅ 推荐
- [华为开发者官网](https://developer.huawei.com/consumer/cn/harmonyos/)
- [DevEco Studio](https://developer.huawei.com/consumer/cn/deveco-studio/)
- [文档中心](https://developer.huawei.com/consumer/cn/doc/)

❌ 避免（深层路径容易变化）
- [ArkTS 入门](https://developer.huawei.com/consumer/cn/doc/very/deep/path/that/might/change)
```

### 策略2：提供搜索关键词

```markdown
✅ 推荐
访问 [华为开发者文档中心](https://developer.huawei.com/consumer/cn/doc/)，
搜索「ArkTS 快速入门」查看最新文档。

❌ 避免
查看 [ArkTS 快速入门](https://可能失效的深层链接)
```

### 策略3：标注待确认

```markdown
✅ 推荐
- 官方文档：待补充（发布时更新）
- 示例代码：见 examples/ 目录

❌ 避免
- 官方文档：[这是我编造的链接](https://fake-url.com)
```

---

## 📋 文档编写规范

### 添加链接前的检查清单

- [ ] 在浏览器中实际访问链接
- [ ] 确认页面正确显示（不是404/登录页）
- [ ] 优先使用一级或二级域名
- [ ] 深层链接必须标注验证日期
- [ ] 不确定的链接标注「待确认」

### 链接格式规范

```markdown
<!-- ✅ 好的示例 -->
访问 [DevEco Studio 官网](https://developer.huawei.com/consumer/cn/deveco-studio/) 下载最新版本。
<!-- 验证日期: 2025-10-02 -->

<!-- ❌ 不好的示例 -->
点击 [这里](https://developer.huawei.com/consumer/cn/doc/some-deep-path-that-might-404) 查看文档。
```

---

## 🔄 链接维护流程

### 每月检查

1. 运行链接验证脚本
   ```bash
   ./scripts/verify_links.sh
   ```

2. 查看验证报告
   ```bash
   cat docs/link_verification_report.md
   ```

3. 修复失效链接
   - 删除或替换404链接
   - 更新重定向链接
   - 补充缺失链接

4. 更新验证日期
   - 修改本文档的「最后验证时间」
   - 更新各个链接的验证日期

---

## 📞 发现失效链接？

如果发现本文档中的链接失效：

1. 提交 Issue 报告
2. 在 PR 中修复
3. 更新验证日期

---

**维护者**: mqxu
**下次验证**: 2025-11-02
