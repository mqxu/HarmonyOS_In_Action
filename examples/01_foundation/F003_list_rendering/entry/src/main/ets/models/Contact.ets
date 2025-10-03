/**
 * 联系人数据模型
 */
export class Contact {
  id: string;
  name: string;
  phone: string;
  avatar: string;
  email?: string;
  group: string;

  constructor(id: string, name: string, phone: string, avatar: string, group: string, email?: string) {
    this.id = id;
    this.name = name;
    this.phone = phone;
    this.avatar = avatar;
    this.group = group;
    this.email = email;
  }
}

/**
 * 消息数据模型
 */
export class Message {
  id: string;
  title: string;
  content: string;
  time: string;
  isRead: boolean;
  type: MessageType;

  constructor(id: string, title: string, content: string, time: string, isRead: boolean, type: MessageType) {
    this.id = id;
    this.title = title;
    this.content = content;
    this.time = time;
    this.isRead = isRead;
    this.type = type;
  }
}

/**
 * 消息类型枚举
 */
export enum MessageType {
  SYSTEM = 'system',
  NOTICE = 'notice',
  MESSAGE = 'message'
}

/**
 * 商品数据模型
 */
export class Product {
  id: string;
  name: string;
  price: number;
  image: string;  // 现在存储图标 emoji
  description: string;
  stock: number;
  color: string;  // 背景颜色

  constructor(id: string, name: string, price: number, image: string, description: string, stock: number, color: string) {
    this.id = id;
    this.name = name;
    this.price = price;
    this.image = image;
    this.description = description;
    this.stock = stock;
    this.color = color;
  }
}
