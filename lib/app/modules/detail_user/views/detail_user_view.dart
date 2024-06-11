import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/data/models/user_model.dart';

import '../controllers/detail_user_controller.dart';

class DetailUserView extends GetView<DetailUserController> {
  DetailUserView({Key? key}) : super(key: key);

  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  final TextEditingController name = TextEditingController();
  final TextEditingController dept = TextEditingController();
  final TextEditingController nip = TextEditingController();
  final sizedBox = const SizedBox(height: 20);

  final UserModel user = Get.arguments;

  @override
  Widget build(BuildContext context) {

    name.text = user.name;
    dept.text = user.dept;
    nip.text = user.nip;

    return Scaffold(
      appBar: AppBar(
        title: const Text('KETERANGAN PENGGUNA', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorUi,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            controller: name,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Nama Pengguna",
              labelStyle: const TextStyle(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9)
              )
            ),
          ),
          sizedBox,
          TextField(
            autocorrect: false,
            controller: dept,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Bagian",
              labelStyle: const TextStyle(fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9)
              )
            ),
          ),
          sizedBox,
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: nip,
            readOnly: true,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "No NIP",
              counterText: "*NIP tidak bisa diubah",
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

              if (controller.isLoading.isFalse) {
                
                if (name.text.isNotEmpty && dept.text.isNotEmpty && nip.text.isNotEmpty) {
                  
                  controller.isLoading(true);
                  Map<String, dynamic> request = await controller.editUser({
                    "nama": name.text,
                    "bagian": dept.text,
                    "nip": nip.text
                  });
                  controller.isLoading(false);

                  if (!request['error']) {
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Perbarui Pengguna")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Perbarui Pengguna")));
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Value tidak boleh kosong")));
                }

              }

            }, 
            child: Obx(
              () => Text(controller.isLoading.isFalse ? "PERBARUI PENGGUNA" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
            )
            // child: Text("PERBARUI PENGGUNA",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {

              Get.defaultDialog(
                title: "Hapus Pengguna",
                middleText: "Apakah kamu yakin untuk hapus pengguna ini?",
                actions: [
                  OutlinedButton(
                    onPressed: () => Get.back(), 
                    child: const Text("TIDAK", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      controller.isLoadDelete(true);
                      Map<String, dynamic> res = await controller.deleteUser(user.nip);
                      controller.isLoadDelete(false);

                      if (!res['error']) {
                        Get.back(); Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Hapus Pengguna")));
                      } else {
                        Get.back();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal Hapus Pengguna")));
                      }

                    }, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                    ),
                    child: Obx(
                      () => Text(controller.isLoadDelete.isFalse ? "HAPUS" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                    )
                  )
                ]
              );

            }, 
            child: Text("HAPUS PENGGUNA",  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red))
          )
        ],
      )
    );
  }
}
