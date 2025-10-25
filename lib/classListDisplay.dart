import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; 
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testing/api_connection.dart';
import 'package:testing/homeScreen.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:testing/explistdisplay.dart';

class classListDisplay extends StatelessWidget {
  final String data; 
  const classListDisplay({super.key, required this.data});

  Future<String?> fetchClassName(String subjectID) async {
    Map<String, dynamic> body = {
      "subject_id": subjectID,
    };

    try {
      final response = await http.post(
        Uri.parse(API.getClassNames),
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        if (res['success'] == true) {
          return res['subject_name']; 
        } else {
          return "Unknown Subject";
        }
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception occurred: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String?>(
          future: fetchClassName(data), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                style: TextStyle(fontSize: 26),
              );
            } else if (snapshot.hasError) {
              return const Text(
                'Error',
                style: TextStyle(fontSize: 26),
              );
            } else {
              return Text(
                snapshot.data ?? 'No Subject', 
                style: const TextStyle(fontSize: 26),
              );
            }
          },
        ),

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<dynamic>?>(
        future: ClassFetchAPI(data),
        builder: (context, snapshot) {
          print("Data is: $snapshot");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No classes available'));
          } else {
            List<dynamic> extractedValues = snapshot.data!;

            return Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: SingleChildScrollView(  
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: extractedValues.map((item) {
                          String enIn = item['enIn'];
                          int topicId = item['topicId'];
                          String dataClass = data;
                          return Column(
                            children: [
                              _buildClassButton(
                                context,
                                enIn, 
                                dataClass,
                                topicId,
                                getRandomColor(),
                                getRandomShape(),
                                getRandomShape(),
                              ),
                              SizedBox(height: screenHeight * 0.02),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
  Color getRandomColor() {
    final List<Color> colorArray = [
      Color(0xFFb90e50),
    ];

    Random random = Random();
    return colorArray[random.nextInt(colorArray.length)];
  }
  IconData getRandomShape() {
    final List<String> shapeArray = [
      "square",
      "circle",
      "triangle",
      "rectangle",
      "star",
      "diamond",
      "hexagon",
      "pentagon",
      "heart",
      "arrow",
      "cloud",
    ];

    Random random = Random();
    String shapeName = shapeArray[random.nextInt(shapeArray.length)];

    Map<String, IconData> shapeIcons = {
      "square": Icons.crop_square,
      "circle": Icons.circle,
      "triangle": Icons.change_history,
      "rectangle": Icons.crop_landscape, 
      "star": Icons.star,
      "diamond": Icons.diamond, 
      "hexagon": Icons.hexagon, 
      "pentagon": Icons.pentagon, 
      "heart": Icons.favorite,
      "arrow": Icons.arrow_upward, 
      "cloud": Icons.cloud, 
    };

    return shapeIcons[shapeName] ?? Icons.help_outline; 
  }
  Widget _buildClassButton(BuildContext context, String label,String dataClass, int label2, Color color, IconData shapeNameLeft, IconData shapeNameRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonHeight = screenWidth * 0.25;
    final iconSize = screenWidth * 0.15;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
          ),
          width: double.infinity,
          height: buttonHeight,
        ),
        Positioned(
          top: 5,
          left: 5,
          child: Icon(
            shapeNameLeft,
            size: iconSize,
            color: Colors.white54,
          ),
        ),
        Positioned(
          bottom: 5,
          right: 5,
          child: Icon(
            shapeNameRight,
            size: iconSize,
            color: Colors.white54,
          ),
        ),
        Center(
          child: SizedBox(
            width: double.infinity,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ExperimentListDisplay(data: label, dataClass: label2,classId: dataClass,subjectName:data)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Future<List<dynamic>?> ClassFetchAPI(String subjectID) async {
  print("Class id =================> $subjectID");

  Map<String, dynamic> body = {
    "subject_id": subjectID,
  };

  try {
    print("Making request...");
    final response = await http.post(
      Uri.parse(API.getClassNames),
      body: jsonEncode(body),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var res = jsonDecode(response.body);
      print('API Response: $res');

      if (res['success'] == true) {
        List<dynamic> data = res['data'];

        List<dynamic> extractedValues = data.map((item) {
          return {
            'enIn': item['en-IN']?.toString() ?? '', 
            'topicId': item['topic_id'] != null
                ? int.tryParse(item['topic_id'].toString()) ?? 0
                : 0, 
          };
        }).toList();

        print('Extracted Values: $extractedValues');
        return extractedValues.isNotEmpty ? extractedValues : [];
      } else {
        print('API response indicates failure.');
        return [];
      }
    } else {
      print('API Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Exception occurred: $e');
    return null;
  }
}