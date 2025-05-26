
import 'package:bookhub_fullstack/widgets/constants.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }
  Future <void> _redirect() async{
    await Future.delayed(Duration.zero);

    final session = supabase.auth.currentSession;
    if(session ==null){
      context.go("/signup");
    }else{
      context.go("/top");
    }

}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: preloader,);
  }
}