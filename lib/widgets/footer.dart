// import 'package:flutter/material.dart';

// class Footer extends StatelessWidget {
//   const Footer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Container(
//       color: theme.cardColor,
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.g_mobiledata, size: 30),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.camera_alt, size: 30),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.play_circle, size: 30),
//                 onPressed: () {},
//               ),
//               IconButton(
//                 icon: const Icon(Icons.message, size: 30),
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'Contact Us',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//        Container(
//       padding: const EdgeInsets.all(16),
//       color: Theme.of(context).colorScheme.surfaceContainer,
//       child: const Text(
//         '© 2025 BookHUB. All rights reserved.',
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 12),
//       ),
//     )
//         ],
//       ),
//     );
//   }
// }

import 'package:bookhub_fullstack/providers/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Footer extends ConsumerWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme=Theme.of(context);
    final currentPath = GoRouterState.of(context).uri.toString();
    int currentIndex = 0;

    // Map routes to indices
    const routes = [
      '/top',
      '/add-book',
      '/library',
      '/cart',
      '/fetch',
      '/favorites',
    ];

    currentIndex = routes.indexOf(currentPath);
    if (currentIndex == -1) currentIndex = 0; // Default to home

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        context.go(routes[index]);
      },
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.blue[200],
      backgroundColor: theme.scaffoldBackgroundColor,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.star, size: 24),
          label: 'Top Rated',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle, size: 24),
          label: 'Add Book',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 24),
          label: 'Library',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart, size: 24),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book, size: 24),
          label: 'Bookshelves',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite, size: 24),
          label: 'Favorites',
        ),
      ],
    );
  }
}