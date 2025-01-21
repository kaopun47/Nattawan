import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart'; // เพิ่ม import สำหรับ intl package
import 'ProductDetail.dart'; // นำเข้า ProductDetail

class ShowFilterType extends StatefulWidget {
  final String category; // รับข้อมูลประเภทสินค้า

  // Constructor รับข้อมูลประเภทสินค้า
  ShowFilterType({required this.category});

  @override
  showfiltertype createState() => showfiltertype();
}

class showfiltertype extends State<ShowFilterType> {
  late DatabaseReference _productRef;
  late List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productRef = FirebaseDatabase.instance
        .ref('products'); // อ้างอิงถึงฐานข้อมูลใน Firebase
    _fetchProducts();
  }

  // ฟังก์ชันในการแปลงวันที่
  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MMMM-yyyy')
        .format(parsedDate); // แปลงเป็นวันที่ในรูปแบบ dd-MMMM-yyyy
  }

  Future<void> _fetchProducts() async {
    try {
      // ดึงข้อมูลทั้งหมดจาก Firebase
      DataSnapshot snapshot = await _productRef.get();
      if (snapshot.exists) {
        final List<Map<String, dynamic>> allProducts = [];
        final Map<dynamic, dynamic> productsData =
            snapshot.value as Map<dynamic, dynamic>;

        // แปลงข้อมูลจาก Firebase เป็น List<Map>
        productsData.forEach((key, value) {
          allProducts.add({
            'name': value['name'],
            'category': value['category'],
            'price': value['price'],
            'quantity': value['quantity'],
            'description': value['description'],
            'productionDate': value['productionDate'],
          });
        });

        // กรองข้อมูลสินค้าตามประเภทที่เลือก
        setState(() {
          _filteredProducts = allProducts
              .where((product) => product['category'] == widget.category)
              .toList();
        });
      } else {
        print('No data available.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              'สินค้า', // แสดงประเภทสินค้าใน AppBar
              style: TextStyle(
                color: Colors.white, // เปลี่ยนสีข้อความเป็นสีขาว
                fontWeight: FontWeight.bold, // เพิ่มน้ำหนักตัวอักษร
                letterSpacing: 1.5, // เพิ่มระยะห่างระหว่างตัวอักษร
              ),
            ),
          ],
        ),
        centerTitle: true, // จัดตำแหน่งข้อความตรงกลาง
        backgroundColor: const Color.fromARGB(255, 53, 158, 11), // กำหนดสีพื้นหลัง
        elevation: 5, // เพิ่มเงาให้ AppBar
        toolbarHeight: 70, // กำหนดความสูงของ AppBar
        iconTheme: IconThemeData(color: Colors.white), // เปลี่ยนสีไอคอน
      ),
      body: _filteredProducts.isEmpty
          ? Center(
              child:
                  CircularProgressIndicator()) // แสดง loading indicator หากยังไม่ได้ข้อมูล
          : ListView.builder(
              itemCount: _filteredProducts.length,
              itemBuilder: (context, index) {
                final product = _filteredProducts[index];
                return Card(
                  margin: const EdgeInsets.all(8.0), // กำหนดระยะห่างรอบๆ Card
                  child: ListTile(
                    title: Text(
                      product['name'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold), // ทำให้ชื่อสินค้าดูเด่น
                    ),
                    subtitle: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // ทำให้ข้อความชิดซ้าย
                      children: [
                        Text('รายละเอียดสินค้า: ${product['description']}'),
                        Row(
                          children: [
                            Text(
                                'วันที่ผลิต: ${formatDate(product['productionDate'])}'), // ใช้ฟังก์ชัน formatDate
                            SizedBox(width: 20), // เว้นระยะห่าง
                            Text('จำนวน: ${product['quantity']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      'ราคา: ${product['price']} บาท',
                      style: TextStyle(), // ใช้สีเขียวสำหรับราคา
                    ),
                    onTap: () {
                      // นำทางไปยังหน้ารายละเอียดสินค้าและส่งข้อมูลสินค้าไป
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetail(product: product)
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
