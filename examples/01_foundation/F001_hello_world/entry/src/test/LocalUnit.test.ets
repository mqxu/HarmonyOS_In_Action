/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { StringUtil } from '../../../main/ets/utils/StringUtil';

export default function localUnitTest() {
  describe('StringUtil 工具类测试', () => {
    // 所有测试用例开始前执行一次
    beforeAll(() => {
      console.info('开始 StringUtil 单元测试');
    });

    // 所有测试用例结束后执行一次
    afterAll(() => {
      console.info('StringUtil 单元测试完成');
    });

    // 测试 isEmpty 方法
    it('isEmpty 应该正确判断空字符串', 0, () => {
      expect(StringUtil.isEmpty('')).assertTrue();
      expect(StringUtil.isEmpty('   ')).assertTrue();
      expect(StringUtil.isEmpty(null)).assertTrue();
      expect(StringUtil.isEmpty(undefined)).assertTrue();
      expect(StringUtil.isEmpty('hello')).assertFalse();
    });

    // 测试 isNotEmpty 方法
    it('isNotEmpty 应该正确判断非空字符串', 0, () => {
      expect(StringUtil.isNotEmpty('hello')).assertTrue();
      expect(StringUtil.isNotEmpty('  hello  ')).assertTrue();
      expect(StringUtil.isNotEmpty('')).assertFalse();
      expect(StringUtil.isNotEmpty('   ')).assertFalse();
      expect(StringUtil.isNotEmpty(null)).assertFalse();
    });

    // 测试 formatMessage 方法
    it('formatMessage 应该正确格式化消息', 0, () => {
      expect(StringUtil.formatMessage('Hello', 0)).assertEqual('Hello');
      expect(StringUtil.formatMessage('Hello', 1)).assertEqual('Hello 1');
      expect(StringUtil.formatMessage('Hello', 10)).assertEqual('Hello 10');
      expect(StringUtil.formatMessage('HarmonyOS', 5)).assertEqual('HarmonyOS 5');
    });

    // 测试 truncate 方法
    it('truncate 应该正确截断字符串', 0, () => {
      expect(StringUtil.truncate('Hello', 10)).assertEqual('Hello');
      expect(StringUtil.truncate('Hello World', 5)).assertEqual('Hello...');
      expect(StringUtil.truncate('HarmonyOS', 6)).assertEqual('Harmon...');
      expect(StringUtil.truncate('', 5)).assertEqual('');
    });

    // 测试 capitalize 方法
    it('capitalize 应该正确转换首字母大写', 0, () => {
      expect(StringUtil.capitalize('hello')).assertEqual('Hello');
      expect(StringUtil.capitalize('harmonyOS')).assertEqual('HarmonyOS');
      expect(StringUtil.capitalize('HELLO')).assertEqual('HELLO');
      expect(StringUtil.capitalize('')).assertEqual('');
      expect(StringUtil.capitalize('h')).assertEqual('H');
    });

    // 综合测试
    it('综合场景测试', 0, () => {
      const message = 'hello harmonyos';
      const formatted = StringUtil.capitalize(message);
      expect(formatted).assertEqual('Hello harmonyos');

      const longMessage = 'This is a very long message that needs to be truncated';
      const truncated = StringUtil.truncate(longMessage, 20);
      expect(truncated).assertEqual('This is a very long ...');

      expect(StringUtil.isNotEmpty(formatted)).assertTrue();
    });
  });
}