# Mock 测试指南

## 📚 什么是 Mock 测试

Mock 测试是一种测试技术，通过创建"模拟对象"（Mock）来替代真实的依赖项，从而：
- **隔离被测试代码**: 不依赖外部系统（数据库、网络、系统 API 等）
- **提高测试稳定性**: 避免外部因素导致的测试失败
- **加快测试速度**: 不需要等待真实 API 响应
- **测试边界条件**: 可以模拟各种异常情况

## 🔧 HarmonyOS Mock 框架

HarmonyOS 使用 `@ohos/hamock` 框架进行 Mock 测试，它提供了两种 Mock 方式：

1. **配置文件 Mock**: 在 `mock-config.json5` 中声明
2. **代码 Mock**: 在测试代码中使用 MockKit API

---

## 方式一: 配置文件 Mock

### 1.1 配置 Mock 规则

在 `entry/src/mock/mock-config.json5` 中配置：

```json5
{
  // Mock resourceManager.getStringValue 方法
  "abilityContext": {
    "resourceManager": {
      "getStringValue": {
        "returnValue": "Mocked Hello HarmonyOS"
      }
    }
  },

  // Mock Preferences API
  "preferences": {
    "getPreferences": {
      "returnValue": {
        "__className": "MockPreferences",
        "get": {
          "clickCount": {
            "returnValue": 10
          },
          "isDarkMode": {
            "returnValue": true
          }
        },
        "put": {
          "returnValue": null
        },
        "flush": {
          "returnValue": null
        }
      }
    }
  },

  // Mock i18n API
  "i18n.System": {
    "getAppPreferredLanguage": {
      "returnValue": "zh-CN"
    },
    "setAppPreferredLanguage": {
      "returnValue": null
    }
  }
}
```

### 1.2 配置说明

#### 基本结构
```json5
{
  "API命名空间": {
    "方法名": {
      "returnValue": "模拟返回值"
    }
  }
}
```

#### 嵌套对象 Mock
```json5
{
  "abilityContext": {
    "resourceManager": {
      "getStringValue": {
        "returnValue": "Mocked String"
      }
    }
  }
}
```

#### 复杂对象 Mock
```json5
{
  "preferences": {
    "getPreferences": {
      "returnValue": {
        "__className": "MockPreferences",  // 对象类名
        "get": {
          "key1": { "returnValue": "value1" },
          "key2": { "returnValue": "value2" }
        }
      }
    }
  }
}
```

### 1.3 启用配置文件 Mock

在测试文件中启用 Mock：

```typescript
import { describe, it, expect, beforeAll, afterAll } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import { MockKit } from '@ohos/hamock';

export default function mockConfigTest() {
  describe('配置文件 Mock 测试', () => {
    beforeAll(async () => {
      // 启用 Mock 配置
      MockKit.enableMock();
    });

    afterAll(async () => {
      // 清除 Mock
      MockKit.clearMock();
    });

    it('测试 resourceManager Mock', 0, async (done: Function) => {
      // 测试代码
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text('Mocked Hello HarmonyOS'));
      done();
    });
  });
}
```

---

## 方式二: 代码 Mock (推荐)

### 2.1 MockKit 核心 API

```typescript
import { MockKit, when, verify, ArgumentMatchers } from '@ohos/hamock';

// 1. 创建 Mock 对象
let mockObj = MockKit.mockObject(TargetClass);

// 2. 设置 Mock 行为
when(mockObj.methodName)().thenReturn('mocked value');

// 3. 验证调用
verify(mockObj.methodName)().once();
```

### 2.2 完整测试示例

#### 示例 1: Mock resourceManager

```typescript
import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { MockKit, when } from '@ohos/hamock';
import { common } from '@kit.AbilityKit';

export default function resourceManagerMockTest() {
  describe('ResourceManager Mock 测试', () => {
    let mockContext: common.UIAbilityContext;
    let mockResourceManager: any;

    beforeEach(() => {
      // 创建 Mock Context
      mockContext = MockKit.mockObject(common.UIAbilityContext);

      // 创建 Mock ResourceManager
      mockResourceManager = {
        getStringValue: MockKit.mockFunc('getStringValue')
      };

      // 设置 Context 返回 Mock ResourceManager
      when(mockContext.resourceManager).thenReturn(mockResourceManager);

      // 设置 resourceManager.getStringValue 返回值
      when(mockResourceManager.getStringValue)(123)
        .thenReturn(Promise.resolve('Mocked Hello'));
    });

    it('应该返回 Mock 的字符串值', async () => {
      const result = await mockResourceManager.getStringValue(123);
      expect(result).assertEqual('Mocked Hello');
    });

    it('应该调用 getStringValue 一次', async () => {
      await mockResourceManager.getStringValue(123);
      verify(mockResourceManager.getStringValue)(123).once();
    });
  });
}
```

