// ignore_for_file: public_member_api_docs, sort_constructors_first

class SearchBody {
  final String q;
  final int page;
  final int pageSize;

  const SearchBody({
    required this.q,
    this.page = 1,
    this.pageSize = 15,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'q': q,
      'page': page,
      'pageSize': pageSize,
    };
  }

  factory SearchBody.fromMap(Map<String, dynamic> map) {
    return SearchBody(
      q: map['q'] as String,

      page: map['page'] as int,
      pageSize: map['pageSize'] as int,
    );
  }


}
