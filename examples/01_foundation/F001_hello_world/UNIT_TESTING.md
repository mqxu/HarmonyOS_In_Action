# 单元测试指南

## 📚 什么是单元测试

单元测试是软件测试的基础，针对程序中的最小可测试单元进行测试。在 HarmonyOS 开发中：
- **单元**: 通常是一个方法、函数或类
- **目的**: 验证每个单元是否按预期工作
- **特点**: 快速、独立、可重复

## 🔧 HarmonyOS 测试框架

HarmonyOS 使用 `@ohos/hypium` 作为官方测试框架，它提供：
- BDD 风格的测试 API（describe、it、expect）
- 丰富的断言方法
- 生命周期钩子（beforeAll、afterAll等）
- 异步测试支持

---

## 一、测试框架基础

### 1.1 核心 API

```typescript
import { describe, it, expect, beforeAll, afterAll, beforeEach, afterEach } from '@ohos/hypium';

describe('测试套件名称', () => {
  beforeAll(() => {
    // 所有测试前执行一次
  });

  afterAll(() => {
    // 所有测试后执行一次
  });

  beforeEach(() => {
    // 每个测试前执行
  });

  afterEach(() => {
    // 每个测试后执行
  });

  it('测试用例描述', () => {
    // 测试逻辑
    expect(actual).assertEqual(expected);
  });
});
```

### 1.2 断言方法

```typescript
// 相等性断言
expect(value).assertEqual(expected);        // 严格相等 ===
expect(value).assertDeepEquals(expected);   // 深度相等

// 布尔断言
expect(value).assertTrue();
expect(value).assertFalse();

// Null/Undefined 断言
expect(value).assertNull();
expect(value).assertUndefined();

// 数值比较
expect(value).assertLarger(target);         // value > target
expect(value).assertLargerOrEqual(target);  // value >= target
expect(value).assertLess(target);           // value < target
expect(value).assertLessOrEqual(target);    // value <= target

// 包含关系
expect(array).assertContain(element);

// 类型检查
expect(value).assertInstanceOf(Class);

// Promise 断言
expect(promise).assertPromiseIsResolved();
expect(promise).assertPromiseIsRejected();

// 异常断言
expect(() => { throw new Error(); }).assertThrowError();
```

---

## 二、项目中的测试示例

### 2.1 Hypium 单元测试命名规范

#### 命名规则（describe / it）

Hypium 要求：

- 只能使用 **字母 (a–z, A–Z)**、**数字 (0–9)**、**下划线 `_`**、**点号 `.`**
- 必须 **以字母开头**
- 不能有中文、空格或特殊字符

所以推荐的风格是：

1. `describe` 命名

- 格式：`<ClassName>_Unit_Test`
- 方法分组：`<methodName>_method`
- 例如：
  - `StringUtil_Unit_Test`
  - `isEmpty_method`
  - `capitalize_method`

2. `it` 命名

常用模式：`<输入条件>_should_<期望结果>`

- 清晰表达测试的输入和预期
- 一律英文小写，单词之间用 `_` 分隔

示例：

- `empty_string_should_return_true`
- `null_should_return_false`
- `whitespace_string_should_return_true`
- `non_empty_string_should_return_false`
- `lowercase_should_be_capitalized`
- `already_capitalized_should_stay_same`
- `string_starting_with_number_should_stay_same`

#### 推荐命名模式表

| 场景         | 命名模式                           | 示例                                     |
| ------------ | ---------------------------------- | ---------------------------------------- |
| 普通方法测试 | `<case>_should_<expected>`         | `null_should_return_true`                |
| 边界值测试   | `<boundaryCase>_should_<expected>` | `empty_string_should_return_true`        |
| 异常输入     | `<invalidInput>_should_<expected>` | `invalid_lang_should_return_boolean`     |
| 正常输入     | `<validInput>_should_<expected>`   | `hello_should_return_false`              |
| 特殊情况     | `<specialCase>_should_<expected>`  | `string_with_spaces_should_return_false` |
| 状态保持     | `<input>_should_stay_same`         | `already_capitalized_should_stay_same`   |

#### 示例对照（StringUtil）

```typescript
describe('StringUtil_Unit_Test', () => {
  describe('isEmpty_method', () => {
    it('empty_string_should_return_true', 0, () => { ... })
    it('null_should_return_true', 0, () => { ... })
    it('undefined_should_return_true', 0, () => { ... })
    it('whitespace_string_should_return_true', 0, () => { ... })
    it('non_empty_string_should_return_false', 0, () => { ... })
    it('string_with_spaces_should_return_false', 0, () => { ... })
  });
});
```

