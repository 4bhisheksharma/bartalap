import 'package:bartalap/screens/login_screen.dart';
import 'package:bartalap/screens/chat_screen.dart';
import 'package:bartalap/theme/my_app_theme.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<User>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: MyAppTheme.whiteColor),
            onPressed: navigateToNextScreen,
          ),
        ],
        automaticallyImplyLeading: false,
        title: const Text(
          'Bartalap Dashboard',
          style: TextStyle(color: MyAppTheme.whiteColor),
        ),
        backgroundColor: MyAppTheme.mainFontColor,
      ),
      body: FutureBuilder<List<User>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: MyAppTheme.mainFontColor),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: MyAppTheme.whiteColor),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No users found',
                style: TextStyle(color: MyAppTheme.whiteColor),
              ),
            );
          }
          final users = snapshot.data!;
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => Divider(color: MyAppTheme.borderColor),
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: MyAppTheme.assistantCircleColor,
                  child: Text(
                    user.username[0].toUpperCase(),
                    style: TextStyle(color: MyAppTheme.blackColor),
                  ),
                ),
                title: Text(
                  user.username,
                  style: TextStyle(color: MyAppTheme.whiteColor),
                ),
                subtitle: Text(
                  'User ID: ${user.id}',
                  style: TextStyle(color: MyAppTheme.whiteColor),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatScreen(peerUser: user),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void navigateToNextScreen() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
