import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/app/data/models/product_model.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  ProductsView({Key? key}) : super(key: key);

  final colorUi = const Color.fromARGB(255, 195, 255, 147);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BARANG', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Barang masih kosong", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            );
          }

          List<ProductModel> allProduct = [];

          for (var element in snapshot.data!.docs) {
            allProduct.add(ProductModel.fromJson(element.data()));
          }

          return ListView.builder(
            itemCount: allProduct.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              ProductModel product = allProduct[index];

              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.detailProduct, arguments: product),
                  borderRadius: BorderRadius.circular(9),
                  child: Container(
                    height: 140,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Status Barang : ${product.status}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Nama Barang : ${product.name}", style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              Text("Jenis Barang : ${product.category}", style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: QrImageView(
                            data: product.code,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          
            },
          );
        }
      )
    );
  }
}
