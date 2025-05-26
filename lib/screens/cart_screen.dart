import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:bookhub_fullstack/widgets/footer.dart';
import 'package:bookhub_fullstack/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Fetching cart items');
      ref.read(booksProvider.notifier).fetchCart();
    });
  }

  Future<void> _updateQuantity(String bookId, int newQuantity) async {
    if (newQuantity <= 0) {
      // Remove item if quantity is 0
      await ref.read(booksProvider.notifier).removeFromCart(bookId);
    } else {
      await ref.read(booksProvider.notifier).updateCartQuantity(bookId, newQuantity);
    }
    // Refresh cart
    await ref.read(booksProvider.notifier).fetchCart();
  }

  Future<void> _removeItem(String bookId) async {
    await ref.read(booksProvider.notifier).removeFromCart(bookId);
    // Refresh cart
    await ref.read(booksProvider.notifier).fetchCart();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item removed from cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksState = ref.watch(booksProvider);

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
                          ref.read(booksProvider.notifier).fetchCart();
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
              : booksState.cart == null || booksState.cart!.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Your cart is empty', style: TextStyle(fontSize: 20, color: Colors.grey)),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: booksState.cart!.length,
                              itemBuilder: (context, index) {
                                final cartItem = booksState.cart![index];
                                final book = cartItem.book;

                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Book Cover
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            book.coverPic ?? 'https://via.placeholder.com/150',
                                            width: 80,
                                            height: 120,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => Container(
                                              width: 80,
                                              height: 120,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.broken_image, size: 40),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        // Book Details and Controls
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Title
                                              Text(
                                                book.title,
                                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context).colorScheme.primary,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              // Author
                                              Text(
                                                'by ${book.authorName}',
                                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                      color: Colors.grey[700],
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                              ),
                                              const SizedBox(height: 12),
                                              // Quantity Controls
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () => _updateQuantity(cartItem.bookId, cartItem.quantity - 1),
                                                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                                                  ),
                                                  Text(
                                                    cartItem.quantity.toString(),
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  IconButton(
                                                    onPressed: () => _updateQuantity(cartItem.bookId, cartItem.quantity + 1),
                                                    icon: const Icon(Icons.add_circle, color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Remove Button
                                        IconButton(
                                          onPressed: () => _removeItem(cartItem.bookId),
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
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