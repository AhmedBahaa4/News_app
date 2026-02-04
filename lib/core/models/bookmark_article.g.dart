// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookmarkArticleAdapter extends TypeAdapter<BookmarkArticle> {
  @override
  final int typeId = 4;

  @override
  BookmarkArticle read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookmarkArticle(
      url: fields[0] as String,
      title: fields[1] as String,
      image: fields[2] as String,
      source: fields[3] as String,
      publishedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookmarkArticle obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.source)
      ..writeByte(4)
      ..write(obj.publishedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
