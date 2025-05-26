

// import 'package:bookhub_fullstack/providers/books_provider.dart';
// import 'package:bookhub_fullstack/widgets/book_card.dart';
// import 'package:bookhub_fullstack/widgets/footer.dart';
// import 'package:bookhub_fullstack/widgets/header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class BookDetailsScreen extends ConsumerStatefulWidget {
//   final String bookId;

//   const BookDetailsScreen({super.key, required this.bookId});

//   @override
//   ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
// }

// class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       print('Fetching book details for ID: ${widget.bookId}');
//       ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final booksState = ref.watch(booksProvider);
//     final bookDetails = booksState.bookDetails;
//     final authorBooks = booksState.authorBooks;

//     return Scaffold(
//       appBar: const Header(forceBackButton: true),
//       body: booksState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : booksState.error != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Error: ${booksState.error}'),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
//                         },
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : bookDetails == null
//                   ? const Center(child: Text('Book not found'))
//                   : SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Book Cover and Basic Info
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(8),
//                                   child: Image.network(
//                                     bookDetails.coverPic ?? 'https://via.placeholder.com/150',
//                                     width: 120,
//                                     height: 180,
//                                     fit: BoxFit.cover,
//                                     errorBuilder: (context, error, stackTrace) => Container(
//                                       width: 120,
//                                       height: 180,
//                                       color: Colors.grey[300],
//                                       child: const Icon(Icons.broken_image, size: 50),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 16),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         bookDetails.title,
//                                         style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       Text(
//                                         'by ${bookDetails.authorName}',
//                                         style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                               color: Colors.grey[600],
//                                             ),
//                                       ),
//                                       const SizedBox(height: 8),
//                                       if (bookDetails.rating != null)
//                                         Row(
//                                           children: [
//                                             const Icon(Icons.star, color: Colors.amber, size: 20),
//                                             const SizedBox(width: 4),
//                                             Text(
//                                               bookDetails.rating.toString(),
//                                               style: Theme.of(context).textTheme.titleMedium,
//                                             ),
//                                           ],
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // About the Book
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'About the Book',
//                                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).colorScheme.primary,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   bookDetails.aboutBook ?? 'No description available.',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           // About the Author
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'About the Author',
//                                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).colorScheme.primary,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   bookDetails.aboutAuthor ?? 'No author information available.',
//                                   style: Theme.of(context).textTheme.bodyLarge,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           // Related Books by Author
//                           if (authorBooks!.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'More by ${bookDetails.authorName}',
//                                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Theme.of(context).colorScheme.primary,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 8),
//                                   SizedBox(
//                                     height: 200,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: authorBooks.length,
//                                       itemBuilder: (context, index) {
//                                         final book = authorBooks[index];
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 16),
//                                           child: SizedBox(
//                                             width: 120,
//                                             child: BookCard(
//                                               book: book,
//                                               onTap: () {
//                                                 print('Navigating to /book/${book.id}');
//                                                 context.go('/book/${book.id}');
//                                               },
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           const SizedBox(height: 16),
//                           const Footer(),
//                         ],
//                       ),
//                     ),
//     );
//   }
// }






// import 'package:bookhub_fullstack/providers/books_provider.dart';
// import 'package:bookhub_fullstack/widgets/book_card.dart';
// import 'package:bookhub_fullstack/widgets/footer.dart';
// import 'package:bookhub_fullstack/widgets/header.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class BookDetailsScreen extends ConsumerStatefulWidget {
//   final String bookId;

//   const BookDetailsScreen({super.key, required this.bookId});

//   @override
//   ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
// }

// class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
//   String? _selectedBookshelf;
//   bool _isAddingToCart = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       print('Fetching book details for ID: ${widget.bookId}');
//       ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
//     });
//   }

//   Future<void> _addToCart() async {
//     setState(() {
//       _isAddingToCart = true;
//     });
//     try {
//       await ref.read(booksProvider.notifier).addToCart(widget.bookId, 1);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Added to cart successfully!')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding to cart: $e')),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isAddingToCart = false;
//         });
//       }
//     }
//   }

//   Future<void> _addToBookshelf(String bookshelf) async {
//     try {
//       await ref.read(booksProvider.notifier).addToBookshelf(widget.bookId, bookshelf);
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Added to $bookshelf shelf!')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error adding to shelf: $e')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final booksState = ref.watch(booksProvider);
//     final bookDetails = booksState.bookDetails;
//     final authorBooks = booksState.authorBooks;

