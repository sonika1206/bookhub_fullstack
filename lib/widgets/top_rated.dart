// import 'package:bookhub_fullstack/models/book.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class TopRatedBooks extends StatelessWidget {
//   final List<Book> books;

//   const TopRatedBooks({super.key, required this.books});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         SizedBox(height: 25,),
//          Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Text(
//             'Top Rated Books',
//             // style: TextStyle(
//             //   fontSize: 20,
//             //   fontWeight: FontWeight.bold,
//             //   color: Colors.black87,
//             // ),
//             style: theme.textTheme.headlineLarge,
//           ),
//         ),
//         SizedBox(height: 25,),
//         SizedBox(
          
//           height: 450,
//           child: ListView.builder(
            
//             scrollDirection: Axis.horizontal,
//             itemCount: books.length,
//             itemBuilder: (context, index) {
//               final topbook = books[index];
              
//               return InkWell(
//                  onTap: () {
//                   context.go('/book/${topbook.id}');
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.network(
//                           topbook.coverPic,
//                           width: 200,
//                           height: 250,
//                           fit: BoxFit.fill,
//                           errorBuilder: (context, error, stackTrace) => const Icon(
//                             Icons.broken_image,
//                             size: 120,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         topbook.title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       Text(
//                         topbook.authorName,
//                         style: theme.textTheme.bodySmall
//                       ),
//                       //const SizedBox(height: 8),
//                       const SizedBox(width: 35,)
//                     ],
//                   ),
//                 ),
//               );
            
            
            
            
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:bookhub_fullstack/models/book.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopRatedBooks extends StatelessWidget {
  final List<Book> books;

  const TopRatedBooks({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Top Rated Books',
            style: theme.textTheme.headlineLarge,
          ),
        ),
        const SizedBox(height: 25),
        SizedBox(
          height: 450,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              return InkWell(
                onTap: () {
                  print('Navigating to /book/${book.id} and this is from top_rated');
                   context.go('/book/${book.id}');
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: book.coverPic != null
                            ? Image.network(
                                book.coverPic!,
                                width: 200,
                                height: 250,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.broken_image,
                                  size: 120,
                                ),
                              )
                            : const Icon(
                                Icons.book,
                                size: 120,
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        book.authorName,
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(width: 35),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}