> 总结：
>
> - `describe`：类名/方法名 + `_Unit_Test` 或 `_method`
> - `it`：`<输入>_should_<输出>`，必要时 `_stay_same`

### 2.2 测试 StringUtil

测试代码：`entry/src/test/LocalUnit.test.ets`

```typescript
import { describe, it, expect } from '@ohos/hypium';
import { StringUtil } from '../main/ets/utils/StringUtil';

export default function stringUtilTest() {
  describe('StringUtil_Unit_Test', () => {

    // ================= isEmpty =================
    describe('isEmpty_method', () => {
      // 空字符串应返回 true
      it('empty_string_should_return_true', 0, () => {
        expect(StringUtil.isEmpty('')).assertTrue();
      });

      // null 应返回 true
      it('null_should_return_true', 0, () => {
        expect(StringUtil.isEmpty(null)).assertTrue();
      });

      // undefined 应返回 true
      it('undefined_should_return_true', 0, () => {
        expect(StringUtil.isEmpty(undefined)).assertTrue();
      });

      // 只包含空格的字符串应返回 true
      it('whitespace_string_should_return_true', 0, () => {
        expect(StringUtil.isEmpty('   ')).assertTrue();
      });

      // 非空字符串应返回 false
      it('non_empty_string_should_return_false', 0, () => {
        expect(StringUtil.isEmpty('hello')).assertFalse();
      });

      // 包含前后空格的非空字符串应返回 false
      it('trimmed_string_should_return_false', 0, () => {
        expect(StringUtil.isEmpty('  hello  ')).assertFalse();
      });
    });

    // ================= isNotEmpty =================
    describe('isNotEmpty_method', () => {
      it('empty_string_should_return_false', 0, () => {
        expect(StringUtil.isNotEmpty('')).assertFalse();
      });

      it('null_should_return_false', 0, () => {
        expect(StringUtil.isNotEmpty(null)).assertFalse();
      });

      it('non_empty_string_should_return_true', 0, () => {
        expect(StringUtil.isNotEmpty('hello')).assertTrue();
      });
    });

    // ================= formatMessage =================
    describe('formatMessage_method', () => {
      it('should_format_message_with_count', 0, () => {
        const result = StringUtil.formatMessage('Hello', 5);
        expect(result).assertEqual('Hello 5');
      });

      it('should_handle_zero_value', 0, () => {
        const result = StringUtil.formatMessage('Count', 0);
        expect(result).assertEqual('Count');
      });

      it('should_handle_negative_value', 0, () => {
        const result = StringUtil.formatMessage('Value', -10);
        expect(result).assertEqual('Value -10');
      });

      it('should_handle_large_value', 0, () => {
        const result = StringUtil.formatMessage('Total', 1000000);
        expect(result).assertEqual('Total 1000000');
      });
    });

    // ================= capitalize =================
    describe('capitalize_method', () => {
      it('lowercase_should_be_capitalized', 0, () => {
        expect(StringUtil.capitalize('hello')).assertEqual('Hello');
      });

      it('already_capitalized_should_stay_same', 0, () => {
        expect(StringUtil.capitalize('Hello')).assertEqual('Hello');
      });

      it('empty_string_should_return_empty', 0, () => {
        expect(StringUtil.capitalize('')).assertEqual('');
      });

      it('single_char_should_be_capitalized', 0, () => {
        expect(StringUtil.capitalize('a')).assertEqual('A');
      });

      it('all_uppercase_should_keep_uppercase', 0, () => {
        expect(StringUtil.capitalize('HELLO')).assertEqual('HELLO');
      });

      it('string_starting_with_number_should_stay_same', 0, () => {
        expect(StringUtil.capitalize('123abc')).assertEqual('123abc');
      });
    });
  });
}

```

### 2.3 测试 I18nUtil

`entry/src/test/I18nUtil.test.ets`:
```typescript
import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { I18nUtil } from '../main/ets/utils/I18nUtil';

export default function i18nUtilTest() {
  describe('I18nUtil 单元测试', () => {
    describe('getSystemLanguage 方法', () => {
      it('应该返回字符串类型', () => {
        const language = I18nUtil.getSystemLanguage();
        expect(typeof language).assertEqual('string');
      });

      it('返回的语言代码应该不为空', () => {
        const language = I18nUtil.getSystemLanguage();
        expect(language.length).assertLarger(0);
      });
    });

    describe('isChineseLocale 方法', () => {
      it('应该返回布尔值', () => {
        const isChinese = I18nUtil.isChineseLocale();
        expect(typeof isChinese).assertEqual('boolean');
      });
    });

    describe('switchLanguage 方法', () => {
      it('切换到英文应该返回 true', async () => {
        const success = await I18nUtil.switchLanguage('en-US');
        expect(success).assertTrue();
      });

      it('切换到中文应该返回 true', async () => {
        const success = await I18nUtil.switchLanguage('zh-CN');
        expect(success).assertTrue();
      });

      it('无效的语言代码应该处理异常', async () => {
        // 即使是无效代码，也应该有返回值
        const success = await I18nUtil.switchLanguage('invalid-lang');
        expect(typeof success).assertEqual('boolean');
      });
    });
  });
}
```

