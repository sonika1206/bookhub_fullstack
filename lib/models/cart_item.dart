import 'package:bookhub_fullstack/models/book.dart';

class CartItem {
  final String bookId;
  final Book book;
  final int quantity;

  CartItem({required this.bookId, required this.book, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      bookId: json['book_id'],
      book: Book.fromJson(json['books']),
      quantity: json['quantity'],
    );
  }
}