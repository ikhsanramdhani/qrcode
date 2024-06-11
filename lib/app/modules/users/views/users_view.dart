import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/data/models/user_model.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/users_controller.dart';

class UsersView extends GetView<UsersController> {
  const UsersView({Key? key}) : super(key: key);

  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PENGGUNA', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
        actions: [
          IconButton(onPressed: () => Get.toNamed(Routes.addUser), icon: Icon(Icons.add))
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamUsers(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Pengguna masih kosong", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            );
          }

          List<UserModel> allUser = [];

          for (var element in snapshot.data!.docs) {
            allUser.add(UserModel.fromJson(element.data()));
          }

          return ListView.builder(
            itemCount: allUser.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              UserModel user = allUser[index];
              
              return Card(
                elevation: 5,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: InkWell(
                  onTap: () => Get.toNamed(Routes.detailUser, arguments: user),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Nama Pengguna : ${user.name}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Text("Bagian : ${user.dept}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              const SizedBox(height: 5),
                              Text("No NIP : ${user.nip}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          )
                        )
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
