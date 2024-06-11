import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/data/models/category_product_model.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/category_product_controller.dart';

class CategoryProductView extends GetView<CategoryProductController> {
  const CategoryProductView({Key? key}) : super(key: key);

  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  const Text('JENIS BARANG', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.addCategoryProduct), icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamCategoryProducts(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
 
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Jenis Barang masih kosong", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            );
          }

          List<CategoryProductModel> allCategoryProduct = [];

          for (var element in snapshot.data!.docs) {
            print("element : ${element.data()}");
            allCategoryProduct.add(CategoryProductModel.fromJson(element.data()));
          }

          return ListView.builder(
            itemCount: allCategoryProduct.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              CategoryProductModel model = allCategoryProduct[index];

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height / 10,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(model.name.toUpperCase(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        )
                      ),
                      IconButton(
                        onPressed: () {

                          Get.defaultDialog(
                            title: "Hapus Jenis Barang",
                            middleText: "Apakah kamu yakin untuk hapus jenis barang ini?",
                            actions: [
                              OutlinedButton(onPressed: () => Get.back(), child: const Text("TIDAK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[600],
                                ),
                                onPressed: () async {

                                  Map<String, dynamic> res = await controller.deleteCategoryProduct(model.name.toUpperCase());
                                  Get.back();

                                  if (!res['error']) {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Hapus Jenis Barang")));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Hapus Jenis Barang")));
                                  }

                                }, 
                                child: const Text("HAPUS", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                              )
                            ]
                          );

                        }, 
                        padding: const EdgeInsets.fromLTRB(0, -10, 0, 0),
                        icon: const Icon(Icons.delete)
                      )
                    ],
                  ),
                )
              );

            },
          );

        },
      )
    );
  }
}
