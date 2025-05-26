// import 'package:bookhub_fullstack/providers/library_providers.dart';
// import 'package:bookhub_fullstack/widgets/footer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LibraryPage extends ConsumerWidget {
//   const LibraryPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final books = ref.watch(filteredBooksProvider);
//     final isLoading = ref.watch(libraryProvider).isLoading;
//     final error = ref.watch(libraryProvider).error;

//     // useEffect(() {
//     //   Future.microtask(() => ref.read(libraryProvider.notifier).fetchBooks());
//     //   return null;
//     // }, []);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Library')),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search by title or author...',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//               onChanged: (value) {
//                 ref.read(searchQueryProvider.notifier).state = value;
//               },
//             ),
//           ),
//           if (isLoading)
//             const Center(child: CircularProgressIndicator())
//           else if (error != null)
//             Center(child: Text('Error: $error'))
//           else if (books.isEmpty)
//             const Center(child: Text('No books found.'))
//           else
//             Expanded(
//               child: GridView.builder(
//                 padding: const EdgeInsets.all(8),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 0.65,
//                   crossAxisSpacing: 8,
//                   mainAxisSpacing: 8,
//                 ),
//                 itemCount: books.length,
//                 itemBuilder: (_, index) {
//                   final book = books[index];
//                   return Card(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (book.coverPic != null)
//                           ClipRRect(
//                             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//                             child: Image.network(
//                               book.coverPic!,
//                               height: 140,
//                               width: double.infinity,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                               Text(book.authorName, style: const TextStyle(fontSize: 12)),
//                               const SizedBox(height: 4),
//                               if (book.rating != null)
//                                 Row(
//                                   children: [
//                                     const Icon(Icons.star, color: Colors.amber, size: 16),
//                                     Text('${book.rating}', style: const TextStyle(fontSize: 12)),
//                                   ],
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//       bottomNavigationBar: const Footer(),
//     );
//   }
// }


import 'dart:async';
import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:bookhub_fullstack/widgets/book_card.dart';
import 'package:bookhub_fullstack/widgets/bookcard_2.dart';
import 'package:bookhub_fullstack/widgets/footer.dart';
import 'package:bookhub_fullstack/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching all books');
      ref.read(booksProvider.notifier).fetchAllBooks('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchTextChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      print('Fetching books for query: $query');
      ref.read(booksProvider.notifier).fetchAllBooks(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: const Header(forceBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search Books',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  labelStyle: TextStyle(color: Colors.blue[700]),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[200]!, width: 1.0),
                  ),
                ),
                onChanged: _onSearchTextChanged,
              ),
            ),
            Expanded(
              child: booksState.isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.blue))
                  : booksState.error != null
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
                              Text(
                                'Error: ${booksState.error}',
                                style: TextStyle(color: Colors.blue[900]),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(booksProvider.notifier).fetchAllBooks(_searchController.text);
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
                      : booksState.searchResults == null || booksState.searchResults!.books.isEmpty
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
                                    'No books found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: booksState.searchResults!.books.length,
                              itemBuilder: (context, index) {
                                final book = booksState.searchResults!.books[index];
                                return BookCard2(
                                  book: book,
                                  onTap: () {
                                    print('Navigating to /book/${book.id}');
                                    context.go('/book/${book.id}');
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}