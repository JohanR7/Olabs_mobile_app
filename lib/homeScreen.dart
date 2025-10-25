import 'package:flutter/material.dart';
import 'package:testing/classListDisplay.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatefulWidget {
  final String data;

  const SecondPage({Key? key, required this.data}) : super(key: key);

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with interactive simulation text
            Stack(
              children: [
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    color: Color(0xFF36B9EE),
                  ),
                ),
                // White-line icon in the top-left corner
                Positioned(
                  top: 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 4,
                        width: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 30,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 25,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 20,
                  right: -50,
                  child: CircleWidget(color: const Color(0xFFc9eefa), size: 150),
                ),
                Positioned(
                  top: 120,
                  left: -50,
                  child: CircleWidget(color: const Color(0xFFFFCF54), size: 200),
                ),
                // Full-width dynamic-height container
                Positioned(
                  top: 80,
                  left: MediaQuery.of(context).size.width * 0.1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Interactive',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Simulation',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Action for Explore Now button
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Explore Now',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Image on the right with adjusted top position
                Positioned(
                  top: 40,
                  left: 130,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset(
                      'assets/homeimage.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Choose Your Lab",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: screenWidth > 400 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  LabOption(
                    imagePath: 'assets/physics.png',
                    label: 'Physics',
                    onPressed: () {
                      print("Physics");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '1')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/chemistry.png',
                    label: 'Chemistry',
                    onPressed: () {
                      print("Chemistry");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '73')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/biology.png',
                    label: 'Biology',
                    onPressed: () {
                      print("Biology");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '79')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/maths.png',
                    label: 'Science',
                    onPressed: () {
                      print("Science");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '96')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/english.png',
                    label: 'Computer',
                    onPressed: () {
                      print("Computer");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '97')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/arvr.png',
                    label: '3D/AR/VR',
                    onPressed: () {
                      print("3D/AR/VR");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '112')),
                      );
                    },
                  ),
                  LabOption(
                    imagePath: 'assets/social.png',
                    label: 'EDP',
                    onPressed: () {
                      print("EDP");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => classListDisplay(data: '151')),
                      );
                    },
                  ),
                ],
              ),
            ),
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
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class LabOption extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const LabOption({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            shadowColor: Colors.grey.withOpacity(0.3),
            elevation: 6,
            padding: const EdgeInsets.all(16),
          ),
          child: Image.asset(
            imagePath,
            width: 60,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
