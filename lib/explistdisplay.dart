import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math'; // Import for random number generation
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:testing/api_connection.dart';
import 'package:testing/homeScreen.dart';
import 'package:testing/experimentContents.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ExperimentListDisplay extends StatefulWidget {
  final String data; // Final variable to store the passed data
  final int dataClass; // Final variable to store the passed data
  final String classId;
  final String subjectName;

  const ExperimentListDisplay(
      {super.key, required this.data, required this.dataClass, required this.classId, required this.subjectName});

  @override
  _ExperimentListDisplayState createState() => _ExperimentListDisplayState();
}

class _ExperimentListDisplayState extends State<ExperimentListDisplay> {
  late Future<List<Map<String, dynamic>>> _experiments;
  List<Map<String, dynamic>> _filteredExperiments = []; // For filtered experiments

  // Fetch data function
  Future<List<Map<String, dynamic>>> fetchExperimentName(String subjectID, String classId) async {
    print("subjectID " + subjectID);
    print("classId " + classId);
    Map<String, dynamic> body = {
      "subject_id": subjectID,
      "class_id": classId,
    };

    try {
      // Adjust this URL to the correct endpoint
      final response = await http.post(
        Uri.parse(API.getExperimentNames), // Replace with your actual API URL
        body: jsonEncode(body),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // Checking the response
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception occurred: $e');
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _experiments = fetchExperimentName(widget.dataClass.toString(), widget.classId);
    _experiments.then((value) {
      setState(() {
        _filteredExperiments = value; // Initialize filtered list
      });
    });
  }

  void _filterExperiments(String query) {
    if (query.isEmpty) {
      _experiments.then((value) {
        setState(() {
          _filteredExperiments = value;
        });
      });
    } else {
      setState(() {
        _filteredExperiments = _filteredExperiments
            .where((experiment) => experiment['experiment_name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.data,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF9F9F9),
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Search bar at the top
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search experiments...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                onChanged: (value) {
                  _filterExperiments(value); // Call filter method on input change
                },
              ),
            ),
            // FutureBuilder and ListView
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _experiments,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No experiments available.'));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredExperiments.length,
                      itemBuilder: (context, index) {
                        final experiment = _filteredExperiments[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: GestureDetector(
                            onTap: () {
                              print("================CLICKED EXPERIMENT=================");
                              print("Experiment subject: ${widget.classId}");
                              print("Experiment class: ${widget.dataClass}");
                              print("Experiment id: ${experiment['experiment_id']}");
                              print("Experiment tab id: ${experiment['tabid']}");
                              print("Experiment name: ${experiment['experiment_name']}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExperimentPagesDisplayCall(
                                    subjectID: int.parse(widget.classId),
                                    classID: int.parse(widget.classId),
                                    experimentID: int.parse(experiment['experiment_id'].toString()),
                                    pageID: int.parse(experiment['tabid'].toString()),
                                    expName: experiment['experiment_name'],
                                    expClassName: widget.data,
                                    expSubjectName: widget.subjectName,
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffeef7fb),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      experiment['experiment_name'] ?? 'No name available',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
