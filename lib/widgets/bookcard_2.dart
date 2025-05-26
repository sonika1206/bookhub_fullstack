import 'package:bookhub_fullstack/models/book.dart';
import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookCard2 extends ConsumerWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard2({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
     final theme = Theme.of(context);
    return FutureBuilder<bool>(
      future: ref.read(booksProvider.notifier).isFavorite(book.id),
      builder: (context, snapshot) {
        final isFavorited = snapshot.data ?? false;
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  book.coverPic != null
                      ? Image.network(
                          book.coverPic!,
                          width: 50,
                          height: 75,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, color: Colors.blue),
                        )
                      : const Icon(Icons.book, size: 50, color: Colors.blue),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue[900]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          book.authorName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue[700]),
                        ),
                        if (book.rating != null)
                          Text(
                            'Rating: ${book.rating!.toStringAsFixed(1)}',
                            style: TextStyle(color: Colors.blue[600]),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? Colors.red : Colors.blue,
                    ),
                    onPressed: () async {
                      if (isFavorited) {
                        await ref.read(booksProvider.notifier).removeFromFavorites(book.id);
                      } else {
                        await ref.read(booksProvider.notifier).addToFavorites(book.id);
                      }
                      ref.invalidate(booksProvider); // Refresh state
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}