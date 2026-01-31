import 'package:bartalap/screens/home_screen.dart';
import 'package:bartalap/theme/my_app_theme.dart';
import 'package:flutter/material.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "B A R T A L A P",
      theme: ThemeData.light(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: MyAppTheme.blackColor,
        appBarTheme: AppBarTheme(
          backgroundColor: MyAppTheme.blackColor,
          elevation: 0,
        ),
      ),
      home: HomeScreen(),
    );
  }
}