#### 示例 2: Mock Preferences

```typescript
import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { MockKit, when, verify } from '@ohos/hamock';
import { preferences } from '@kit.ArkData';

export default function preferencesMockTest() {
  describe('Preferences Mock 测试', () => {
    let mockPreferences: any;

    beforeEach(() => {
      // 创建 Mock Preferences 对象
      mockPreferences = {
        get: MockKit.mockFunc('get'),
        put: MockKit.mockFunc('put'),
        flush: MockKit.mockFunc('flush')
      };

      // 设置 Mock 行为
      when(mockPreferences.get)('clickCount', 0)
        .thenReturn(Promise.resolve(10));

      when(mockPreferences.get)('isDarkMode', false)
        .thenReturn(Promise.resolve(true));

      when(mockPreferences.put)('clickCount', 10)
        .thenReturn(Promise.resolve());

      when(mockPreferences.flush)()
        .thenReturn(Promise.resolve());
    });

    it('应该从 Preferences 加载数据', async () => {
      const clickCount = await mockPreferences.get('clickCount', 0);
      const isDarkMode = await mockPreferences.get('isDarkMode', false);

      expect(clickCount).assertEqual(10);
      expect(isDarkMode).assertTrue();
    });

    it('应该保存数据到 Preferences', async () => {
      await mockPreferences.put('clickCount', 10);
      await mockPreferences.flush();

      verify(mockPreferences.put)('clickCount', 10).once();
      verify(mockPreferences.flush)().once();
    });
  });
}
```

#### 示例 3: Mock i18n API

```typescript
import { describe, it, expect, beforeEach } from '@ohos/hypium';
import { MockKit, when, verify } from '@ohos/hamock';
import { i18n } from '@kit.LocalizationKit';

export default function i18nMockTest() {
  describe('I18n Mock 测试', () => {
    let mockI18nSystem: any;

    beforeEach(() => {
      // Mock i18n.System 对象
      mockI18nSystem = {
        getAppPreferredLanguage: MockKit.mockFunc('getAppPreferredLanguage'),
        setAppPreferredLanguage: MockKit.mockFunc('setAppPreferredLanguage')
      };

      // 设置 Mock 行为
      when(mockI18nSystem.getAppPreferredLanguage)()
        .thenReturn('zh-CN');

      when(mockI18nSystem.setAppPreferredLanguage)('en-US')
        .thenReturn(undefined);
    });

    it('应该获取当前语言', () => {
      const language = mockI18nSystem.getAppPreferredLanguage();
      expect(language).assertEqual('zh-CN');
    });

    it('应该切换语言', () => {
      mockI18nSystem.setAppPreferredLanguage('en-US');
      verify(mockI18nSystem.setAppPreferredLanguage)('en-US').once();
    });
  });
}
```

### 2.3 参数匹配器 (ArgumentMatchers)

当不关心具体参数值时，可以使用参数匹配器：

```typescript
import { ArgumentMatchers } from '@ohos/hamock';

// 任意值
when(mockObj.method)(ArgumentMatchers.any()).thenReturn('value');

// 任意字符串
when(mockObj.method)(ArgumentMatchers.anyString()).thenReturn('value');

// 任意数字
when(mockObj.method)(ArgumentMatchers.anyNumber()).thenReturn('value');

// 自定义匹配
when(mockObj.method)(ArgumentMatchers.argThat((arg) => arg > 0))
  .thenReturn('positive');
```

### 2.4 验证方法调用

```typescript
import { verify, VerificationMode } from '@ohos/hamock';

// 验证调用一次
verify(mockObj.method)('param').once();

// 验证从未调用
verify(mockObj.method)('param').never();

// 验证调用指定次数
verify(mockObj.method)('param').times(3);

// 验证至少调用一次
verify(mockObj.method)('param').atLeast(1);

// 验证最多调用三次
verify(mockObj.method)('param').atMost(3);
```

