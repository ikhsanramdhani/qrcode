import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/data/models/category_product_model.dart';
import 'package:qrcode/app/data/models/user_model.dart';
import 'package:qrcode/app/modules/category_product/controllers/category_product_controller.dart';
import 'package:qrcode/app/modules/users/controllers/users_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AddProductFull();
  }
}

class AddProductFull extends StatefulWidget {
  const AddProductFull({super.key});

  @override
  State<AddProductFull> createState() => _AddProductFullState();
}

class _AddProductFullState extends State<AddProductFull> {

  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  final TextEditingController codeProductCtrl = TextEditingController();
  final TextEditingController nameProductCtrl = TextEditingController();
  final TextEditingController statusProductCtrl = TextEditingController();
  final TextEditingController nipUserProductCtrl = TextEditingController();
  final TextEditingController categoryProductCtrl = TextEditingController();
  final TextEditingController specificationProductCtrl = TextEditingController();

  final UsersController userCtrl = UsersController();
  final AddProductController addCtrl = AddProductController();
  final CategoryProductController categoryProductController = CategoryProductController();

  String? statusSelected;
  String? userNipSelected;
  String? categoryProductSelected;

  final sizedBox = const SizedBox(height: 20);

  final List<String> _statusProduct = ["Disimpan", "Rusak", "Dipakai"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAMBAH BARANG', style: TextStyle(fontWeight: FontWeight.bold)),
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
            padding: const EdgeInsets.all(25),
            children: [
              TextField(
                autocorrect: false,
                textInputAction: TextInputAction.next,
                controller: codeProductCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Kode Barang",
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9)
                  )
                ),
              ),
              sizedBox,
              DropdownButtonFormField<String>(
                  value: userNipSelected,
                  items: _allUser.map((UserModel user) {
                    return DropdownMenuItem<String>(
                      value: user.nip,
                      child: Text(user.nip)
                    );
                  }).toList(), 
                  onChanged: (String? userNip) {
                    setState(() {
                      userNipSelected = userNip;
                      nipUserProductCtrl.text = userNip!;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: "No NIP",
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)
                    )
                  ),
                ),
                sizedBox, 
                TextField(
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  controller: nameProductCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Nama Barang",
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)
                    )
                  ),
                ),
                sizedBox,
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
                      value: categoryProductSelected,
                      items: _allCategory.map((CategoryProductModel cat) {
                        return DropdownMenuItem<String>(
                          value: cat.name,
                          child: Text(cat.name)
                        );
                      }).toList(), 
                      onChanged: (String? newCat) {
                        setState(() {
                          categoryProductSelected = newCat;
                          categoryProductCtrl.text = newCat!;
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
                sizedBox,
                TextField(
                  textInputAction: TextInputAction.newline,
                  autocorrect: false,
                  controller: specificationProductCtrl,
                  minLines: 2,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    labelText: "Spesifikasi",
                    labelStyle: const TextStyle(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9)
                    )
                  ),
                ),
                sizedBox,
                DropdownButtonFormField(
                  value: statusSelected,
                  items: _statusProduct.map((String status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status)
                    );
                  }).toList(), 
                  onChanged: (String? newVal) {
                    setState(() {
                      statusSelected = newVal!;
                      statusProductCtrl.text = newVal;
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
                sizedBox,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorUi,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20)
                  ),
                  onPressed: () async {

                    if (addCtrl.isLoading.isFalse) {
                      
                      if (codeProductCtrl.text.isNotEmpty && nipUserProductCtrl.text.isNotEmpty && nameProductCtrl.text.isNotEmpty && categoryProductCtrl.text.isNotEmpty && specificationProductCtrl.text.isNotEmpty && statusProductCtrl.text.isNotEmpty) {
                        
                        if (codeProductCtrl.text.contains(' ')) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kode Barang Tidak Boleh Mengandung Spasi")));
                        } else {
                          addCtrl.isLoading(true);

                          Map<String, dynamic> request = await addCtrl.addProduct({
                            "kode_barang": codeProductCtrl.text,
                            "nip": nipUserProductCtrl.text,
                            "nama_barang": nameProductCtrl.text,
                            "jenis_barang": categoryProductCtrl.text,
                            "spesifikasi": specificationProductCtrl.text,
                            "status_barang": statusProductCtrl.text
                          });

                          addCtrl.isLoading(false);

                          if (!request["error"]) {
                            Get.toNamed(Routes.products);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Tambah Barang")));
                          } else {
                            // Get.back();
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Barang Sudah Ada")));
                          }

                        }

                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Value harus di isi!")));
                      }

                    }

                  }, 
                  child: Obx(
                    () => Text(addCtrl.isLoading.isFalse ? "TAMBAH BARANG" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
                  )
                )
            ],
          );
        }
      )
    );
  }
}