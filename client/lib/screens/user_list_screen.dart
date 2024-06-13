import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../components/user_form_dialog.dart';
class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserService _userService = UserService();
  List<User> _users = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      final users = await _userService.getUsers();
      setState(() {
        _users = users.map((json) => User.fromJson(json)).toList();
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load users: $e';
      });
      if (kDebugMode) {
        print('Failed to load users: $e');
      }
    }
  }

  Future<void> _createUser(User user) async {
    try {
      await _userService.createUser(user.name, user.email);
      _fetchUsers();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create user: $e';
      });
      if (kDebugMode) {
        print('Failed to create user: $e');
      }
    }
  }

  Future<void> _updateUser(User user) async {
    try {
      await _userService.updateUser(user.id!, user.name, user.email);
      _fetchUsers();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update user: $e';
      });
      if (kDebugMode) {
        print('Failed to update user: $e');
      }
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await _userService.deleteUser(id);
      _fetchUsers();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to delete user: $e';
      });
      if (kDebugMode) {
        print('Failed to delete user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Management',
          style: TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: _buildUserList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<User?>(
            context: context,
            builder: (BuildContext context) => UserFormDialog(),
          );
          if (result != null) {
            _createUser(result);
          }
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildUserList() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            _errorMessage,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else if (_users.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                user.name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final updatedUser = await showDialog<User?>(
                        context: context,
                        builder: (BuildContext context) => UserFormDialog(user: user),
                      );
                      if (updatedUser != null) {
                        _updateUser(updatedUser);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id!),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