---

## 三、测试组织结构

### 3.1 测试目录结构

```
entry/src/
├── main/
│   └── ets/
│       ├── pages/
│       │   └── Index.ets
│       └── utils/
│           ├── StringUtil.ets
│           └── I18nUtil.ets
├── test/                      # 本地单元测试
│   ├── List.test.ets          # 测试列表
│   ├── LocalUnit.test.ets     # StringUtil 测试
│   └── I18nUtil.test.ets      # I18nUtil 测试
└── ohosTest/                  # 设备测试
    ├── ets/
    │   └── test/
    │       ├── Ability.test.ets
    │       └── List.test.ets
    └── module.json5
```

### 3.2 测试列表配置

`entry/src/test/List.test.ets`:
```typescript
import stringUtilTest from './LocalUnit.test';
import i18nUtilTest from './I18nUtil.test';

export default function testsuite() {
  stringUtilTest();
  i18nUtilTest();
}
```

---

## 四、不同类型的测试

### 4.1 同步测试

```typescript
describe('同步测试示例', () => {
  it('简单计算测试', () => {
    const result = 1 + 1;
    expect(result).assertEqual(2);
  });

  it('字符串操作测试', () => {
    const str = 'Hello'.toUpperCase();
    expect(str).assertEqual('HELLO');
  });
});
```

### 4.2 异步测试

#### 方式一: 使用 async/await
```typescript
describe('异步测试示例', () => {
  it('Promise 测试', async () => {
    const result = await Promise.resolve('success');
    expect(result).assertEqual('success');
  });

  it('延迟操作测试', async () => {
    const promise = new Promise((resolve) => {
      setTimeout(() => resolve('done'), 100);
    });
    const result = await promise;
    expect(result).assertEqual('done');
  });
});
```

#### 方式二: 使用 done 回调
```typescript
describe('异步回调测试', () => {
  it('超时测试', 0, (done: Function) => {
    setTimeout(() => {
      expect(true).assertTrue();
      done();  // 必须调用 done() 表示测试完成
    }, 100);
  });
});
```

### 4.3 异常测试

```typescript
describe('异常处理测试', () => {
  it('应该抛出错误', () => {
    expect(() => {
      throw new Error('Test error');
    }).assertThrowError();
  });

  it('特定错误类型测试', () => {
    class CustomError extends Error {}

    expect(() => {
      throw new CustomError('Custom error');
    }).assertThrowError();
  });
});
```

### 4.4 数组和对象测试

```typescript
describe('复杂数据类型测试', () => {
  it('数组包含测试', () => {
    const arr = [1, 2, 3, 4, 5];
    expect(arr).assertContain(3);
  });

  it('对象深度相等测试', () => {
    const obj1 = { name: 'Alice', age: 20 };
    const obj2 = { name: 'Alice', age: 20 };
    expect(obj1).assertDeepEquals(obj2);
  });

  it('数组长度测试', () => {
    const arr = [1, 2, 3];
    expect(arr.length).assertEqual(3);
  });
});
```

---

## 五、测试生命周期

### 5.1 beforeAll 和 afterAll

```typescript
describe('生命周期示例', () => {
  let sharedResource: any;

  beforeAll(() => {
    // 在所有测试前执行一次（如：初始化数据库连接）
    sharedResource = createExpensiveResource();
    console.log('所有测试开始前');
  });

  afterAll(() => {
    // 在所有测试后执行一次（如：关闭数据库连接）
    cleanupResource(sharedResource);
    console.log('所有测试结束后');
  });

  it('测试 1', () => {
    expect(sharedResource).assertUndefined(false);
  });

  it('测试 2', () => {
    expect(sharedResource).assertUndefined(false);
  });
});
```

### 5.2 beforeEach 和 afterEach

