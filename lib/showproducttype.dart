import 'package:flutter/material.dart';
import 'showfiltertype.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 6, 146, 53)),
        useMaterial3: true,
      ),
      home: showproducttype(),
    );
  }
}

class showproducttype extends StatefulWidget {
  @override
  State<showproducttype> createState() => _ShowProductTypeState();
}

class _ShowProductTypeState extends State<showproducttype> {
  final List<Map<String, dynamic>> items1 = [
    {
      'name': 'Electronics',
      'icon': Icons.devices, // ไอคอนสำหรับ Electronics
    },
    {
      'name': 'Clothing',
      'icon': Icons.checkroom, // ไอคอนสำหรับ Clothing
    },
    {
      'name': 'Food',
      'icon': Icons.fastfood, // ไอคอนสำหรับ Food
    },
    {
      'name': 'Books',
      'icon': Icons.book, // ไอคอนสำหรับ Books
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประเภทของสินค้า',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 9, 9),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: items1.length,
                itemBuilder: (context, index) {
                  final item = items1[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowFilterType(
                            category: item['name'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                           const Color.fromARGB(255, 179, 9, 9),
                            const Color.fromARGB(255, 179, 9, 9)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item['icon'], // ใช้ไอคอนที่กำหนดใน items1
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            item['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
