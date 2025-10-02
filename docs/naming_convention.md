# 鸿蒙项目命名规范

## ⚠️ 重要提示

**鸿蒙项目命名有严格限制**，违反规则会导致项目无法创建或编译失败！

---

## 📌 核心规则

### ✅ 允许使用
- 大写字母 A-Z
- 小写字母 a-z
- 数字 0-9
- 下划线 _

### ❌ 禁止使用
- **连字符 -**（这是最常见的错误！）
- 空格
- 中文
- 其他特殊符号 (@, #, $, %, 等)

---

## 📁 项目命名示例

### 项目根目录命名

```
✅ 正确示例:
HarmonyOS_In_Action
MyHarmonyApp
hello_world
user_management_system
App2024

❌ 错误示例:
HarmonyOS-In-Action   ❌ 有连字符
my-harmony-app        ❌ 有连字符
hello world           ❌ 有空格
鸿蒙应用              ❌ 有中文
my@app                ❌ 有特殊符号
```

### 案例目录命名

```
✅ 正确示例:
examples/01_foundation/F001_hello_world/
examples/02_ui_components/U001_button_showcase/
examples/07_ai_capabilities/A001_face_detection/

❌ 错误示例:
examples/01-foundation/F001-hello-world/     ❌ 有连字符
examples/02_ui_components/U001 button/       ❌ 有空格
examples/07_AI能力/A001_人脸识别/            ❌ 有中文
```

---

## 📝 文件命名规范

### ETS/TS 文件（鸿蒙同样限制）

```
✅ 正确示例:
EntryAbility.ets
HomePage.ets
UserCard.ets
UserViewModel.ets
UserService.ts
dateUtil.ts
AppConstants.ets

❌ 错误示例:
Entry-Ability.ets     ❌ 有连字符
home-page.ets         ❌ 有连字符
user_service.ts       ⚠️ 可用但不推荐（应该用驼峰）
```

**推荐**: 使用 **PascalCase**（大驼峰）或 **camelCase**（小驼峰）

---

## 🗂️ 模块命名

### Module 名称（module.json5）

```json
{
  "module": {
    "name": "entry",          // ✅ 简单小写
    "name": "feature_user",   // ✅ 下划线分隔
    "name": "feature-user"    // ❌ 不能用连字符
  }
}
```

### Ability 名称

```typescript
// ✅ 正确
export default class EntryAbility extends UIAbility {  }
export default class UserAbility extends UIAbility {  }

// ❌ 错误（虽然语法上可以，但违反规范）
export default class Entry_Ability extends UIAbility {  }
```

---

## 📦 包名命名

### oh-package.json5

```json
{
  "name": "harmonyos_in_action",     // ✅ 全小写+下划线
  "name": "my_harmony_app",          // ✅
  "name": "harmonyos-in-action"      // ❌ 不能用连字符
}
```

### Bundle Name（应用包名）

```
✅ 正确:
com.example.myapp
com.company.harmonyos_demo

❌ 错误:
com.example.my-app        ❌ 有连字符
com.company.鸿蒙应用      ❌ 有中文
```

---

## 🎯 本项目的命名标准

### 项目主目录
```
HarmonyOS_In_Action/
```

### 案例编号格式
```
<分类前缀><编号>_<描述性名称>

示例:
F001_hello_world
F002_state_management
U001_button_showcase
U002_advanced_list
A001_face_detection
MP001_smart_memo_app
```

### 分类前缀
- `F` - Foundation（基础）
- `U` - UI Components（UI组件）
- `L` - Layout（布局）
- `D` - Data（数据）
- `N` - Network（网络）
- `M` - Multimedia（多媒体）
- `A` - AI（人工智能）
- `H` - Hardware（硬件）
- `DS` - Distributed（分布式）
- `S` - Security（安全）
- `P` - Performance（性能）
- `E` - Enterprise（企业）
- `MP` - MiniProject（小项目）

### 完整案例路径示例
```
HarmonyOS_In_Action/
└── examples/
    ├── 01_foundation/
    │   ├── F001_hello_world/
    │   ├── F002_state_management/
    │   └── F003_list_rendering/
    ├── 02_ui_components/
    │   ├── U001_button_showcase/
    │   ├── U002_advanced_list/
    │   └── U003_image_handling/
    └── 07_ai_capabilities/
        ├── A001_face_detection/
        └── A002_ocr_recognition/
```

---

## 🔧 实际开发中的注意事项

### DevEco Studio 创建项目

当使用 DevEco Studio 创建项目时:
1. **Project name**: 只能用字母、数字、下划线
2. **Bundle name**: 遵循域名倒序（com.xxx.yyy）
3. **Module name**: 使用小写字母和下划线

### Hvigor 构建

hvigorfile.ts 中的模块名也必须遵守规则:
```typescript
// ✅ 正确
export default {
  system: appTasks,
  modules: [
    {
      name: 'entry',
      srcPath: './entry',
    },
    {
      name: 'feature_user',   // ✅ 下划线
      srcPath: './feature_user',
    }
  ],
}

// ❌ 错误
{
  name: 'feature-user',  // ❌ 连字符会导致构建失败
  srcPath: './feature-user',
}
```

---

## ✅ 迁移指南

如果你已经使用了连字符命名,需要重命名:

### 方法1: 手动重命名
```bash
# 重命名目录
mv my-app my_app
mv F001-hello-world F001_hello_world

# 更新所有引用（module.json5, hvigorfile.ts 等）
```

### 方法2: 批量重命名脚本
```bash
# 将所有 - 替换为 _
find . -depth -name "*-*" -execdir bash -c '
  for file do
    newname="${file//-/_}"
    if [ "$file" != "$newname" ]; then
      mv -n "$file" "$newname"
    fi
  done
' bash {} +
```

---

## 📋 检查清单

在创建项目或案例前，请确认:

- [ ] 项目名称只包含字母、数字、下划线
- [ ] 没有使用连字符 `-`
- [ ] 没有使用空格
- [ ] 没有使用中文
- [ ] 没有使用特殊符号
- [ ] Bundle name 符合规范
- [ ] Module name 符合规范
- [ ] 所有文件名符合规范

---

## 🆘 常见错误和解决方案

### 错误1: 创建项目时提示"Invalid project name"
**原因**: 项目名称包含非法字符（通常是连字符）
**解决**: 改用下划线或驼峰命名

### 错误2: Hvigor 构建失败 "Module not found"
**原因**: module name 使用了连字符
**解决**: 重命名模块并更新所有引用

### 错误3: OHPM 安装失败
**原因**: package name 不符合规范
**解决**: 修改 oh-package.json5 中的 name 字段

---

## 📚 参考资料

- [HarmonyOS 应用开发命名规范](https://developer.huawei.com/consumer/cn/doc/)
- [ArkTS 编码规范](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-style-guide-V5)
- [DevEco Studio 项目配置](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-project-structure-V5)

---

**最后更新**: 2025-10-02
**重要性**: ⭐⭐⭐⭐⭐（必须遵守）
