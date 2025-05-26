
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));
const formSpacer = SizedBox(width: 16, height: 16);

const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
const unexpectedErrorMessage = 'Unexpected error occurred.';

extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}
