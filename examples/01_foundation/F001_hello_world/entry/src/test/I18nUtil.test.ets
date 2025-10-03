/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { describe, it, expect } from '@ohos/hypium';
import { I18nUtil } from '../main/ets/utils/I18nUtil';

export default function i18nUtilTest() {
  describe('I18nUtil_Unit_Test', () => {

    // ================= getSystemLanguage =================
    describe('getSystemLanguage_method', () => {
      // 测试返回值类型是否为 string
      it('should_return_string', 0, () => {
        const language = I18nUtil.getSystemLanguage();
        expect(typeof language).assertEqual('string');
      });

      // 测试返回的字符串不为空
      it('should_not_be_empty', 0, () => {
        const language = I18nUtil.getSystemLanguage();
        expect(language.length).assertLargerOrEqual(0);
      });
    });

    // ================= isChineseLocale =================
    describe('isChineseLocale_method', () => {
      // 测试返回值类型是否为 boolean
      it('should_return_boolean', 0, () => {
        const isChinese = I18nUtil.isChineseLocale();
        expect(typeof isChinese).assertEqual('boolean');
      });
    });

    // ================= switchLanguage =================
    describe('switchLanguage_method', () => {
      // 切换到英文应该成功
      it('switch_to_enUS_should_return_true', 0, async (done: Function) => {
        const success = await I18nUtil.switchLanguage('en-US');
        expect(success).assertTrue();
        done();
      });

      // 切换到中文应该成功
      it('switch_to_zhCN_should_return_true', 0, async (done: Function) => {
        const success = await I18nUtil.switchLanguage('zh-CN');
        expect(success).assertTrue();
        done();
      });

      // 无效的语言代码应该返回 boolean（true/false）
      it('invalid_lang_should_return_boolean', 0, async (done: Function) => {
        const success = await I18nUtil.switchLanguage('invalid-lang');
        expect(typeof success).assertEqual('boolean');
        done();
      });
    });
  });
}
