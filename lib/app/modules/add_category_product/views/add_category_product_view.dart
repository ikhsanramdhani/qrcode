import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_category_product_controller.dart';

class AddCategoryProductView extends GetView<AddCategoryProductController> {
  AddCategoryProductView({Key? key}) : super(key: key);
  final colorUi = const Color.fromARGB(255, 195, 255, 147);
  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAMBAH JENIS BARANG', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
            TextField(
              autocorrect: false,
              controller: name,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Jenis Barang",
                labelStyle: const TextStyle(fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(9)
                )
              ),
          ),
          const SizedBox(height: 35),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorUi,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9)
              ),
              padding: const EdgeInsets.symmetric(vertical: 20)
            ),
            onPressed: () async {

              if (controller.isLoading.isFalse) {
                
                if (name.text.isNotEmpty) {

                  controller.isLoading(true);

                  Map<String, dynamic> res = await controller.addCategoryProduct(name.text.toUpperCase());
                  controller.isLoading(false);

                  if (!res['error']) {
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Tambah Jenis Barang")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jenis Barang Sudah Ada")));
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Jenis Barang harus di isi")));
                }

              }

            }, 
            child: Text("TAMBAH", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          )
        ]
      )
    );
  }
}
