/*
 * Copyright (c) 2025 mqxu
 * Licensed under the MIT License.
 * See LICENSE file in the project root for full license information.
 */

/**
 * 字符串工具类
 */
export class StringUtil {
  /**
   * 判断字符串是否为空
   * @param str 待检查的字符串
   * @returns 如果为空返回 true，否则返回 false
   */
  static isEmpty(str: string | null | undefined): boolean {
    return str === null || str === undefined || str.trim().length === 0;
  }

  /**
   * 判断字符串是否不为空
   * @param str 待检查的字符串
   * @returns 如果不为空返回 true，否则返回 false
   */
  static isNotEmpty(str: string | null | undefined): boolean {
    return !StringUtil.isEmpty(str);
  }

  /**
   * 格式化消息文本
   * @param template 模板字符串
   * @param count 计数值
   * @returns 格式化后的字符串
   */
  static formatMessage(template: string, count: number): string {
    if (count === 0) {
      return template;
    }
    return `${template} ${count}`;
  }

  /**
   * 截断字符串
   * @param str 原始字符串
   * @param maxLength 最大长度
   * @returns 截断后的字符串
   */
  static truncate(str: string, maxLength: number): string {
    if (str.length <= maxLength) {
      return str;
    }
    return str.substring(0, maxLength) + '...';
  }

  /**
   * 首字母大写
   * @param str 原始字符串
   * @returns 首字母大写后的字符串
   */
  static capitalize(str: string): string {
    if (StringUtil.isEmpty(str)) {
      return str;
    }
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
}
