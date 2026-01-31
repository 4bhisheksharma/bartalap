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
      body: const Center(
        child: Text(
          'Welcome to BARTALAP',
          style: TextStyle(color: MyAppTheme.mainFontColor),
        ),
      ),
    );
  }
}
