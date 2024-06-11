import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_user_controller.dart';

class AddUserView extends GetView<AddUserController> {
  AddUserView({Key? key}) : super(key: key);
  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  final TextEditingController name = TextEditingController();
  final TextEditingController dept = TextEditingController();
  final TextEditingController nip = TextEditingController();
  final sizedBox = const SizedBox(height: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TAMBAH PENGGUNA', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: colorUi,
      ),
      body: ListView(
        padding: const EdgeInsets.all(25),
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
            controller: nip,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "No NIP",
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
                
                if (name.text.isNotEmpty && dept.text.isNotEmpty && nip.text.isNotEmpty) {

                  if (nip.text.contains(' ')) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("NIP Tidak Boleh Mengandung Spasi")));
                  } else {
                    controller.isLoading(true);

                    Map<String, dynamic> request = await controller.addUser({
                      "nama": name.text,
                      "bagian": dept.text,
                      "nip": nip.text
                    });
                    controller.isLoading(false);

                    if (!request["error"]) {
                      Get.back();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil Tambah Pengguna")));
                    } else {
                      // Get.back();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pengguna Sudah Ada")));
                    }
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Value harus di isi!")));
                }

              }
            }, 
            child: Obx(
              () => Text(controller.isLoading.isFalse ? "TAMBAH" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
            ),
            // child: Text("TAMBAH", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
          )
        ],
      )
    );
  }
}
