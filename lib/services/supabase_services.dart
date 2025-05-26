
// import 'package:bookhub_fullstack/app_config.dart';
// import 'package:bookhub_fullstack/main.dart';
// import 'package:bookhub_fullstack/models/book.dart';
// import 'package:bookhub_fullstack/models/book_details.dart';
// import 'package:bookhub_fullstack/models/toprated_models.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class SupabaseService {
//   final SupabaseClient _client = AppConfig.client;

//   // Get all books with optional filtering
//   Future<BookHub> getBooks({String? bookshelf, String? searchText}) async {
//     try {
//       var query = _client.from('books').select('*');

//       // If user is authenticated and bookshelf filter is provided
//       if (bookshelf != null && bookshelf != 'ALL' && _client.auth.currentUser != null) {
//         // Join with user_books to filter by bookshelf
//         final userId = _client.auth.currentUser!.id;
//         query = _client
//             .from('books')
//             .select('*, user_books!inner(*)')
//             .eq('user_books.user_id', userId)
//             .eq('user_books.bookshelf', bookshelf.toLowerCase());
//       }

//       // Add search filter if provided
//       if (searchText != null && searchText.isNotEmpty) {
//         query = query.ilike('title', '%$searchText%');
//       }

//       final response = await query.order('rating', ascending: false);

//       final books = response.map<Book>((json) => Book.fromJson(json)).toList();
      
//       //return BookHub(books: books, total: books.length);
//     } catch (e) {
//       print('Error fetching books: $e');
//       throw Exception('Failed to fetch books: $e');
//     }
//   }

//   // Get top rated books
//   Future<TopRated> getTopRatedBooks() async {
//     try {
//       final response = await _client
//           .from('books')
//           .select('*')
//           .gte('rating', 4.0)
//           .order('rating', ascending: false)
//           .limit(10);

//       final books = response.map<Book>((json) => Book.fromJson(json)).toList();
      
//       return TopRated(books: books);
//     } catch (e) {
//       print('Error fetching top rated books: $e');
//       throw Exception('Failed to fetch top rated books: $e');
//     }
//   }

//   // Get book details by ID
//   Future<BookDetails> getBookDetails(String bookId) async {
//     try {
//       final response = await _client
//           .from('books')
//           .select('*')
//           .eq('id', bookId)
//           .single();

//       // Check if book is in user's bookshelf
//       String? bookshelf;
//       if (_client.auth.currentUser != null) {
//         try {
//           final userBookResponse = await _client
//               .from('user_books')
//               .select('bookshelf')
//               .eq('user_id', _client.auth.currentUser!.id)
//               .eq('book_id', bookId)
//               .maybeSingle();

//           if (userBookResponse != null) {
//             bookshelf = userBookResponse['bookshelf'];
//           }
//         } catch (e) {
//           print('No bookshelf entry found for this book');
//         }
//       }

//       // Create BookDetails with bookshelf info
//       final bookData = Map<String, dynamic>.from(response);
//       if (bookshelf != null) {
//         bookData['book status'] = bookshelf;
//       }

//       return BookDetails.fromJson(bookData);
//     } catch (e) {
//       print('Error fetching book details: $e');
//       throw Exception('Failed to fetch book details: $e');
//     }
//   }

//   // Add book to user's bookshelf
//   Future<void> addToBookshelf(String bookId, String bookshelf) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client.from('user_books').upsert({
//         'user_id': userId,
//         'book_id': bookId,
//         'bookshelf': bookshelf.toLowerCase(),
//       });
//     } catch (e) {
//       print('Error adding to bookshelf: $e');
//       throw Exception('Failed to add to bookshelf: $e');
//     }
//   }

//   // Remove book from user's bookshelf
//   Future<void> removeFromBookshelf(String bookId) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client
//           .from('user_books')
//           .delete()
//           .eq('user_id', userId)
//           .eq('book_id', bookId);
//     } catch (e) {
//       print('Error removing from bookshelf: $e');
//       throw Exception('Failed to remove from bookshelf: $e');
//     }
//   }

//   // Add book to favorites
//   Future<void> addToFavorites(String bookId) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client.from('user_favorites').upsert({
//         'user_id': userId,
//         'book_id': bookId,
//       });
//     } catch (e) {
//       print('Error adding to favorites: $e');
//       throw Exception('Failed to add to favorites: $e');
//     }
//   }

//   // Remove book from favorites
//   Future<void> removeFromFavorites(String bookId) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client
//           .from('user_favorites')
//           .delete()
//           .eq('user_id', userId)
//           .eq('book_id', bookId);
//     } catch (e) {
//       print('Error removing from favorites: $e');
//       throw Exception('Failed to remove from favorites: $e');
//     }
//   }

//   // Add book to cart
//   Future<void> addToCart(String bookId, {int quantity = 1}) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client.from('user_cart').upsert({
//         'user_id': userId,
//         'book_id': bookId,
//         'quantity': quantity,
//       });
//     } catch (e) {
//       print('Error adding to cart: $e');
//       throw Exception('Failed to add to cart: $e');
//     }
//   }

//   // Get user's cart
//   Future<List<Book>> getCartBooks() async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       final response = await _client
//           .from('user_cart')
//           .select('*, books(*)')
//           .eq('user_id', userId);

//       return response.map<Book>((json) => Book.fromJson(json['books'])).toList();
//     } catch (e) {
//       print('Error fetching cart books: $e');
//       throw Exception('Failed to fetch cart books: $e');
//     }
//   }

//   // Remove book from cart
//   Future<void> removeFromCart(String bookId) async {
//     try {
//       final userId = _client.auth.currentUser?.id;
//       if (userId == null) throw Exception('User not authenticated');

//       await _client
//           .from('user_cart')
//           .delete()
//           .eq('user_id', userId)
//           .eq('book_id', bookId);
//     } catch (e) {
//       print('Error removing from cart: $e');
//       throw Exception('Failed to remove from cart: $e');
//     }
//   }
// }