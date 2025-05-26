// import 'package:bookhub_fullstack/providers/auth_providers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final _usernameController = TextEditingController(text: '');
//   final _passwordController = TextEditingController(text: '');
//   bool _isPasswordVisible = false;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final authNotifier = ref.read(authProvider.notifier);

//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset('assets/images/image copy.png', height: 250, width:250 ),
//               SizedBox(height: 20,),
//               const Text(
//                 'BookHUB',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//               const SizedBox(height: 32),
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: 'Username',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: !_isPasswordVisible,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: const OutlineInputBorder(),
//                   suffixIcon: IconButton(
//                     icon: Icon(
//                       _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _isPasswordVisible = !_isPasswordVisible;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               if (authState.errorMessage != null)
//                 Text(
//                   'Enter valid login Credintials',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: authState.isLoading
//                       ? null
//                       : () async {
//                           await authNotifier.login(
//                             _usernameController.text,
//                             _passwordController.text,
//                             context,
//                           );
//                         },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: authState.isLoading
//                       ? const CircularProgressIndicator(
//                           color: Colors.white,
//                         )
//                       : const Text('Login', style: TextStyle(fontSize: 16)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:bookhub_fullstack/app_config.dart';
import 'package:bookhub_fullstack/services/auth_services.dart';
import 'package:bookhub_fullstack/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _supabaseService = AuthService(AppConfig.client);

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await _supabaseService.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      print('Login successful, navigating to /top');
      if (mounted) {
        context.go('/top');
      }
    } on AuthException catch (error) {
      print('AuthException: ${error.message}');
      if (mounted) {
        context.showErrorSnackBar(message: error.message);
      }
    } catch (e) {
      if (mounted) {
        print('Unexpected error: $e');
        context.showErrorSnackBar(message: unexpectedErrorMessage);
      }
    } finally {
      print('Login attempt finished');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Sign In",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
            Image.asset('assets/images/6343825.jpg', height: 250, width:250 ),
            // Image.network(
            //  // "https://i.pinimg.com/originals/09/85/c0/0985c0ab4984a7ed5797195f14359cc2.gif",
            //   "https://i.pinimg.com/originals/e3/b7/ec/e3b7eccfc4e1132329e6e2639e95b447.gif",
            //   width: 200,
            //   height: 250,
            //   fit: BoxFit.fill,
            //   errorBuilder:
            //       (context, error, stackTrace) =>
            //           const Icon(Icons.broken_image, size: 120),
            // ),
            // Image.asset('assets/images/6343825.jpg', height: 250, width:250 ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(val)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            formSpacer,
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
              obscuringCharacter: '*',
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Password is required';
                }
                if (val.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            formSpacer,
            ElevatedButton(
              onPressed: _isLoading ? null : _signIn,
              child: const Text("Login"),
            ),
            formSpacer,
            TextButton(
              onPressed: () => context.go('/signup'),
              child: const Text("I don't have an account"),
            ),
          ],
        ),
      ),
    );
  }
}
