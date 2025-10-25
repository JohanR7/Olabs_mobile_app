import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testing/api_connection.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  const Webview({Key? key}) : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("https://youtube.com"));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebViewWidget(
        controller: controller,
      ),
    );
  }
}

class ExperimentPagesDisplayCall extends StatefulWidget {
  final int subjectID;
  final int classID;
  final int experimentID;
  final int pageID;
  final String expName;
  final String expClassName;
  final String expSubjectName;

  const ExperimentPagesDisplayCall({
    Key? key,
    required this.subjectID,
    required this.classID,
    required this.experimentID,
    required this.pageID,
    required this.expName,
    required this.expClassName,
    required this.expSubjectName,
  }) : super(key: key);

  @override
  _ExperimentPagesDisplayCallState createState() =>
      _ExperimentPagesDisplayCallState();
}

class _ExperimentPagesDisplayCallState
    extends State<ExperimentPagesDisplayCall> {
  late final WebViewController _webViewController;
  String? selectedTabName;
  String currentUrl = "http://www.youtube.com/watch?v=B1VKTniLEGk"; 

  @override
  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);

    fetchExperimentLinks(widget.experimentID).then((links) {
      if (links.isNotEmpty) {
        setState(() {
          selectedTabName = links.first['experiment_tab_Name'];
        });
        _webViewController.loadRequest(
          Uri.parse(links.first['experiment_tab_Link']!),
        );
      } else {
        debugPrint('No links available to load');
      }
    }).catchError((e) {
      debugPrint('Error fetching experiment links: $e');
    });
  }


  Future<List<Map<String, String>>> fetchExperimentLinks(int experimentID) async {
    final Map<String, dynamic> body = {
      "sub":3,
      "brch":3,
      "sim": experimentID,
      "cnt":12
    };

    try {
      final response = await http.post(
        Uri.parse(API.getExperimentTabLinks),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) {
          return {
            "experiment_tab_Name": item['experiment_tab_Name'] as String,
            "experiment_tab_Link": item['experiment_tab_Link'] as String,
          };
        }).toList();
      } else {
        debugPrint('API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return [];
    }
  }



  Future<String?> fetchClassName(String subjectID) async {
    final Map<String, dynamic> body = {
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
        final res = jsonDecode(response.body);
        if (res['success'] == true) {
          return res['subject_name']; 
        } else {
          return "Unknown Subject";
        }
      } else {
        debugPrint('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception occurred: $e');
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String?>(
                  future: fetchClassName(widget.expSubjectName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFb90e50), 
                          borderRadius: BorderRadius.circular(8.0), 
                        ),
                        padding: const EdgeInsets.all(8.0), 
                        child: Text(
                          "${snapshot.data ?? 'No Subject'} - ${widget.expClassName}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFffffff),
                          ),
                        ),
                      );


                    }
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  widget.expName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FutureBuilder<List<Map<String, String>>>(
                      future: fetchExperimentLinks(widget.experimentID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text(
                            'Error loading links',
                            style: TextStyle(color: Colors.red),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Text('No links available');
                        } else {
                          final links = snapshot.data!;
                          return Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              decoration: BoxDecoration(
                                color: const Color(0xffffb7d9),
                                borderRadius: BorderRadius.circular(8.0), 
                              ),
                              child: DropdownButton<String>(
                                value: selectedTabName, 
                                hint: const Text(
                                  "Select an option", 
                                  style: TextStyle(color: Color(0xffffffff)),
                                ),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedTabName = newValue; 
                                  });
                                  if (newValue != null) {
                                    final selectedLink = links.firstWhere(
                                          (link) => link['experiment_tab_Name'] == newValue,
                                    );
                                    print(selectedLink['experiment_tab_Link']);
                                    _webViewController.loadRequest(
                                      Uri.parse(selectedLink['experiment_tab_Link']!),
                                    );
                                  }
                                },
                                isExpanded: true,
                                underline: Container(),
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: const Color(0xFF000000),
                                  fontSize: 16.0,
                                ),
                                items: links.isNotEmpty
                                    ? links.map((link) {
                                  return DropdownMenuItem<String>(
                                    value: link['experiment_tab_Name'],
                                    child: Text(
                                      link['experiment_tab_Name']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                  );
                                }).toList()
                                    : [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      "No options available",
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );



                        }
                      },
                    ),
                  ],
                ),


                const SizedBox(height: 32),
                Expanded(
                  child: WebViewWidget(
                    controller: _webViewController,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                splashRadius: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
