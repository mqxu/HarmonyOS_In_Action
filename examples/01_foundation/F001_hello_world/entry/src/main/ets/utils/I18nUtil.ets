/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

import { i18n } from '@kit.LocalizationKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';

/**
 * 国际化工具类
 */
export class I18nUtil {
  /**
   * 切换系统语言
   * @param language 语言代码，如 'zh-CN' 或 'en-US'
   */
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

  /**
   * 获取当前系统语言
   * @returns 当前语言代码
   */
  static getSystemLanguage(): string {
    return i18n.System.getAppPreferredLanguage();
  }

  /**
   * 判断是否为中文环境
   */
  static isChineseLocale(): boolean {
    const language = I18nUtil.getSystemLanguage();
    return language.startsWith('zh');
  }
}
