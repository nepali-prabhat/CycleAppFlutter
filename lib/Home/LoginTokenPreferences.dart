import 'dart:io';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginCredentials {
  final String LoginURL = 'http://192.168.254.4:3000/login';

  Future<Map<String, dynamic>> authenticate(
      {@required String username, @required String password}) async {
    var client = new http.Client();

    try {
      var response = await client.post(
        LoginURL,
//headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"}
        body: {'username': username, 'password': password},
      );
      // headers: {HttpHeaders.authorizationHeader: await retrieveToken()});

      // check if status code is not greater than 300
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw (jsonDecode(response.body));
      }
    } catch (error) {
      return error;
    }
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<void> persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    return;
  }

  Future<String> retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
