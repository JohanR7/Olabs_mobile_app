import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testing/api_connection.dart';
import 'package:testing/homeScreen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const CircleScreen(),
    );
  }
}

class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  _CircleScreenState createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  SecondScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF36ccee),
      body: Center(
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: 200,
              child: CircleWidget(color: const Color(0xFFc9eefa), size: 350),
            ),
            Positioned(
              top: -200,
              left: -150,
              child: CircleWidget(color: const Color(0xFF36b9ee), size: 500),
            ),
            Positioned(
              top: 700,
              left: -400,
              child: CircleWidget(color: const Color(0xFFffcf54), size: 800),
            ),
            Center(
              child: Text(
                'OLABS',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0.5, 0.5),
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircleWidget extends StatelessWidget {
  final Color color;
  final double size;
  const CircleWidget({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  SecondScreen({super.key});
  var formKey = GlobalKey<FormState>();

  Future<String?> callTheApiMethod(String email,String password) async {
    print("Email =================> "+email);
    print("Password =================> "+password);
    Map<String, dynamic> body = {
      "user_name": email,
      "user_password": password,
    };
    // String jsonString = jsonEncode(body);

    try {
      print("response");
      final response = await http.post(
        Uri.parse(API.signUp),
        body: jsonEncode(body), // Example data
      );
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print('API Response: ${res['success']}');
        if(!res['success'])
        {
          return "false";
        }
        else{
          print('API Success: ${response.statusCode}');
          return "Success";
        }
      } else {
        print('API Error: ${response.statusCode}');
        return "Exception";
      }
    } catch (e) {
      print('Exception occurred: $e');
      return "Exception";
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController _textInputControllerEmail = TextEditingController();
    TextEditingController _textInputControllerPassword = TextEditingController();
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Stack(
        children: [
          Positioned(
            top: -110,
            left: 140,
            child: CircleWidget(color: const Color(0xFFc9eefa), size: 500),
          ),
          Positioned(
            top: -350,
            left: -200,
            child: CircleWidget(color: const Color(0xFF36b9ee), size: 700),
          ),
          Positioned(
            top: -100,
            left: -80,
            child: CircleWidget(color: const Color(0xFFffcf54), size: 250),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            top: 220,
            left: 50,
            right: 50,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Welcome\n",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "Back to OLABS!",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    TextField(
                      controller: _textInputControllerPassword,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 60),
                    TextField(
                      controller: _textInputControllerEmail,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.grey),
                        border: UnderlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 70),
                    TextButton(
                      onPressed: () {

                        // Add sign-in logic here
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Color(0xFF353535),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 360,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () async {
                      var email = _textInputControllerEmail.text;
                      var password = _textInputControllerPassword.text;

                      print(email);
                      print(password);
                      String? result = await callTheApiMethod(email.toString(), password.toString());
                      print(result);
                      if (result == "false") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid username or password'), 
                            duration: const Duration(seconds: 3), 
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                              },
                            ),
                          ),
                        );
                      }
                      else if(result == "Exception"){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Something went wrong'), 
                            duration: const Duration(seconds: 3), 
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                              },
                            ),
                          ),
                        );
                      }

                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Login success, Please wait..."), 
                            duration: const Duration(seconds: 3), 
                            action: SnackBarAction(
                              label: '',
                              onPressed: () {
                              },
                            ),
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondPage(data: 'Hello from First Page')),
                          );
                        });
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xFF353535),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),

              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 50,
            right: 50,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SecondPage(data: 'Hello from First Page'),
                          ),
                        );
                      },
                      child: const Text(
                        "Continue \nas guest",
                        style: TextStyle(
                          color: Color(0xFF353535),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                      },
                      child: const Text(
                        "Sign\nUp",
                        style: TextStyle(
                          color: Color(0xFF353535),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                      },
                      child: const Text(
                        "Forgot\nPassword",
                        style: TextStyle(
                          color: Color(0xFF353535),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}