// import 'dart:convert';
// import 'book.dart';

// class TopRated {
//   final List<Book> books;

//   TopRated({required this.books});

//   TopRated copyWith({List<Book>? books}) =>
//       TopRated(books: books ?? this.books);

//   factory TopRated.fromRawJson(String str) => TopRated.fromJson(json.decode(str));

//   String toRawJson() => json.encode(toJson());

//   factory TopRated.fromJson(Map<String, dynamic> json) => TopRated(
//         books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "books": List<dynamic>.from(books.map((x) => x.toJson())),
//       };
// }


import 'package:bookhub_fullstack/models/book.dart';

class TopRated {
  final List<Book> books;

  TopRated({required this.books});

  factory TopRated.fromJson(List<dynamic> json) => TopRated(
        books: json.map((e) => Book.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'books': books.map((e) => e.toJson()).toList(),
      };
}