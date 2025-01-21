import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onlineapp_nattawan/ShowProduct.dart';
import 'package:onlineapp_nattawan/showproducttype.dart';
import 'addproduct.dart';
import 'showproducttype.dart';
import 'showproductgrid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCjbHUDEm4SK8qf2ToAgxMk0Atl2fr3Tbo",
            authDomain: "onlinefirebase-382da.firebaseapp.com",
            databaseURL: "https://onlinefirebase-382da-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-382da",
            storageBucket: "onlinefirebase-382da.firebasestorage.app",
            messagingSenderId: "833009795615",
            appId: "1:833009795615:web:bda376bd710284c73e0b2a",
            measurementId: "G-GLFYPSCEH9"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 218, 11, 11)),
        useMaterial3: true,
      ),
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nattawan Shop',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 156, 168),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background1.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(height: 15),
                  _buildCustomButton(
                    context,
                    icon: Icons.inventory_2,
                    label: 'จัดการข้อมูลสินค้า',
                    gradientColors: [Colors.red, Colors.orange],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => addproduct(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  _buildCustomButton(
                    context,
                    icon: Icons.store_mall_directory,
                    label: 'แสดงข้อมูลสินค้า',
                    gradientColors: [Colors.blue, Colors.purple],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => showproductgrid(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  _buildCustomButton(
                    context,
                    icon: Icons.category,
                    label: 'ประเภทสินค้า',
                    gradientColors: [Colors.pink, Colors.teal],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => showproducttype(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required List<Color> gradientColors,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: 'Prompt',
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.symmetric(vertical: 18, horizontal: 32),
        ),
      ),
    );
  }
}
