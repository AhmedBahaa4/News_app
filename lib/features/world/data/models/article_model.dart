import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    super.source,
    super.title,
    super.description,
    super.image,
    super.url,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromMap(Map<String, dynamic> json) {
    String? asString(dynamic value) {
      if (value is String) {
        return value;
      }
      if (value is Map) {
        for (final key
            in ['rendered', 'value', 'name', 'title', 'content', 'url', 'date']) {
          final v = value[key];
          if (v is String && v.isNotEmpty) {
            return v;
          }
        }
        return value.toString();
      }
      return value?.toString();
    }

    Map<String, dynamic>? normalizeSource(dynamic src) {
      if (src is String) {
        return {'name': src};
      }
      if (src is Map) {
        final name = asString(src['name']) ?? asString(src['title']);
        final id = asString(src['id']) ?? src['id']?.toString();
        return {
          if (id != null) 'id': id,
          if (name != null) 'name': name,
        };
      }
      return null;
    }

    return ArticleModel(
      source: normalizeSource(json['source']),
      title: asString(json['title']),
      description: asString(json['description']),
      image: asString(json['urlToImage']) ?? asString(json['image']),
      url: asString(json['url']),
      publishedAt: asString(json['publishedAt']),
      content: asString(json['content']),
    );
  }
}
