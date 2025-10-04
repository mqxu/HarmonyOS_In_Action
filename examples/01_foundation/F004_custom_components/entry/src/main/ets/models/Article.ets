/**
 * 文章数据模型
 */
export class Article {
  id: number;
  title: string;
  author: string;
  coverImage: string;
  summary: string;
  tags: string[];
  likes: number;
  comments: number;

  constructor(
    id: number,
    title: string,
    author: string,
    coverImage: string,
    summary: string,
    tags: string[],
    likes: number,
    comments: number
  ) {
    this.id = id;
    this.title = title;
    this.author = author;
    this.coverImage = coverImage;
    this.summary = summary;
    this.tags = tags;
    this.likes = likes;
    this.comments = comments;
  }
}
