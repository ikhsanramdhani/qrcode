import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/app/data/models/category_product_model.dart';
import 'package:qrcode/app/data/models/product_model.dart';
import 'package:qrcode/app/data/models/user_model.dart';
import 'package:qrcode/app/modules/category_product/controllers/category_product_controller.dart';
import 'package:qrcode/app/modules/users/controllers/users_controller.dart';

import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DetailProductFull();
  }
}

class DetailProductFull extends StatefulWidget {
  const DetailProductFull({super.key});

  @override
  State<DetailProductFull> createState() => _DetailProductFullState();
}

class _DetailProductFullState extends State<DetailProductFull> {

  final colorUi = const Color.fromARGB(255, 195, 255, 147);
  final sizedbox = const SizedBox(height: 20);

  final DetailProductController detailCtrl = DetailProductController();
  final UsersController userCtrl = UsersController();
  final CategoryProductController categoryProductController = CategoryProductController();

  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController nipCtrl = TextEditingController();

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController nameCtrl2 = TextEditingController(
    text: "name_2"
  );

  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController specCtrl = TextEditingController();
  final TextEditingController statusCtrl = TextEditingController();

  String? userNipSelected;
  String userNipSelected2 = '';

  String? categoryProductSelected;
  String categoryProductSelected2 = '';

  String? statusProductSelected;
  String statusProductSelected2 = '';

  final List<String> _statusProduct = ["Disimpan", "Rusak", "Dipakai"];
  final ProductModel product = Get.arguments;
  
  @override
  Widget build(BuildContext context) {

    codeCtrl.text = product.code;
    userNipSelected = product.nip;

    nameCtrl.text = product.name;

    categoryProductSelected = product.category;
    specCtrl.text = product.spec;

    statusProductSelected = product.status;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('KETERANGAN BARANG', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: userCtrl.streamUsers(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<UserModel> _allUser = [];
          
          for (var element in snapshot.data!.docs) {
             _allUser.add(UserModel.fromJson(element.data()));
          }

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: QrImageView(
                      data: product.code,
                      size: 200.0,
                      version: QrVersions.auto,
                    ),
                  ),
                ],
              ),
              sizedbox,
              TextField(
                autocorrect: false,
                controller: codeCtrl,
                keyboardType: TextInputType.text,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Kode Barang",
                  counterText: "*Kode Barang tidak bisa diubah",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              sizedbox,
              DropdownButtonFormField<String>(
                  value: userNipSelected2.isEmpty ? userNipSelected : userNipSelected2,
                  items: _allUser.map((UserModel user) {
                    return DropdownMenuItem<String>(
                      value: user.nip,
                      child: Text(user.nip)
                    );
                  }).toList(), 
                  onChanged: (String? userNip) {
                    setState(() {
                      userNipSelected2 = userNip!;
                    });
                    nipCtrl.text = userNip!;
                  },
                  decoration: InputDecoration(
                    labelText: "No NIP",
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)
                    )
                  ),
              ),
              sizedbox,
              TextField(
                autocorrect: false,
                controller: nameCtrl,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nama Barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              sizedbox,
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: categoryProductController.streamCategoryProducts(), 
                  builder: (context, snapshot) {
            
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
            
                    if (snapshot.data!.docs.isEmpty) {
                      return Container();
                    }
                    
                    List<CategoryProductModel> _allCategory = [];
            
                    for (var element in snapshot.data!.docs) {
                      _allCategory.add(CategoryProductModel.fromJson(element.data()));
                    }
            
                    return DropdownButtonFormField<String>(
                      value: categoryProductSelected2.isEmpty ? categoryProductSelected : categoryProductSelected2,
                      items: _allCategory.map((CategoryProductModel cat) {
                        return DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name)
                        );
                      }).toList(), 
                      onChanged: (String? newCat) {
                        setState(() {
                          categoryProductSelected2 = newCat!;
                          categoryCtrl.text = newCat;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Jenis Barang",
                        labelStyle: const TextStyle(fontSize: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9)
                        )
                      ),
                    );
            
                  },
              ),
              sizedbox,
              TextField(
                autocorrect: false,
                controller: specCtrl,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                minLines: 2,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Spesifikasi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              sizedbox,
              DropdownButtonFormField(
                  value: statusProductSelected2.isEmpty ? statusProductSelected : statusProductSelected2,
                  items: _statusProduct.map((String status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status)
                    );
                  }).toList(), 
                  onChanged: (String? newVal) {
                    setState(() {
                      statusProductSelected2 = newVal!;
                      statusCtrl.text = newVal;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "Status",
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
                    borderRadius: BorderRadius.circular(9),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                onPressed: () async {

                  if (detailCtrl.isLoading.isFalse) {
                    
                    detailCtrl.isLoading(true);
                    Map<String, dynamic> req = await detailCtrl.editProduct({
                      "kode_barang": product.code,
                      "jenis_barang": categoryProductSelected2.isEmpty ? categoryProductSelected : categoryProductSelected2,
                      "nama_barang": nameCtrl.text,
                      "nip": userNipSelected2.isEmpty ? userNipSelected : userNipSelected2,
                      "spesifikasi": specCtrl.text,
                      "status_barang": statusProductSelected2.isEmpty ? statusProductSelected : statusProductSelected2
                    });
                    detailCtrl.isLoading(false);

                    if (!req['error']) {
                      Get.back();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Edit Barang")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Edit Barang")));
                    }

                  }

                }, 
                child: Obx(
                  () => Text(detailCtrl.isLoading.isFalse ? "EDIT BARANG" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {

                Get.defaultDialog(
                  title: "Hapus Barang",
                  middleText: "Apakah kamu yakin untuk hapus barang ini?",
                  actions: [
                    OutlinedButton(
                      onPressed: () => Get.back(), 
                      child: const Text("TIDAK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        detailCtrl.isLoadDelete(true);
                        Map<String, dynamic> res = await detailCtrl.deleteProduct(product.code);
                        detailCtrl.isLoadDelete(false);

                        if (!res['error']) {
                          Get.back(); Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Hapus Barang")));
                        } else {
                          Get.back();
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Hapus Barang")));
                        }

                      }, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                      ),
                      child: Obx(
                        () => Text(detailCtrl.isLoadDelete.isFalse ? "HAPUS" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                      )
                    )
                  ]
                );

                }, 
                child: Text("HAPUS PENGGUNA",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
              )
            ],
          );
        }
      )
    );
  }
}