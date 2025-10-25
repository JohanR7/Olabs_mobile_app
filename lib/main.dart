import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testing/api_connection.dart';
import 'loginpage.dart';
void main() {
  runApp(
    DevicePreview(

      builder: (context)=>

      MyApp()
  ));
}