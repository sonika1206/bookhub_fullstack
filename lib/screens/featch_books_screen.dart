import 'dart:async';
import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:bookhub_fullstack/widgets/book_card.dart';
import 'package:bookhub_fullstack/widgets/footer.dart';
import 'package:bookhub_fullstack/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchBooksScreen extends ConsumerStatefulWidget {
  const SearchBooksScreen({super.key});

  @override
  ConsumerState<SearchBooksScreen> createState() => _SearchBooksScreenState();
}

class _SearchBooksScreenState extends ConsumerState<SearchBooksScreen> {
  final _searchController = TextEditingController();
  String _selectedBookshelf = 'currently_reading';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching initial books for bookshelf: $_selectedBookshelf');
      ref.read(booksProvider.notifier).fetchBooks(_selectedBookshelf, '');
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
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        print(
          'Fetching books for query: $query, bookshelf: $_selectedBookshelf',
        );
        ref.read(booksProvider.notifier).fetchBooks(_selectedBookshelf, query);
      } else {
        print(
          'Fetching books with empty query for bookshelf: $_selectedBookshelf',
        );
        ref.read(booksProvider.notifier).fetchBooks(_selectedBookshelf, '');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

    return Scaffold(
      appBar: const Header(forceBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // TextField(
                //   controller: _searchController,
                //   decoration: const InputDecoration(
                //     labelText: 'Search Books',
                //     border: OutlineInputBorder(),
                //     prefixIcon: Icon(Icons.search),
                //   ),
                //   onChanged: _onSearchTextChanged,
                // ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedBookshelf,
                  decoration: const InputDecoration(
                    labelText: 'Bookshelf',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ALL', child: Text('All')),
                    DropdownMenuItem(value: 'read', child: Text('Read')),
                    DropdownMenuItem(
                      value: 'currently_reading',
                      child: Text('Currently Reading'),
                    ),
                    DropdownMenuItem(
                      value: 'want_to_read',
                      child: Text('Want To Read'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedBookshelf = value!;
                      _onSearchTextChanged(_searchController.text);
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child:
                booksState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : booksState.error != null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${booksState.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(booksProvider.notifier)
                                  .fetchBooks(
                                    _selectedBookshelf,
                                    _searchController.text,
                                  );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                    : booksState.searchResults == null ||
                        booksState.searchResults!.books.isEmpty
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
                          const Text('No Books found in this shelf'),
                        ],
                      ),
                    )
                    : SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: booksState.searchResults!.books.length,
                            itemBuilder: (context, index) {
                              final book =
                                  booksState.searchResults!.books[index];
                              return BookCard(
                                book: book,
                                onTap: () {
                                  print('Navigating to /book/${book.id}');
                                  context.go('/book/${book.id}');
                                },
                              );
                            },
                          ),
                          //const Footer(),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
