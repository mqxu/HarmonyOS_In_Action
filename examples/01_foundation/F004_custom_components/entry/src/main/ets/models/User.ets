/**
 * 用户数据模型
 */
export class User {
  id: number;
  name: string;
  avatar: string;
  role: string;
  description: string;

  constructor(id: number, name: string, avatar: string, role: string, description: string) {
    this.id = id;
    this.name = name;
    this.avatar = avatar;
    this.role = role;
    this.description = description;
  }
}
