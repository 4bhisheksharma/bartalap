import 'package:bartalap/screens/login_screen.dart';
import 'package:bartalap/theme/my_app_theme.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home Screen',
          style: TextStyle(color: MyAppTheme.mainFontColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Welcome to BARTALAP!',
              style: TextStyle(
                color: MyAppTheme.whiteColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              navigateToNextScreen();
            },
            child: const Text('Get Started'),
          ),
        ],
      ),
    );
  }

  void navigateToNextScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
