import 'package:flutter/material.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(UserManagementApp());
}

class UserManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Management',
      home: UserListScreen(),
    );
  }
}