---

## 实战案例: 测试 StringUtil

### 3.1 被测试代码

`entry/src/main/ets/utils/StringUtil.ets`:
```typescript
export class StringUtil {
  static isEmpty(str: string | null | undefined): boolean {
    return str === null || str === undefined || str.trim().length === 0;
  }

  static isNotEmpty(str: string | null | undefined): boolean {
    return !StringUtil.isEmpty(str);
  }

  static formatMessage(template: string, count: number): string {
    return `${template} ${count}`;
  }

  static capitalize(str: string): string {
    if (StringUtil.isEmpty(str)) {
      return str;
    }
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
}
```

### 3.2 测试代码

`entry/src/test/StringUtil.test.ets`:
```typescript
import { describe, it, expect } from '@ohos/hypium';
import { StringUtil } from '../main/ets/utils/StringUtil';

export default function stringUtilTest() {
  describe('StringUtil 测试', () => {
    describe('isEmpty 方法', () => {
      it('空字符串应返回 true', () => {
        expect(StringUtil.isEmpty('')).assertTrue();
      });

      it('null 应返回 true', () => {
        expect(StringUtil.isEmpty(null)).assertTrue();
      });

      it('undefined 应返回 true', () => {
        expect(StringUtil.isEmpty(undefined)).assertTrue();
      });

      it('只包含空格的字符串应返回 true', () => {
        expect(StringUtil.isEmpty('   ')).assertTrue();
      });

      it('非空字符串应返回 false', () => {
        expect(StringUtil.isEmpty('hello')).assertFalse();
      });
    });

    describe('isNotEmpty 方法', () => {
      it('空字符串应返回 false', () => {
        expect(StringUtil.isNotEmpty('')).assertFalse();
      });

      it('非空字符串应返回 true', () => {
        expect(StringUtil.isNotEmpty('hello')).assertTrue();
      });
    });

    describe('formatMessage 方法', () => {
      it('应该正确格式化消息', () => {
        const result = StringUtil.formatMessage('Hello', 5);
        expect(result).assertEqual('Hello 5');
      });

      it('应该处理零值', () => {
        const result = StringUtil.formatMessage('Count', 0);
        expect(result).assertEqual('Count 0');
      });
    });

    describe('capitalize 方法', () => {
      it('应该首字母大写', () => {
        expect(StringUtil.capitalize('hello')).assertEqual('Hello');
      });

      it('已大写的字符串应保持不变', () => {
        expect(StringUtil.capitalize('Hello')).assertEqual('Hello');
      });

      it('空字符串应返回空字符串', () => {
        expect(StringUtil.capitalize('')).assertEqual('');
      });
    });
  });
}
```

---

## 实战案例: 测试 I18nUtil

### 4.1 被测试代码

`entry/src/main/ets/utils/I18nUtil.ets`:
```typescript
import { i18n } from '@kit.LocalizationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

export class I18nUtil {
  static async switchLanguage(language: string): Promise<boolean> {
    try {
      i18n.System.setAppPreferredLanguage(language);
      hilog.info(0x0000, 'I18nUtil', `语言已切换到: ${language}`);
      return true;
    } catch (err) {
      const error = err as BusinessError;
      hilog.error(0x0000, 'I18nUtil', `切换语言失败: ${error.message}`);
      return false;
    }
  }

  static getSystemLanguage(): string {
    return i18n.System.getAppPreferredLanguage();
  }

  static isChineseLocale(): boolean {
    const language = I18nUtil.getSystemLanguage();
    return language.startsWith('zh');
  }
}
```

### 4.2 Mock 测试代码