```typescript
describe('每个测试的隔离', () => {
  let counter: number;

  beforeEach(() => {
    // 在每个测试前执行（确保每个测试独立）
    counter = 0;
    console.log('测试开始前，counter:', counter);
  });

  afterEach(() => {
    // 在每个测试后执行（清理测试状态）
    console.log('测试结束后，counter:', counter);
  });

  it('增加 counter', () => {
    counter++;
    expect(counter).assertEqual(1);
  });

  it('再次测试 counter（应该从 0 开始）', () => {
    expect(counter).assertEqual(0);  // 每个测试都重置了
    counter += 2;
    expect(counter).assertEqual(2);
  });
});
```

---

## 六、测试驱动开发 (TDD)

### 6.1 TDD 流程

1. **编写测试**（红灯）
2. **实现功能**（绿灯）
3. **重构代码**（优化）

### 6.2 TDD 示例

#### 步骤 1: 先写测试

```typescript
describe('计算器功能', () => {
  it('应该能够相加两个数字', () => {
    const result = Calculator.add(2, 3);
    expect(result).assertEqual(5);
  });

  it('应该能够相减两个数字', () => {
    const result = Calculator.subtract(5, 3);
    expect(result).assertEqual(2);
  });
});
```

#### 步骤 2: 实现功能

```typescript
export class Calculator {
  static add(a: number, b: number): number {
    return a + b;
  }

  static subtract(a: number, b: number): number {
    return a - b;
  }
}
```

#### 步骤 3: 运行测试，确保通过

```bash
hvigorw test
```

---

## 七、运行测试

### 7.1 使用 DevEco Studio

1. **运行单个测试**:
   - 右键点击测试方法
   - 选择 "Run 'testName'"

2. **运行测试套件**:
   - 右键点击 `describe` 块
   - 选择 "Run 'SuiteName'"

3. **运行所有测试**:
   - 右键点击测试文件
   - 选择 "Run 'FileName.test'"

### 7.2 使用命令行

```bash
# 运行所有测试
hvigorw test

# 运行指定测试
hvigorw test --tests "stringUtilTest"

# 生成覆盖率报告
hvigorw test --coverage

# 详细输出
hvigorw test --info

# 失败时停止
hvigorw test --fail-fast
```

### 7.3 查看测试结果

#### 控制台输出
```
> Task :entry:test

StringUtil 单元测试
  isEmpty 方法
    ✓ 空字符串应返回 true (5ms)
    ✓ null 应返回 true (2ms)
    ✓ 非空字符串应返回 false (1ms)

总计: 3 个测试, 3 个通过, 0 个失败

BUILD SUCCESSFUL
```

#### HTML 测试报告

报告位于:
```
entry/build/reports/tests/test/index.html
```

打开后可查看：
- 测试通过率
- 每个测试的执行时间
- 失败测试的详细信息
- 代码覆盖率

---

## 八、测试覆盖率

### 8.1 生成覆盖率报告

```bash
hvigorw test --coverage
```

### 8.2 覆盖率指标

- **行覆盖率** (Line Coverage): 被执行的代码行占总行数的比例
- **分支覆盖率** (Branch Coverage): 被执行的分支占总分支数的比例
- **函数覆盖率** (Function Coverage): 被调用的函数占总函数数的比例
- **语句覆盖率** (Statement Coverage): 被执行的语句占总语句数的比例

### 8.3 覆盖率报告

报告位于:
```
entry/.test/default/outputs/test/reports
```

示例:
```
File                    | % Stmts | % Branch | % Funcs | % Lines
------------------------|---------|----------|---------|--------
StringUtil.ets          |   100   |   100    |   100   |   100
I18nUtil.ets            |   85.7  |   75     |   100   |   85.7
------------------------|---------|----------|---------|--------
All files               |   92.8  |   87.5   |   100   |   92.8
```

---

## 九、测试最佳实践

### ✅ 推荐做法

1. **测试命名要描述性**
   ```typescript
   // ✅ 好: 清楚描述测试内容
   it('当输入为空字符串时应返回 true', () => {});
   
   // ❌ 差: 不清楚测试什么
   it('test1', () => {});
   ```

2. **遵循 AAA 模式**
   ```typescript
   it('测试描述', () => {
     // Arrange (准备): 设置测试数据
     const input = 'hello';
   
     // Act (执行): 调用被测试方法
     const result = StringUtil.capitalize(input);
   
     // Assert (断言): 验证结果
     expect(result).assertEqual('Hello');
   });
   ```

