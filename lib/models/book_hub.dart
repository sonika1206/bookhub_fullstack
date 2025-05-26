import 'package:bookhub_fullstack/models/book.dart';
class BookHub {
  final List<Book> books;
  final int total;

  BookHub({
    required this.books,
    int? total,
  }) : total = total ?? books.length;

  BookHub copyWith({
    List<Book>? books,
    int? total,
  }) =>
      BookHub(
        books: books ?? this.books,
        total: total ?? this.total,
      );

  factory BookHub.fromJson(List<dynamic> json) => BookHub(
        books: json.map((e) => Book.fromJson(e)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'books': books.map((e) => e.toJson()).toList(),
        'total': total,
      };
}