import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {


  final String BaseUrl='http://localhost:300/usuario/login';

  Future<void>login(String usuario, String password,)async{
    final response=await http.post(Uri.parse(BaseUrl),
    headers: {'Content-Type': 'application/json'},
    body:json.encoder,
    );


     if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('role', data['role']);
    } else {
      throw Exception('Failed to login');
    }
  }
  }
