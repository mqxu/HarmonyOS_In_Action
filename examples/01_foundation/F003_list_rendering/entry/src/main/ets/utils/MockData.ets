import { Contact, Message, MessageType, Product } from '../models/Contact';

/**
 * 商品类型定义
 */
interface ProductType {
  name: string;
  icon: string;
  colorKey: string;
}

/**
 * 模拟数据生成工具类
 */
export class MockData {
  /**
   * 生成联系人列表
   */
  static generateContacts(count: number): Contact[] {
    const contacts: Contact[] = [];
    const names = ['张三', '李四', '王五', '赵六', '陈七', '刘八', '杨九', '黄十'];
    const groups = ['家人', '朋友', '同事', '同学'];

    for (let i = 0; i < count; i++) {
      const name = names[i % names.length] + (i > 7 ? i : '');
      contacts.push(new Contact(
        `contact_${i}`,
        name,
        `138${String(10000000 + i).slice(-8)}`,
        `https://picsum.photos/100/100?random=${i}`,
        groups[i % groups.length],
        `${name.toLowerCase()}@example.com`
      ));
    }

    return contacts;
  }

  /**
   * 生成消息列表
   */
  static generateMessages(count: number): Message[] {
    const messages: Message[] = [];
    const titles = ['系统通知', '活动消息', '好友消息', '订单消息'];
    const contents = [
      '您有一条新的系统消息',
      '双十一活动即将开始',
      '您的好友给您发来了消息',
      '您的订单已发货'
    ];
    const types = [MessageType.SYSTEM, MessageType.NOTICE, MessageType.MESSAGE, MessageType.SYSTEM];

    for (let i = 0; i < count; i++) {
      const typeIndex = i % types.length;
      messages.push(new Message(
        `message_${i}`,
        titles[typeIndex],
        contents[typeIndex],
        `${10 + (i % 12)}:${String(i % 60).padStart(2, '0')}`,
        i % 3 === 0,
        types[typeIndex]
      ));
    }

    return messages;
  }

  /**
   * 生成商品列表
   */
  static generateProducts(count: number): Product[] {
    const products: Product[] = [];
    const productTypes: ProductType[] = [
      { name: '华为手机', icon: '📱', colorKey: 'brand_primary' },
      { name: '小米平板', icon: '💻', colorKey: 'brand_success' },
      { name: 'MacBook', icon: '⌨️', colorKey: 'brand_purple' },
      { name: 'iPad', icon: '📱', colorKey: 'brand_warning' },
      { name: '耳机', icon: '🎧', colorKey: 'brand_cyan' },
      { name: '音箱', icon: '🔊', colorKey: 'brand_magenta' },
      { name: '手表', icon: '⌚', colorKey: 'brand_blue' },
      { name: '充电宝', icon: '🔋', colorKey: 'brand_gold' }
    ];
    const descriptions = ['高性能', '超长续航', '轻薄便携', '大屏体验'];

    for (let i = 0; i < count; i++) {
      const typeIndex = i % productTypes.length;
      const productType: ProductType = productTypes[typeIndex];
      products.push(new Product(
        `product_${i}`,
        `${productType.name} ${i + 1}`,
        Math.floor(Math.random() * 10000) + 1000,
        productType.icon,
        descriptions[i % descriptions.length],
        Math.floor(Math.random() * 100) + 10,
        productType.colorKey
      ));
    }

    return products;
  }

  /**
   * 生成大量数据用于性能测试
   */
  static generateLargeDataset(count: number): LargeDataItem[] {
    const data: LargeDataItem[] = [];
    for (let i = 0; i < count; i++) {
      data.push({
        id: `item_${i}`,
        title: `标题 ${i + 1}`,
        subtitle: `这是第 ${i + 1} 条数据的副标题`,
        value: Math.floor(Math.random() * 1000),
        timestamp: Date.now() + i
      });
    }
    return data;
  }
}

/**
 * 大数据项接口
 */
export interface LargeDataItem {
  id: string;
  title: string;
  subtitle: string;
  value: number;
  timestamp: number;
}