`entry/src/test/I18nUtil.test.ets`:
```typescript
import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import { MockKit, when, verify } from '@ohos/hamock';
import { I18nUtil } from '../main/ets/utils/I18nUtil';
import { i18n } from '@kit.LocalizationKit';

export default function i18nUtilMockTest() {
  describe('I18nUtil Mock 测试', () => {
    beforeEach(() => {
      // 启用 Mock
      MockKit.enableMock();

      // Mock i18n.System.getAppPreferredLanguage
      const mockGetLanguage = MockKit.mockFunc('i18n.System.getAppPreferredLanguage');
      when(mockGetLanguage)().thenReturn('zh-CN');
      i18n.System.getAppPreferredLanguage = mockGetLanguage;

      // Mock i18n.System.setAppPreferredLanguage
      const mockSetLanguage = MockKit.mockFunc('i18n.System.setAppPreferredLanguage');
      when(mockSetLanguage)('en-US').thenReturn(undefined);
      i18n.System.setAppPreferredLanguage = mockSetLanguage;
    });

    afterEach(() => {
      MockKit.clearMock();
    });

    it('应该获取系统语言', () => {
      const language = I18nUtil.getSystemLanguage();
      expect(language).assertEqual('zh-CN');
    });

    it('应该判断是否为中文环境', () => {
      const isChinese = I18nUtil.isChineseLocale();
      expect(isChinese).assertTrue();
    });

    it('应该切换语言', async () => {
      const success = await I18nUtil.switchLanguage('en-US');
      expect(success).assertTrue();
      verify(i18n.System.setAppPreferredLanguage)('en-US').once();
    });
  });
}
```

---

## 运行测试

### 方式一: 使用 DevEco Studio

1. 打开测试文件
2. 右键点击测试方法/类
3. 选择 "Run" 或 "Debug"

### 方式二: 命令行

```bash
# 运行所有测试
hvigorw test

# 运行指定测试文件
hvigorw test --tests "stringUtilTest"

# 生成覆盖率报告
hvigorw test --coverage
```

### 查看测试报告

测试报告位于:
```
entry/build/test-results/
entry/build/reports/tests/
```

---

## Mock 测试最佳实践

### ✅ 推荐做法

1. **使用代码 Mock 而非配置文件**
   ```typescript
   // ✅ 推荐: 清晰、灵活
   when(mockObj.method)('param').thenReturn('value');

   // ❌ 不推荐: 配置文件难以维护
   // mock-config.json5 中配置
   ```

2. **每个测试用例独立 Mock**
   ```typescript
   beforeEach(() => {
     mockObj = MockKit.mockObject(TargetClass);
   });
   ```

3. **清理 Mock 状态**
   ```typescript
   afterEach(() => {
     MockKit.clearMock();
   });
   ```

4. **验证关键调用**
   ```typescript
   verify(mockObj.importantMethod)('param').once();
   ```

5. **使用描述性测试名称**
   ```typescript
   it('当输入为空字符串时应返回 true', () => {
     // ...
   });
   ```

### ❌ 避免的做法

1. **过度 Mock**
   - 不要 Mock 简单的值对象
   - 不要 Mock 被测试的类本身

2. **忘记清理 Mock**
   ```typescript
   // ❌ 忘记清理会影响其他测试
   afterEach(() => {
     // 应该清理 Mock
   });
   ```

3. **测试实现细节**
   ```typescript
   // ❌ 不要测试内部实现
   verify(mockObj.privateMethod)().once();

   // ✅ 测试公共接口
   verify(mockObj.publicMethod)().once();
   ```

---

## 常见问题

### Q1: Mock 对象返回 undefined 怎么办？

**A**: 确保正确设置了返回值：
```typescript
when(mockObj.method)('param').thenReturn('expected value');
```

### Q2: 如何 Mock 异步方法？

**A**: 使用 Promise:
```typescript
when(mockObj.asyncMethod)()
  .thenReturn(Promise.resolve('value'));
```

### Q3: 如何 Mock 抛出异常？

**A**: 使用 `thenThrow`:
```typescript
when(mockObj.method)()
  .thenThrow(new Error('Mocked error'));
```

### Q4: 参数不匹配怎么办？

**A**: 使用参数匹配器：
```typescript
import { ArgumentMatchers } from '@ohos/hamock';

when(mockObj.method)(ArgumentMatchers.any())
  .thenReturn('value');
```

---

## 总结

Mock 测试是保证代码质量的重要手段：

1. **隔离依赖**: 只测试当前代码逻辑
2. **提高效率**: 不依赖外部系统
3. **增强稳定性**: 避免外部因素干扰
4. **覆盖边界**: 轻松模拟各种场景

HarmonyOS 的 `@ohos/hamock` 框架提供了强大的 Mock 能力，合理使用可以大幅提升测试质量。

## 参考资料

- [@ohos/hamock 官方文档](https://ohpm.openharmony.cn/#/cn/detail/@ohos%2Fhamock)
- [HarmonyOS 测试框架指南](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/ide_test_framework)
- [单元测试最佳实践](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/test_best_practices)
