// import 'package:bookhub_fullstack/providers/books_provider.dart';
// import 'package:bookhub_fullstack/widgets/book_card.dart';
// import 'package:bookhub_fullstack/widgets/footer.dart';
// import 'package:bookhub_fullstack/widgets/header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class FavoritesScreen extends ConsumerWidget {
//   const FavoritesScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final booksState = ref.watch(booksProvider);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(booksProvider.notifier).fetchFavorites();
//     });

//     return Scaffold(
//       appBar: const Header(forceBackButton: true),
//       body: SafeArea(
//         child: booksState.isLoading
//             ? const Center(child: CircularProgressIndicator(color: Colors.blue))
//             : booksState.error != null
//                 ? Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Error: ${booksState.error}',
//                           style: TextStyle(color: Colors.blue[900]),
//                         ),
//                         const SizedBox(height: 16),
//                         ElevatedButton(
//                           onPressed: () {
//                             ref.read(booksProvider.notifier).fetchFavorites();
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             foregroundColor: Colors.white,
//                           ),
//                           child: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   )
//                 : booksState.favorites == null || booksState.favorites!.isEmpty
//                     ? Center(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'assets/images/image.png',
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             ),
//                             const SizedBox(height: 20),
//                             Text(
//                               'No favorites found',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 color: Colors.blue[900],
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     : ListView.builder(
//                         itemCount: booksState.favorites!.length,
//                         itemBuilder: (context, index) {
//                           final book = booksState.favorites![index];
//                           return BookCard(
//                             book: book,
//                             onTap: () {
//                               print('Navigating to /book/${book.id}');
//                               context.go('/book/${book.id}');
//                             },
//                           );
//                         },
//                       ),
//       ),
//       bottomNavigationBar: const Footer(),
//     );
//   }
// }

import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:bookhub_fullstack/widgets/book_card.dart';
import 'package:bookhub_fullstack/widgets/footer.dart';
import 'package:bookhub_fullstack/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Check authentication and fetch favorites once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        print('User not authenticated, redirecting to /login');
        context.go('/login');
      } else {
        print('Fetching favorites');
        ref.read(booksProvider.notifier).fetchFavorites();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: const Header(forceBackButton: true),
      body: SafeArea(
        child: booksState.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : booksState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${booksState.error}',
                          style: TextStyle(color: Colors.blue[900]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(booksProvider.notifier).fetchFavorites();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : booksState.favorites == null || booksState.favorites!.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           Image.network(
                            // "https://i.pinimg.com/originals/09/85/c0/0985c0ab4984a7ed5797195f14359cc2.gif",
                            //"https://i.pinimg.com/originals/e3/b7/ec/e3b7eccfc4e1132329e6e2639e95b447.gif",
                            "https://i.pinimg.com/originals/8c/be/f9/8cbef91477a330f11dac83f07ff3c9b7.gif",
                            width: 200,
                            height: 250,
                            fit: BoxFit.fill,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 120),
                          ),
                            const SizedBox(height: 20),
                            Text(
                              'No favorites found',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: booksState.favorites!.length,
                        itemBuilder: (context, index) {
                          final book = booksState.favorites![index];
                          return BookCard(
                            book: book,
                            onTap: () {
                              print('Navigating to /book/${book.id}');
                              context.go('/book/${book.id}');
                            },
                          );
                        },
                      ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}