//     return Scaffold(
//       appBar: const Header(forceBackButton: true),
//       body: booksState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : booksState.error != null
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text('Error: ${booksState.error}', style: Theme.of(context).textTheme.titleMedium),
//                       const SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                         ),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : bookDetails == null
//                   ? const Center(child: Text('Book not found'))
//                   : SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // Book Cover and Basic Info (Wrapped in Card)
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Card(
//                               elevation: 4,
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(16.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         ClipRRect(
//                                           borderRadius: BorderRadius.circular(8),
//                                           child: Image.network(
//                                             bookDetails.coverPic ?? 'https://via.placeholder.com/150',
//                                             width: 120,
//                                             height: 180,
//                                             fit: BoxFit.cover,
//                                             errorBuilder: (context, error, stackTrace) => Container(
//                                               width: 120,
//                                               height: 180,
//                                               color: Colors.grey[300],
//                                               child: const Icon(Icons.broken_image, size: 50),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 16),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment: CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 bookDetails.title,
//                                                 style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                                                       fontWeight: FontWeight.bold,
//                                                       color: Theme.of(context).colorScheme.primary,
//                                                     ),
//                                               ),
//                                               const SizedBox(height: 8),
//                                               Text(
//                                                 'by ${bookDetails.authorName}',
//                                                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                                       color: Colors.grey[700],
//                                                       fontStyle: FontStyle.italic,
//                                                     ),
//                                               ),
//                                               const SizedBox(height: 12),
//                                               if (bookDetails.rating != null)
//                                                 Row(
//                                                   children: [
//                                                     const Icon(Icons.star, color: Colors.amber, size: 24),
//                                                     const SizedBox(width: 4),
//                                                     Text(
//                                                       bookDetails.rating.toString(),
//                                                       style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                                             fontWeight: FontWeight.bold,
//                                                           ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 16),
//                                     // Action Buttons (Bookshelf Dropdown + Add to Cart)
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         // Bookshelf Dropdown
//                                         DropdownButton<String>(
//                                           value: _selectedBookshelf,
//                                           hint: Text(
//                                             'Add to Bookshelf',
//                                             style: TextStyle(
//                                               color: Theme.of(context).colorScheme.primary,
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                           icon: Icon(
//                                             Icons.arrow_drop_down,
//                                             color: Theme.of(context).colorScheme.primary,
//                                           ),
//                                           items: const [
//                                             DropdownMenuItem(
//                                               value: 'READ',
//                                               child: Text('Read'),
//                                             ),
//                                             DropdownMenuItem(
//                                               value: 'WANT_TO_READ',
//                                               child: Text('Want to Read'),
//                                             ),
//                                             DropdownMenuItem(
//                                               value: 'CURRENTLY_READING',
//                                               child: Text('Reading'),
//                                             ),
//                                           ],
//                                           onChanged: (value) {
//                                             if (value != null) {
//                                               setState(() {
//                                                 _selectedBookshelf = value;
//                                               });
//                                               _addToBookshelf(value);
//                                               setState(() {
//                                                 _selectedBookshelf = null; // Reset dropdown
//                                               });
//                                             }
//                                           },
//                                           underline: Container(),
//                                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                                 color: Theme.of(context).colorScheme.primary,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                           dropdownColor: Colors.white,
//                                           borderRadius: BorderRadius.circular(8),
//                                           elevation: 2,
//                                         ),
//                                         // Add to Cart Button
//                                         ElevatedButton.icon(
//                                           onPressed: _isAddingToCart ? null : _addToCart,
//                                           icon: _isAddingToCart
//                                               ? const SizedBox(
//                                                   width: 20,
//                                                   height: 20,
//                                                   child: CircularProgressIndicator(
//                                                     color: Colors.white,
//                                                     strokeWidth: 2,
//                                                   ),
//                                                 )
//                                               : const Icon(Icons.shopping_cart),
//                                           label: const Text('Add to Cart'),
//                                           style: ElevatedButton.styleFrom(
//                                             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                             backgroundColor: Theme.of(context).colorScheme.primary,
//                                             foregroundColor: Colors.white,
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius: BorderRadius.circular(8),
//                                             ),
//                                             elevation: 2,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // About the Book
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'About the Book',
//                                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).colorScheme.primary,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     bookDetails.aboutBook ?? 'No description available.',
//                                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                           color: Colors.grey[800],
//                                           height: 1.5,
//                                         ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // About the Author
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'About the Author',
//                                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                         fontWeight: FontWeight.bold,
//                                         color: Theme.of(context).colorScheme.primary,
//                                       ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[100],
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Text(
//                                     bookDetails.aboutAuthor ?? 'No author information available.',
//                                     style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                                           color: Colors.grey[800],
//                                           height: 1.5,
//                                         ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Related Books by Author
//                           if (authorBooks!.isNotEmpty)
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'More by ${bookDetails.authorName}',
//                                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                                           fontWeight: FontWeight.bold,
//                                           color: Theme.of(context).colorScheme.primary,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 12),
//                                   SizedBox(
//                                     height: 200,
//                                     child: ListView.builder(
//                                       scrollDirection: Axis.horizontal,
//                                       itemCount: authorBooks.length,
//                                       itemBuilder: (context, index) {
//                                         final book = authorBooks[index];
//                                         return Padding(
//                                           padding: const EdgeInsets.only(right: 16),
//                                           child: SizedBox(
//                                             width: 120,
//                                             child: BookCard(
//                                               book: book,
//                                               onTap: () {
//                                                 print('Navigating to /book/${book.id}');
//                                                 context.go('/book/${book.id}');
//                                               },
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           const SizedBox(height: 16),
//                           const Footer(),
//                         ],
//                       ),
//                     ),
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

class BookDetailsScreen extends ConsumerStatefulWidget {
  final String bookId;

  const BookDetailsScreen({super.key, required this.bookId});

  @override
  ConsumerState<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  String? _selectedBookshelf;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching book details for ID: ${widget.bookId}');
      ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
    });
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });
    try {
      await ref.read(booksProvider.notifier).addToCart(widget.bookId, 1);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to cart successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to cart: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  Future<void> _addToBookshelf(String bookshelf) async {
    try {
      // Map display values to database values
      final dbBookshelf = bookshelf.toLowerCase();
      await ref.read(booksProvider.notifier).addToBookshelf(widget.bookId, dbBookshelf);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to ${bookshelf.replaceAll('_', ' ').toLowerCase()} shelf!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding to shelf: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final booksState = ref.watch(booksProvider);
    final bookDetails = booksState.bookDetails;
    final authorBooks = booksState.authorBooks;

    return Scaffold(
      appBar: const Header(forceBackButton: true),
      body: booksState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksState.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${booksState.error}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(booksProvider.notifier).fetchBookDetails(widget.bookId);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : bookDetails == null
                  ? const Center(child: Text('Book not found'))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Book Cover and Basic Info (Wrapped in Card)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            bookDetails.coverPic ?? 'https://via.placeholder.com/150',
                                            width: 120,
                                            height: 180,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 120,
                                              height: 180,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image, size: 50),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                bookDetails.title,
                                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.blue,
                                                    ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'by ${bookDetails.authorName}',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      color: Colors.grey[700],
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                              ),
                                              const SizedBox(height: 12),
                                              if (bookDetails.rating != null)
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star, color: Colors.amber, size: 24),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      bookDetails.rating.toString(),
                                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // Action Buttons (Bookshelf Dropdown + Add to Cart)
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Bookshelf Dropdown
                                        DropdownButton<String>(
                                          value: _selectedBookshelf,
                                          hint: Text(
                                            'Add to Bookshelf',
                                            style: theme.textTheme.bodyLarge,
                                          ),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'read',
                                              child: Text('Read'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'want_to_read',
                                              child: Text('Want to Read'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'currently_reading',
                                              child: Text('Reading'),
                                            ),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedBookshelf = value;
                                              });
                                              _addToBookshelf(value);
                                              setState(() {
                                                _selectedBookshelf = null; // Reset dropdown
                                              });
                                            }
                                          },
                                          underline: Container(),
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                          dropdownColor: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          elevation: 2,
                                        ),
                                        // Add to Cart Button
                                        ElevatedButton.icon(
                                          onPressed: _isAddingToCart ? null : _addToCart,
                                          icon: _isAddingToCart
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Icon(Icons.shopping_cart),
                                          label: const Text('Add to Cart'),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            backgroundColor: Theme.of(context).colorScheme.primary,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            elevation: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // About the Book
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About the Book',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    bookDetails.aboutBook ?? 'No description available.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.grey[800],
                                          height: 1.5,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // About the Author
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About the Author',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    bookDetails.aboutAuthor ?? 'No author information available.',
                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          color: Colors.grey[800],
                                          height: 1.5,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Related Books by Author
                          if (authorBooks!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'More by ${bookDetails.authorName}',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 200,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: authorBooks.length,
                                      itemBuilder: (context, index) {
                                        final book = authorBooks[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(right: 16),
                                          child: SizedBox(
                                            width: 120,
                                            child: BookCard(
                                              book: book,
                                              onTap: () {
                                                print('Navigating to /book/${book.id}');
                                                context.go('/book/${book.id}');
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 16),
                          //const Footer(),
                        ],
                      ),
                    ),
                    bottomNavigationBar: const Footer(),
    );
  }
}