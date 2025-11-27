import 'package:flutter/material.dart';
import 'screens/stress_screen.dart'; // Import screen custom

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Assessment',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      debugShowCheckedModeBanner: false, // Hilangkan debug banner merah
      home: const StressScreen(), // Mulai dari screen custom
      routes: {
        '/camera': (context) => const CameraScreen(),
      },
    );
  }
}

// Placeholder Camera Screen (bisa dipindah ke screens/camera_screen.dart kalo mau)
class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        backgroundColor: Colors.brown,
      ),
      body: const Center(
        child: Text(
          'Camera Screen Placeholder\n(Implement your camera logic here)',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}