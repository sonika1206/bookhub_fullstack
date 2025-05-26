
import 'package:bookhub_fullstack/app_config.dart';
import 'package:bookhub_fullstack/providers/theme_providers.dart';
import 'package:bookhub_fullstack/routing/router.dart';
import 'package:bookhub_fullstack/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await  AppConfig.initialize();
  runApp(ProviderScope(child: BookHubs()));
}

class BookHubs extends ConsumerWidget {
  const BookHubs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      title: 'BookHUB',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeMode,
    );
  }
}
