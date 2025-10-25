import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:testing/api_connection.dart';

class api_requests_and_responses {
  Future<dynamic> post(String url, { body, encoding}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );
    final String res = response.body;
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw Exception("Error while fetching data");
    }
    print('resopo..>.2$res');
  }




}