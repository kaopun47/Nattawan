import 'package:flutter/material.dart';

// รับข้อมูลสินค้าที่ส่งมา
class ProductDetail extends StatelessWidget {
  final Map<String, dynamic> product;

  ProductDetail({required this.product});

  @override
  
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
            Text(
              product['name'], // ใช้ชื่อสินค้าแทน "MENU MAIN"
              style: TextStyle(
                color: Colors.white, // เปลี่ยนสีข้อความเป็นสีขาว
                fontWeight: FontWeight.bold, // เพิ่มน้ำหนักตัวอักษร
                letterSpacing: 1.5, // เพิ่มระยะห่างระหว่างตัวอักษร
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 204, 9, 9),
        centerTitle: true,
        elevation: 5, // เพิ่มเงาให้ AppBar
        toolbarHeight: 70, // กำหนดความสูงของ AppBar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(50), // ปรับมุมล่างให้โค้งมน
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white), // เปลี่ยนสีไอคอน
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ชื่อสินค้า: ${product['name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'รายละเอียด: ${product['description']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'ราคา: ${product['price']} บาท',
              style: TextStyle(fontSize: 16,),
            ),
        
            SizedBox(height: 10),
            Text(
              'จำนวน: ${product['quantity']} ชิ้น',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
