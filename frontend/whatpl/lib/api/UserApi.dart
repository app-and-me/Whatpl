import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserApi {
    User? user = FirebaseAuth.instance.currentUser;

  Future<Map<String, dynamic>> getUserById(String uid) async {
    final url = Uri.parse('https://localhost:3000/api/user/$uid');
    final idToken = await user?.getIdToken();  
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> deleteUser() async {
    final url = Uri.parse('https://localhost:3000/api/user/${user?.uid}');
    final idToken = await user?.getIdToken();  
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return {'error': 'User not found'};
    }
  }

  Future<http.Response> createUser(String displayName, String profilePicture, String birthDate, String gender) async {
    final url = Uri.parse('https://localhost:3000/api/user');
    final idToken = await user?.getIdToken();  
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: '''{
              "displayName" : "$displayName",
              "profilePicture" : "$profilePicture",
              "email" : "${user?.email}",
              "birthDate" : "${DateFormat('yyyy.MM.dd').parse(birthDate).toIso8601String()}",
              "gender" : "${gender == '남자' ? 'male' : 'other'}"
            }'''
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<http.Response> updateUser(String displayName, String birthDate, String gender) async {
    final url = Uri.parse('https://localhost:3000/api/user/${user?.uid}');
    final idToken = await user?.getIdToken();  
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $idToken',
      },
      body: '''{
              "displayName" : "$displayName",
              "birthDate" : "${DateFormat('yyyy.MM.dd').parse(birthDate).toIso8601String()}",
              "gender" : "${gender == '남자' ? 'male' : 'other'}"
            }'''
    );

    if (response.statusCode == 201) {
      return response;
    } else {
      throw Exception('Failed to update user');
    }
  }
}