3. **一个测试只验证一个行为**
   ```typescript
   // ✅ 好: 每个测试专注一个场景
   it('空字符串应返回 true', () => {
     expect(StringUtil.isEmpty('')).assertTrue();
   });
   
   it('null 应返回 true', () => {
     expect(StringUtil.isEmpty(null)).assertTrue();
   });
   
   // ❌ 差: 一个测试验证多个场景
   it('isEmpty 测试', () => {
     expect(StringUtil.isEmpty('')).assertTrue();
     expect(StringUtil.isEmpty(null)).assertTrue();
     expect(StringUtil.isEmpty('hello')).assertFalse();
   });
   ```

4. **测试要独立**
   ```typescript
   // ✅ 好: 使用 beforeEach 确保每个测试独立
   describe('测试套件', () => {
     let counter: number;
   
     beforeEach(() => {
       counter = 0;  // 每个测试都重置
     });
   
     it('测试 1', () => {
       counter++;
       expect(counter).assertEqual(1);
     });
   
     it('测试 2', () => {
       expect(counter).assertEqual(0);  // 不受测试 1 影响
     });
   });
   ```

5. **测试边界条件**
   ```typescript
   describe('formatMessage 测试', () => {
     it('应该处理零值', () => {
       expect(StringUtil.formatMessage('Count', 0)).assertEqual('Count 0');
     });
   
     it('应该处理负数', () => {
       expect(StringUtil.formatMessage('Value', -10)).assertEqual('Value -10');
     });
   
     it('应该处理大数值', () => {
       expect(StringUtil.formatMessage('Total', 1000000)).assertEqual('Total 1000000');
     });
   });
   ```

### ❌ 避免的做法

1. **测试实现细节**
   ```typescript
   // ❌ 差: 测试内部实现
   it('应该调用 trim 方法', () => {
     // 不应该测试方法如何实现
   });
   
   // ✅ 好: 测试行为
   it('应该忽略前后空格判断为空', () => {
     expect(StringUtil.isEmpty('   ')).assertTrue();
   });
   ```

2. **测试依赖外部状态**
   ```typescript
   // ❌ 差: 依赖全局变量
   let globalCounter = 0;
   it('测试', () => {
     globalCounter++;
     expect(globalCounter).assertEqual(1);
   });
   
   // ✅ 好: 使用局部变量
   it('测试', () => {
     let localCounter = 0;
     localCounter++;
     expect(localCounter).assertEqual(1);
   });
   ```

3. **忽略异步错误**
   ```typescript
   // ❌ 差: 没有 await，测试可能提前结束
   it('异步测试', () => {
     asyncFunction();  // 忘记 await
   });
   
   // ✅ 好: 正确处理异步
   it('异步测试', async () => {
     await asyncFunction();
   });
   ```

---

## 十、常见问题

### Q1: 测试失败但代码看起来正确？

**A**: 检查以下几点：
1. 是否使用了正确的断言方法
2. 异步代码是否正确使用 async/await
3. 是否有测试间的状态污染

### Q2: 如何测试私有方法？

**A**: 不要直接测试私有方法，应该：
1. 通过公共方法间接测试私有方法
2. 如果私有方法很复杂，考虑提取为单独的工具函数

### Q3: 测试运行很慢怎么办？

**A**: 优化方法：
1. 避免在 `beforeAll/beforeEach` 中做耗时操作
2. 使用 Mock 替代真实的网络/数据库操作
3. 只运行相关的测试，不要每次都运行全部

### Q4: 如何提高代码覆盖率？

**A**:
1. 测试所有公共方法
2. 覆盖边界条件（null、空字符串、0、负数等）
3. 测试异常路径（try-catch 分支）
4. 查看覆盖率报告，找出未覆盖的代码

---

## 十一、总结

### 单元测试的价值

1. **提前发现 Bug**: 在开发阶段就能发现问题
2. **重构信心**: 有测试保护，放心重构代码
3. **文档作用**: 测试即文档，展示API如何使用
4. **设计改进**: 难以测试的代码往往设计不佳

### 测试金字塔

```
      /\
     /  \       E2E 测试 (少量)
    /____\
   /      \     集成测试 (适量)
  /________\
 /          \   单元测试 (大量)
/____________\
```

- **单元测试**: 70% - 快速、稳定、易维护
- **集成测试**: 20% - 测试模块间交互
- **E2E 测试**: 10% - 模拟真实用户场景

### 下一步

完成单元测试后，建议学习：
- **集成测试**: 测试多个模块协作
- **UI 测试**: 使用 @ohos.UiTest 进行UI自动化
- **性能测试**: 测试应用性能指标

## 参考资料

- [@ohos/hypium 官方文档](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fhypium)
- [HarmonyOS 测试指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide-test)
- [单元测试最佳实践](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ut)
