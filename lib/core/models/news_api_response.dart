// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:hive/hive.dart';

// part 'news_api_response.g.dart';



// @HiveType(typeId: 0)

// class NewsApiResponse {
//   final String status;
//   final int totalResults;
//   final List<Article>? articles;

//   const NewsApiResponse({
//     required this.status,
//     required this.totalResults,
//     this.articles,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'status': status,
//       'totalResults': totalResults,
//       'articles': articles?.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory NewsApiResponse.fromMap(Map<String, dynamic> map) {
//     return NewsApiResponse(
//       status: map['status'] as String,
//       totalResults: map['totalResults'] as int,
//       articles: map['articles'] != null
//           ? List<Article>.from(
//               (map['articles'] as List).map(
//                 (x) => Article.fromMap(x as Map<String, dynamic>),
//               ),
//             )
//           : null,
//     );
//   }
// }

// class Article {
//   final Source? source;
//   final String? author;
//   final String? title;
//   final String? description;
//   final String? url;
//   final String? urlToImage;
//   final String? publishedAt;
//   final String? content;

//   const Article({
//     this.source,
//     this.author,
//     this.title,
//     this.description,
//     this.url,
//     this.urlToImage,
//     this.publishedAt,
//     this.content,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'source': source?.toMap(),
//       'author': author,
//       'title': title,
//       'description': description,
//       'url': url,
//       'urlToImage': urlToImage,
//       'publishedAt': publishedAt,
//       'content': content,
//     };
//   }

//   factory Article.fromMap(Map<String, dynamic> map) {
//     return Article(
//       source: map['source'] != null
//           ? Source.fromMap(map['source'] as Map<String, dynamic>)
//           : null,
//       author: map['author'] != null ? map['author'] as String : null,
//       title: map['title'] != null ? map['title'] as String : null,
//       description: map['description'] != null
//           ? map['description'] as String
//           : null,
//       url: map['url'] != null ? map['url'] as String : null,
//       urlToImage: map['urlToImage'] != null
//           ? map['urlToImage'] as String
//           : null,
//       publishedAt: map['publishedAt'] != null
//           ? map['publishedAt'] as String
//           : null,
//       content: map['content'] != null ? map['content'] as String : null,
//     );
//   }
// }

// class Source {
//   final String? id;
//   final String? name;

//   const Source({this.id, this.name});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{'id': id, 'name': name};
//   }

//   factory Source.fromMap(Map<String, dynamic> map) {
//     return Source(
//       id: map['id'] != null ? map['id'] as String : null,
//       name: map['name'] != null ? map['name'] as String : null,
//     );
//   }
// }
import 'dart:convert';

import 'package:hive/hive.dart';

part 'news_api_response.g.dart';

@HiveType(typeId: 1)
class Article {
  @HiveField(0)
  final Source? source;
  @HiveField(1)
  final String? author;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? url;
  @HiveField(5)
  final String? urlToImage;
  @HiveField(6)
  final String? publishedAt;
  @HiveField(7)
  final String? content;

  const Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  // JSON conversion
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      source: map['source'] != null ? Source.fromMap(map['source'] as Map<String,dynamic>) : null,
      author: map['author'] != null ? map['author'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      url: map['url'] != null ? map['url'] as String : null,
      urlToImage: map['urlToImage'] != null ? map['urlToImage'] as String : null,
      publishedAt: map['publishedAt'] != null ? map['publishedAt'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'source': source?.toMap(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);
}

@HiveType(typeId: 2)
class Source {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;

  const Source({this.id, this.name});

  factory Source.fromMap(Map<String, dynamic> map) {
    return Source(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

// ======================
// NewsApiResponse
// ======================

@HiveType(typeId: 3) // لو حابب تخزنها في Hive
class NewsApiResponse {
  @HiveField(0)
  final String status;

  @HiveField(1)
  final int totalResults;

  @HiveField(2)
  final List<Article>? articles;

  const NewsApiResponse({
    required this.status,
    required this.totalResults,
    this.articles,
  });

  // JSON conversion
  factory NewsApiResponse.fromMap(Map<String, dynamic> map) {
    return NewsApiResponse(
      status: map['status'],
      totalResults: map['totalResults'],
      articles: map['articles'] != null
          ? List<Article>.from(map['articles'].map((x) => Article.fromMap(x)))
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles?.map((x) => x.toMap()).toList(),
    };
  }
}
