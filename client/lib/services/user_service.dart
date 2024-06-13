import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://localhost:8080/users';
  Future<List<dynamic>> getUsers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body) as List<dynamic>;
        print('Users retrieved successfully: $users');
        return users;
      } else {
        throw Exception('Failed to load users: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to load users: $e');
      throw Exception('Failed to load users: $e');
    }
  }

  Future<void> createUser(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );
      if (response.statusCode == 201) {
        print('User created successfully');
      } else {
        throw Exception('Failed to create user: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to create user: $e');
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(int id, String name, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email}),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('User updated successfully');
        }
      } else {
        throw Exception('Failed to update user: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Failed to update user: $e');
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else {
        throw Exception('Failed to delete user: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to delete user: $e');
      }
      throw Exception('Failed to delete user: $e');
    }
  }
}
