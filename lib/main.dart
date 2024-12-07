import 'package:flutter/material.dart';
import 'package:task1/screens/home_screen.dart';
import 'services/notification_service.dart';

void main() 

async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const  MaterialApp(
      debugShowMaterialGrid: false,
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );}}
