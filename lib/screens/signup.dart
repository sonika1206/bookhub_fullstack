// import 'package:bookhub_fullstack/providers/auth_providers.dart';
// import 'package:bookhub_fullstack/widgets/constants.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// // Import your updated auth provider
// // import 'package:bookhub_prjct/providers/auth_provider.dart';

// class SignUpScreen extends ConsumerStatefulWidget {
//   const SignUpScreen({super.key});

//   @override
//   ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends ConsumerState<SignUpScreen> {
//   final _usernameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isPasswordVisible = false;
//   bool _isConfirmPasswordVisible = false;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   Future<void> _signUp() async {
//     final isValid = _formKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     final email = _emailController.text;
//     final username = _usernameController.text;
//     final password = _passwordController.text;
//     try {
//       await supabase.auth.signUp(
//         email: email,
//         password: password,
//         data: {'username': username},
//       );
//       //context.go("/chatPage");
//     } on AuthException catch (error) {
//       context.showErrorSnackBar(message: error.message);
//     } catch (error) {
//       if (!mounted) return;
//       context.showErrorSnackBar(message: unexpectedErrorMessage);
//     }
//   }
//   // String? _validateUsername(String? value) {
//   //   if (value == null || value.isEmpty) {
//   //     return 'Please enter a username';
//   //   }
//   //   if (value.length < 3) {
//   //     return 'Username must be at least 3 characters';
//   //   }
//   //   if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
//   //     return 'Username can only contain letters, numbers, and underscores';
//   //   }
//   //   return null;
//   // }

//   // String? _validateEmail(String? value) {
//   //   if (value == null || value.isEmpty) {
//   //     return 'Please enter your email';
//   //   }
//   //   if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
//   //     return 'Please enter a valid email';
//   //   }
//   //   return null;
//   // }

//   // String? _validatePassword(String? value) {
//   //   if (value == null || value.isEmpty) {
//   //     return 'Please enter a password';
//   //   }
//   //   if (value.length < 6) {
//   //     return 'Password must be at least 6 characters';
//   //   }
//   //   return null;
//   // }

//   // String? _validateConfirmPassword(String? value) {
//   //   if (value == null || value.isEmpty) {
//   //     return 'Please confirm your password';
//   //   }
//   //   if (value != _passwordController.text) {
//   //     return 'Passwords do not match';
//   //   }
//   //   return null;
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final authState = ref.watch(authProvider);
//     final authNotifier = ref.read(authProvider.notifier);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sign Up'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 32),
//                 // Image.asset(
//                 //   'assets/images/image copy.png',
//                 //   height: 150,
//                 //   width: 150,
//                 // ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Join BookHUB',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 32),
//                 TextFormField(
//                   controller: _usernameController,
//                   //validator: _validateUsername,
//                   decoration: const InputDecoration(
//                     labelText: 'Username',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.person),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   // validator: _validateEmail,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: !_isPasswordVisible,
//                   //validator: _validatePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: const OutlineInputBorder(),
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _confirmPasswordController,
//                   obscureText: !_isConfirmPasswordVisible,
//                   //   validator: _validateConfirmPassword,
//                   decoration: InputDecoration(
//                     labelText: 'Confirm Password',
//                     border: const OutlineInputBorder(),
//                     prefixIcon: const Icon(Icons.lock_outline),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isConfirmPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isConfirmPasswordVisible =
//                               !_isConfirmPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 if (authState.errorMessage != null)
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color:
//                           authState.errorMessage!.contains('check your email')
//                               ? Colors.green.shade50
//                               : Colors.red.shade50,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color:
//                             authState.errorMessage!.contains('check your email')
//                                 ? Colors.green.shade200
//                                 : Colors.red.shade200,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           authState.errorMessage!.contains('check your email')
//                               ? Icons.check_circle
//                               : Icons.error,
//                           color:
//                               authState.errorMessage!.contains(
//                                     'check your email',
//                                   )
//                                   ? Colors.green.shade600
//                                   : Colors.red.shade600,
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: Text(
//                             authState.errorMessage!,
//                             style: TextStyle(
//                               color:
//                                   authState.errorMessage!.contains(
//                                         'check your email',
//                                       )
//                                       ? Colors.green.shade700
//                                       : Colors.red.shade700,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: authState.isLoading ? null : _signUp,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child:
//                       authState.isLoading
//                           ? const SizedBox(
//                             height: 20,
//                             width: 20,
//                             child: CircularProgressIndicator(
//                               color: Colors.white,
//                               strokeWidth: 2,
//                             ),
//                           )
//                           : const Text(
//                             'Sign Up',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Already have an account? "),
//                     TextButton(
//                       onPressed: () {
//                         context.pop();
//                       },
//                       child: const Text(
//                         'Login',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 32),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



import 'package:bookhub_fullstack/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.isRegistering});
  final bool isRegistering;
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
     if (!isValid) {
      return;
    }
    final email = emailController.text;
    final username = usernameController.text;
    final password = passwordController.text;
    try {
      await supabase.auth.signUp(
          email: email, password: password, data: {'username': username});
          context.go("/login");
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      if(!mounted) return;
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Sign Up", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: formPadding,
          children: [
             Image.network(
             // "https://i.pinimg.com/originals/09/85/c0/0985c0ab4984a7ed5797195f14359cc2.gif",
              "https://i.pinimg.com/originals/e3/b7/ec/e3b7eccfc4e1132329e6e2639e95b447.gif",
              width: 200,
              height: 250,
              fit: BoxFit.fill,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 120),
            ),
            //Image.asset('assets/images/6343825.jpg', height: 250, width:250 ),
              SizedBox(height: 20,),
            //SizedBox(height: 100,),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Email",
                label: Text("email"),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            formSpacer,
             TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                label: Text('Password'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                if (val.length < 6) {
                  return '6 characters minimum';
                }
                return null;
              },
            ),
          formSpacer,
           TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                label: Text('Username'),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Required';
                }
                final isValid = RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(val);
                if (!isValid) {
                  return '3-24 long with alphanumeric or underscore';
                }
                return null;
              },
            ),
            formSpacer,
          ElevatedButton(onPressed: _isLoading? null: _signUp,
           child: Text("Register")),
           formSpacer,
           TextButton(onPressed: (){context.go("/login");}
           , child:Text("I already have an account"))
          ],
        ),
      ),
    );
  }
}
