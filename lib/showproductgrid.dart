import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//Method หลักทีRun
void main() {
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป

  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];
  Future<void> fetchProducts() async {
    try {
      // ดึงข้อมูลทั้งหมดจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สําหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });

        // เรียงข้อมูลตามราคาจากมากไปน้อย
        loadedProducts.sort((b, a) => b['price'].compareTo(a['price']));

        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print("จํานวนรายการสินค้าทั้งหมด: ${products.length} รายการ");
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล");
      }
    } catch (e) {
      print("Error loading products: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }
  

  ///////////////
  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd-MMMM-yyyy').format(parsedDate);
  }

//ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
                fetchProducts();
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());
    DateTime productionDate = DateTime.parse(product['productionDate']);
    TextEditingController productionDateController = TextEditingController(
        text: DateFormat('dd-MMMM-yyyy').format(productionDate));

    // ประเภทสินค้า: รายการตัวเลือก
    final List<Map<String, dynamic>> items1 = [
      {'name': 'Electronics', 'icon': Icons.devices},
      {'name': 'Clothing', 'icon': Icons.checkroom},
      {'name': 'Food', 'icon': Icons.fastfood},
      {'name': 'Books', 'icon': Icons.book},
    ];
    String selectedCategory = product['category'];

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: items1.map((item) {
                    return DropdownMenuItem<String>(
                      value: item['name'],
                      child: Row(
                        children: [
                          Icon(item['icon'], size: 24),
                          SizedBox(width: 8),
                          Text(item['name']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                GestureDetector(
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: productionDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (selectedDate != null) {
                      setState(() {
                        productionDate = selectedDate;
                        productionDateController.text =
                            DateFormat('dd-MMMM-yyyy').format(productionDate);
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: productionDateController,
                      decoration: InputDecoration(
                        labelText: 'วันที่ผลิต',
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // ข้อมูลใหม่ที่อัปเดต
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'quantity': int.parse(quantityController.text),
                  'category': selectedCategory,
                  'productionDate':
                      DateFormat('yyyy-MM-dd').format(productionDate),
                };
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts();
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // ปิด Dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    // ใช้ MediaQuery เพื่อดึงขนาดของหน้าจอ
    double screenWidth = MediaQuery.of(context).size.width;

    // คำนวณจำนวนคอลัมน์ (สามารถปรับตามความกว้างของหน้าจอ)
    int crossAxisCount = screenWidth < 600
        ? 2
        : 3; // ถ้าจอเล็กใช้ 2 คอลัมน์ ถ้าจอใหญ่ใช้ 3 คอลัมน์

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'แสดงข้อมูลสินค้า',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: const Color.fromARGB(255, 236, 156, 168),
        centerTitle: true,
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    crossAxisCount, // จำนวนคอลัมน์ที่คำนวณจากความกว้าง
                crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 5, // ระยะห่างระหว่างแถว
                childAspectRatio: 2 / 2, // อัตราส่วนกว้าง-ยาวของแต่ละ item
              ),
              itemCount: products.length,
              padding: const EdgeInsets.all(10), // กำหนด padding ของ GridView
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    // เมื่อกดที่แต่ละรายการ
                    print("Selected product: ${product['name']}");
                  },
                  child: Card(
                    elevation: 5, // ความสูงของเงา
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // ขอบมน
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(8.0), // ระยะห่างด้านในของ Card
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              product['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            'รายละเอียดสินค้า: ${product['description']}',
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(height: 8),
                          const Spacer(),
                          Center(
                            child: Text(
                              'ราคา: ${product['price']} บาท',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          Row(
                            children: [
                              // เพิ่ม Spacer เพื่อผลักไอคอนทั้งหมดไปทางขวา
                              Spacer(),
                              SizedBox(
                                width: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .blue[50], // พื้นหลังสีน้ำเงินอ่อน
                                    shape: BoxShape.circle, // รูปทรงวงกลม
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showEditProductDialog(product);
                                    },
                                    icon: Icon(Icons.edit),
                                    color: const Color.fromARGB(255, 25, 218, 105), // สีของไอคอน
                                    iconSize: 30,
                                    tooltip: 'แก้ไขสินค้า',
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                                    shape: BoxShape.circle, // รูปทรงวงกลม
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      showDeleteConfirmationDialog(
                                          product['key'],
                                          context); // เรียกใช้ฟังก์ชันลบ
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.red, // สีของไอคอน
                                    iconSize: 30,
                                    tooltip: 'ลบสินค้า',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
