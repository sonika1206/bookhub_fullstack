
import 'package:bookhub_fullstack/providers/books_provider.dart';
import 'package:bookhub_fullstack/widgets/footer.dart';
import 'package:bookhub_fullstack/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddBookScreen extends ConsumerStatefulWidget {
  const AddBookScreen({super.key});

  @override
  ConsumerState<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends ConsumerState<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bookUrlController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _authorNameController = TextEditingController();
  final _aboutBookController = TextEditingController();
  final _aboutAuthorController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _bookUrlController.dispose();
    _bookNameController.dispose();
    _authorNameController.dispose();
    _aboutBookController.dispose();
    _aboutAuthorController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      try {
        await ref.read(booksProvider.notifier).addBook(
              bookUrl: _bookUrlController.text.trim(),
              bookName: _bookNameController.text.trim(),
              authorName: _authorNameController.text.trim(),
              aboutBook: _aboutBookController.text.trim(),
              aboutAuthor: _aboutAuthorController.text.trim(),
            );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Book added successfully!',
              style: const TextStyle(color: Colors.white),),
              backgroundColor: Colors.blue,
            
            ),
          );
          context.pop();
        }
      } catch (e) {
        if (mounted) {
          print("error adding book:$e");
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Error adding book: $e',
              
          //     style: const TextStyle(color: Colors.white),),
          //     backgroundColor: Colors.red,
          //   ),
          // );
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const Header(forceBackButton: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add a New Book',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _bookUrlController,
                          decoration: InputDecoration(
                            labelText: 'Book Cover URL',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: const Icon(Icons.image, color: Colors.blue),
                            labelStyle: TextStyle(color: Colors.blue[700]),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a cover image URL';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _bookNameController,
                          decoration: InputDecoration(
                            labelText: 'Book Name',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: const Icon(Icons.book, color: Colors.blue),
                            labelStyle: TextStyle(color: Colors.blue[700]),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the book name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _authorNameController,
                          decoration: InputDecoration(
                            labelText: 'Author Name',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: const Icon(Icons.person, color: Colors.blue),
                            labelStyle: TextStyle(color: Colors.blue[700]),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter the author name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _aboutBookController,
                          decoration: InputDecoration(
                            labelText: 'About the Book',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: const Icon(Icons.description, color: Colors.blue),
                            labelStyle: TextStyle(color: Colors.blue[700]),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter details about the book';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _aboutAuthorController,
                          decoration: InputDecoration(
                            labelText: 'About the Author',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            prefixIcon: const Icon(Icons.info, color: Colors.blue),
                            labelStyle: TextStyle(color: Colors.blue[700]),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                            ),
                          ),
                          maxLines: 4,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter details about the author';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 2,
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Add Book',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}