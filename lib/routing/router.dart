import 'package:bookhub_fullstack/screens/add_book_screeen.dart';
import 'package:bookhub_fullstack/screens/book_details_screen.dart';
import 'package:bookhub_fullstack/screens/cart_screen.dart';
import 'package:bookhub_fullstack/screens/favourite_screen.dart';
import 'package:bookhub_fullstack/screens/featch_books_screen.dart';
import 'package:bookhub_fullstack/screens/library_page.dart';
import 'package:bookhub_fullstack/screens/login.dart';
import 'package:bookhub_fullstack/screens/signup.dart';
import 'package:bookhub_fullstack/screens/splash_screen.dart';
import 'package:bookhub_fullstack/screens/top_rated_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(path: "/login", builder: (context, state) => const LoginPage()),
    GoRoute(
      path: "/signup",
      builder: (context, state) => const RegisterPage(isRegistering: true),
    ),
    GoRoute(
      path: '/top',
      builder: (context, state) => const TopRatedBooksScreen(),
    ),
    GoRoute(
      path: '/book/:id',
      builder:
          (context, state) =>
              BookDetailsScreen(bookId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: '/fetch',
      builder: (context, state) => const SearchBooksScreen(),
    ),
    GoRoute(
      path: '/add-book',
      builder: (context, state) => const AddBookScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/library',
      builder: (context, state) => const LibraryScreen(),
    ),
     GoRoute(
      path: '/favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);
