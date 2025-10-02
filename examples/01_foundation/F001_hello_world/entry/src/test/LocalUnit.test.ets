/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

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

    // ================= truncate =================
    describe('truncate_method', () => {
      // 字符串长度小于最大长度，应返回原字符串
      it('string_shorter_than_max_should_return_original', 0, () => {
        expect(StringUtil.truncate('hello', 10)).assertEqual('hello');
      });

      // 字符串长度等于最大长度，应返回原字符串
      it('string_equal_to_max_should_return_original', 0, () => {
        expect(StringUtil.truncate('hello', 5)).assertEqual('hello');
      });

      // 字符串长度大于最大长度，应截断并加省略号
      it('string_longer_than_max_should_truncate', 0, () => {
        expect(StringUtil.truncate('hello world', 5)).assertEqual('hello...');
      });

      // 空字符串应返回空字符串
      it('empty_string_should_return_empty', 0, () => {
        expect(StringUtil.truncate('', 5)).assertEqual('');
      });

      // 最大长度为0，应返回省略号
      it('max_length_zero_should_return_ellipsis', 0, () => {
        expect(StringUtil.truncate('hello', 0)).assertEqual('...');
      });

      // 最大长度为1
      it('max_length_one_should_return_first_char_with_ellipsis', 0, () => {
        expect(StringUtil.truncate('hello', 1)).assertEqual('h...');
      });

      // 中文字符串截断
      it('chinese_string_should_truncate_correctly', 0, () => {
        expect(StringUtil.truncate('你好世界欢迎来到鸿蒙', 4)).assertEqual('你好世界...');
      });

      // 混合字符串截断
      it('mixed_string_should_truncate_correctly', 0, () => {
        expect(StringUtil.truncate('hello你好world', 8)).assertEqual('hello你好wo...');
      });
    });
  });
}
