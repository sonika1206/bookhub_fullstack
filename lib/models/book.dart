// import 'dart:convert';

// class Book {
//   final String id;
//   final String title;
//   final String authorName;
//   final String coverPic;
//   final String? rating;
//   final String? bookshelf;
//   final String? readStatus;

//   Book({
//     required this.id,
//     required this.title,
//     required this.authorName,
//     required this.coverPic,
//     this.rating,
//     this.bookshelf,
//     this.readStatus,
//   });

//   Book copyWith({
//     String? id,
//     String? title,
//     String? authorName,
//     String? coverPic,
//     String? rating,
//     String? bookshelf,
//     String? readStatus,
//   }) =>
//       Book(
//         id: id ?? this.id,
//         title: title ?? this.title,
//         authorName: authorName ?? this.authorName,
//         coverPic: coverPic ?? this.coverPic,
//         rating: rating ?? this.rating,
//         bookshelf: bookshelf ?? this.bookshelf,
//         readStatus: readStatus ?? this.readStatus,
//       );

//   factory Book.fromRawJson(String str) => Book.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory Book.fromJson(Map<String, dynamic> json) => Book(
//         id: json["id"].toString(),
//         title: json["title"],
//         authorName: json["author_name"],
//         coverPic: json["cover_pic"],
//         rating: json["rating"]?.toString(),
//         bookshelf: json["bookshelf"],
//         readStatus: json["read_status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "title": title,
//         "author_name": authorName,
//         "cover_pic": coverPic,
//         "rating": rating,
//         "bookshelf": bookshelf,
//         "read_status": readStatus,
//       };
// }

class Book {
  final String id;
  final String title;
  final String authorName;
  final String? coverPic;
  final double? rating;
  final String? aboutBook;
  final String? aboutAuthor;
  final DateTime createdAt;
  final DateTime updatedAt;

  Book({
    required this.id,
    required this.title,
    required this.authorName,
    this.coverPic,
    this.rating,
    this.aboutBook,
    this.aboutAuthor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'],
        title: json['title'],
        authorName: json['author_name'],
        coverPic: json['cover_pic'],
        rating: (json['rating'] as num?)?.toDouble(),
        aboutBook: json['about_book'],
        aboutAuthor: json['about_author'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'author_name': authorName,
        'cover_pic': coverPic,
        'rating': rating,
        'about_book': aboutBook,
        'about_author': aboutAuthor,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}