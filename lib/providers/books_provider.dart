import 'package:bookhub_fullstack/main.dart';
import 'package:bookhub_fullstack/models/book.dart';
import 'package:bookhub_fullstack/models/book_details.dart';
import 'package:bookhub_fullstack/models/book_hub.dart';
import 'package:bookhub_fullstack/models/cart_item.dart';
import 'package:bookhub_fullstack/models/toprated_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final booksProvider = StateNotifierProvider<BooksNotifier, BooksState>((ref) {
  return BooksNotifier();
});





class BooksState {
  final BookHub? searchResults;
  final TopRated? topRated;
  final BookDetails? bookDetails;
  final List<Book>? authorBooks;
  final List<Book>? favorites;
  final List<CartItem>? cart;
  final String? currentBookshelf;
  final bool isLoading;
  final String? error;

  BooksState({
    this.searchResults,
    this.topRated,
    this.bookDetails,
    this.authorBooks,
    this.favorites,
    this.cart,
    this.currentBookshelf,
    this.isLoading = false,
    this.error,
  });

  BooksState copyWith({
    BookHub? searchResults,
    TopRated? topRated,
    BookDetails? bookDetails,
    List<Book>? authorBooks,
    List<Book>? favorites,
    List<CartItem>? cart,
    String? currentBookshelf,
    bool? isLoading,
    String? error,
  }) {
    return BooksState(
   
      searchResults: searchResults ?? this.searchResults,
      topRated: topRated ?? this.topRated,
      bookDetails: bookDetails ?? this.bookDetails,
      authorBooks: authorBooks ?? this.authorBooks,
      favorites: favorites ?? this.favorites,
      cart: cart ?? this.cart,
      currentBookshelf: currentBookshelf ?? this.currentBookshelf,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}class BooksNotifier extends StateNotifier<BooksState> {
  final SupabaseClient _supabase = Supabase.instance.client;
  final _uuid = const Uuid();
  BooksNotifier() : super(BooksState()) {
    fetchTopRatedBooks();
    _subscribeToUserBooks();
  }



  Future<void> fetchAllBooks(String searchText) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final query = _supabase
          .from('books')
          .select('id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at');

      if (searchText.isNotEmpty) {
        query.ilike('title', '%$searchText%');
      }

      final response = await query;
      print('fetchAllBooks response: $response');
      final books = response.map((json) => Book.fromJson(json)).toList();
      state = state.copyWith(
        searchResults: BookHub(books: books),
        isLoading: false,
      );
    } catch (e) {
      print('fetchAllBooks error: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }


  Future<void> fetchTopRatedBooks() async {
    if (state.topRated != null && state.topRated!.books.isNotEmpty) {
      print('Top rated books already loaded, skipping fetch');
      return;
    }
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _supabase
          .from('books')
          .select('id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at')
          .order('rating', ascending: false)
          .limit(10);
      final books = response.map((json) => Book.fromJson(json)).toList();
      state = state.copyWith(topRated: TopRated(books: books), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchBooks(String bookshelf, String searchText) async {
    state = state.copyWith(isLoading: true, error: null, currentBookshelf: bookshelf.toLowerCase());
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final query = _supabase
          .from('user_books')
          .select('book_id, books(id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at)')
          .eq('user_id', userId)
          .eq('bookshelf', bookshelf.toLowerCase());

      if (searchText.isNotEmpty) {
        query.ilike('books.title', '%$searchText%');
      }

      final response = await query;
      final books = response.map((json) => Book.fromJson(json['books'])).toList();
      state = state.copyWith(searchResults: BookHub(books: books), isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchBookDetails(String bookId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      print('Fetching details for bookId: $bookId');
      final response = await _supabase
          .from('books')
          .select('id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at')
          .eq('id', bookId)
          .maybeSingle(); // Use maybeSingle to handle no results
      print('fetchBookDetails response: $response');

      if (response == null) {
        throw Exception('No book found with ID: $bookId');
      }

      final bookDetails = BookDetails.fromJson(response);

      final authorBooks = await _supabase
          .from('books')
          .select('id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at')
          .eq('author_name', bookDetails.authorName)
          .neq('id', bookId)
          .limit(5);
      final otherBooks = authorBooks.map((json) => Book.fromJson(json)).toList();

      state = state.copyWith(
        bookDetails: bookDetails,
        authorBooks: otherBooks,
        isLoading: false,
      );
    } catch (e) {
      print('fetchBookDetails error: $e');
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  

  Future<void> updateBookshelf(String bookId, String newBookshelf) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('user_books')
          .update({'bookshelf': newBookshelf.toLowerCase()})
          .eq('user_id', userId)
          .eq('book_id', bookId);
      print('Updated bookshelf for book $bookId to $newBookshelf');

      // Refresh books for the current bookshelf if set
      if (state.currentBookshelf != null) {
        fetchBooks(state.currentBookshelf!, '');
      }
    } catch (e) {
      print('updateBookshelf error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeFromBookshelf(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('user_books')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);
      print('Removed from bookshelf: $bookId');

      // Refresh books for the current bookshelf if set
      if (state.currentBookshelf != null) {
        fetchBooks(state.currentBookshelf!, '');
      }
    } catch (e) {
      print('removeFromBookshelf error: $e');
      state = state.copyWith(error: e.toString());
    }
  }
  Future<void> addToBookshelf(String bookId, String bookshelf) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('user_books').insert({
        'user_id': userId,
        'book_id': bookId,
        'bookshelf': bookshelf,
      });
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeFromFavorites(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');
      await _supabase
          .from('user_favorites')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);
      state = state.copyWith(
        favorites: state.favorites?.where((book) => book.id != bookId).toList(),
      );
    } catch (e) {
      print('removeFromFavorites error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> isFavorite(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return false;
      final response = await _supabase
          .from('user_favorites')
          .select('book_id')
          .eq('user_id', userId)
          .eq('book_id', bookId)
          .maybeSingle();
      return response != null;
    } catch (e) {
      print('isFavorite error: $e');
      return false;
    }
  }


  Future<void> addToFavorites(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('user_favorites').insert({
        'user_id': userId,
        'book_id': bookId,
      });
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }


  Future<void> addBook({
    required String bookUrl,
    required String bookName,
    required String authorName,
    required String aboutBook,
    required String aboutAuthor,
  }) async {
    try {
      final bookId = _uuid.v4();
      await _supabase.from('books').insert({
        'id': bookId,
        'title': bookName,
        'author_name': authorName,
        'cover_pic': bookUrl,
        'about_book': aboutBook,
        'about_author': aboutAuthor,
        'rating': null, // Optional, set to null
      });
      print('Book added successfully: $bookId');
    } catch (e) {
      print('addBook error: $e');
      throw Exception('Failed to add book: $e');
    }
  }



  Future<void> fetchFavorites() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('user_favorites')
          .select('book_id, books(id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at)')
          .eq('user_id', userId);
      final books = response.map((json) => Book.fromJson(json['books'])).toList();
      state = state.copyWith(favorites: books, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addToCart(String bookId, int quantity) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase.from('user_cart').insert({
        'user_id': userId,
        'book_id': bookId,
        'quantity': quantity,
      });
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateCartQuantity(String bookId, int newQuantity) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('user_cart')
          .update({'quantity': newQuantity})
          .eq('user_id', userId)
          .eq('book_id', bookId);
    } catch (e) {
      print('updateCartQuantity error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeFromCart(String bookId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _supabase
          .from('user_cart')
          .delete()
          .eq('user_id', userId)
          .eq('book_id', bookId);
    } catch (e) {
      print('removeFromCart error: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _supabase
          .from('user_cart')
          .select('book_id, quantity, books(id, title, author_name, cover_pic, rating, about_book, about_author, created_at, updated_at)')
          .eq('user_id', userId);
      final cartItems = response.map((json) => CartItem.fromJson(json)).toList();
      state = state.copyWith(cart: cartItems, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void refreshTopRatedBooks() {
    state = state.copyWith(topRated: null);
    fetchTopRatedBooks();
  }

  void _subscribeToUserBooks() {
    _supabase
        .from('user_books')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> changes) {
      if (state.searchResults != null && state.currentBookshelf != null) {
        fetchBooks(state.currentBookshelf!, '');
      }
    });
  }


  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
      print('User logged out successfully');
      state = BooksState(
        topRated: state.topRated, // Retain topRated books
        isLoading: false,
        error: null,
      );
    } catch (e) {
      print('logout error: $e');
      state = state.copyWith(error: e.toString());
    }
  }
}