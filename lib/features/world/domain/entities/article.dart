class Article {
  final Map<String, dynamic>? source;
  final String? title;
  final String? description;
  final String? image;
  final String? url;
  final String? publishedAt;
  final String? content;

  const Article({
    this.source,
    this.title,
    this.description,
    this.image,
    this.url,
    this.publishedAt,
    this.content,
  });

  factory Article.fromMap(Map<String, dynamic> map) {
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

    return Article(
      source: normalizeSource(map['source']),
      title: asString(map['title']),
      description: asString(map['description']),
      image: asString(map['urlToImage']) ?? asString(map['image']),
      url: asString(map['url']),
      publishedAt: asString(map['publishedAt']),
      content: asString(map['content']),
    );
  }
}
