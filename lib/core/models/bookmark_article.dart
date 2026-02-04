// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:hive/hive.dart';

import 'news_api_response.dart';

part 'bookmark_article.g.dart';

@HiveType(typeId: 4)
class BookmarkArticle {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String source;

  @HiveField(4)
  final String? publishedAt;

  BookmarkArticle({
    required this.url,
    required this.title,
    required this.image,
    required this.source,
    this.publishedAt,
  });

  // factory BookmarkArticle.fromJson(Map<String, dynamic> json) {
  //   return BookmarkArticle(
  //     url: json['newsUrl'] ?? json['url'],
  //     title: json['title'] ?? '',
  //     image: json['image'] ?? json['urlToImage'] ?? '',
  //     source: json['source'] ?? '',
  //     publishedAt: json['publishedAt'],
  //   );
  // }

  factory BookmarkArticle.fromArticle(Article article) {
    return BookmarkArticle(
      url: article.url!,
      title: article.title ?? '',
      image: article.urlToImage ?? '',
      source: article.source?.name ?? '',
      publishedAt: article.publishedAt,
    );
  }

  Article toArticle() {
    return Article(
      url: url,
      title: title,
      urlToImage: image,
      publishedAt: publishedAt,
      source: Source(name: source),
    );
  }

 Map<String, dynamic> toMap() {
  return {
    'newsUrl': url,
    'title': title,
    'urlToImage': image,
    'source': source,
    'publishedAt': publishedAt,
  };
}


 factory BookmarkArticle.fromMap(Map<String, dynamic> map) {
  return BookmarkArticle(
    url: map['newsUrl'],
    title: map['title'] ?? '',
    image: map['image'] ?? '',
    source: map['source'] ?? '',
    publishedAt: map['publishedAt']?.toString(),
  );
}


  // String toJson() => json.encode(toMap());


}
