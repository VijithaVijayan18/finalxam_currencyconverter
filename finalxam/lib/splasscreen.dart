import 'package:flutter/material.dart';
import 'home.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //FlutterLogo(size: 100),
             Image(
              // image: AssetImage('assets/splash_icon.png'),
              image :NetworkImage('data:image/png;base64,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'),
               width: 100, height: 100, ),
            SizedBox(height: 20),
         ],
        ),
      ),
    );
  }
}
