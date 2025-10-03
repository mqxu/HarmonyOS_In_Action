/**
 * 状态管理工具类
 * 用于演示和辅助状态管理的各种场景
 */
export class StateManager {
  /**
   * 验证状态值是否有效
   * @param value 状态值
   * @returns 是否有效
   */
  static isValidState(value: number | string | boolean | null | undefined): boolean {
    return value !== null && value !== undefined;
  }

  /**
   * 格式化计数器显示文本
   * @param count 计数值
   * @returns 格式化后的文本
   */
  static formatCounter(count: number): string {
    if (count < 0) {
      return `计数: ${count} (负数)`;
    } else if (count === 0) {
      return `计数: ${count} (初始值)`;
    } else {
      return `计数: ${count}`;
    }
  }

  /**
   * 计算两个数字的和
   * @param a 第一个数字
   * @param b 第二个数字
   * @returns 两数之和
   */
  static add(a: number, b: number): number {
    return a + b;
  }

  /**
   * 计算两个数字的差
   * @param a 被减数
   * @param b 减数
   * @returns 两数之差
   */
  static subtract(a: number, b: number): number {
    return a - b;
  }

  /**
   * 重置计数器到指定值
   * @param currentValue 当前值
   * @param resetValue 重置值，默认为0
   * @returns 重置后的值
   */
  static reset(currentValue: number, resetValue: number = 0): number {
    return resetValue;
  }

  /**
   * 验证输入文本是否有效
   * @param text 输入文本
   * @returns 是否有效
   */
  static isValidInput(text: string): boolean {
    return text !== null && text !== undefined && text.trim().length > 0;
  }

  /**
   * 同步状态值（用于 @Link 场景）
   * @param sourceValue 源值
   * @param targetValue 目标值
   * @returns 同步后的值
   */
  static syncValue<T>(sourceValue: T, targetValue: T): T {
    return sourceValue;
  }

  /**
   * 检查计数是否达到阈值
   * @param count 当前计数
   * @param threshold 阈值
   * @returns 是否达到阈值
   */
  static reachedThreshold(count: number, threshold: number): boolean {
    return count >= threshold;
  }

  /**
   * 格式化百分比显示
   * @param value 当前值
   * @param max 最大值
   * @returns 百分比字符串
   */
  static formatPercentage(value: number, max: number): string {
    if (max === 0) {
      return '0%';
    }
    const percentage = Math.round((value / max) * 100);
    return `${percentage}%`;
  }

  /**
   * 切换布尔值状态
   * @param current 当前布尔值
   * @returns 切换后的布尔值
   */
  static toggleBoolean(current: boolean): boolean {
    return !current;
  }

  /**
   * 验证数字是否在指定范围内
   * @param value 要验证的值
   * @param min 最小值
   * @param max 最大值
   * @returns 是否在范围内
   */
  static isInRange(value: number, min: number, max: number): boolean {
    return value >= min && value <= max;
  }

  /**
   * 限制数字在指定范围内
   * @param value 要限制的值
   * @param min 最小值
   * @param max 最大值
   * @returns 限制后的值
   */
  static clamp(value: number, min: number, max: number): number {
    return Math.min(Math.max(value, min), max);
  }
}
