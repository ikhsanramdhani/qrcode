import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/authentication_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  HomeAdminView({Key? key}) : super(key: key);

  final AuthenticationController authCtrl = Get.find<AuthenticationController>();
  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  final HomeAdminController adminController = HomeAdminController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorUi,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 6,
        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 25,
        ), 
        itemBuilder: (context, index) {
          late String title; late IconData icon; late VoidCallback onTap;

          switch (index) {
            case 0:
              title = "Pengguna";
              icon = Icons.person;
              onTap = () => Get.toNamed(Routes.users);
              break;
            case 1:
              title = "Tambah Barang";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.addProduct);
              break;
            case 2:
              title = "Jenis Barang";
              icon = Icons.post_add_rounded;
              onTap = () => Get.toNamed(Routes.categoryProduct);
              break;
            case 3:
              title = "Barang";
              icon = Icons.list_alt_outlined;
              onTap = () => Get.toNamed(Routes.products);
              break;
            case 4:
              title = "Scan Barang";
              icon = Icons.qr_code;
              onTap = () async {
                String barcode = await FlutterBarcodeScanner.scanBarcode(
                  "#000000",
                  "CANCEL",
                  true,
                  ScanMode.QR,
                );

                Map<String, dynamic> hasil = await adminController.getProductByCode(barcode);

                if (!hasil['error']) {
                  Get.toNamed(Routes.detailProduct, arguments: hasil['data']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Produk Tidak Ditemukan")));
                }

              };
              
              break;
            case 5:
              title = "Data Barang";
              icon = Icons.document_scanner_outlined;
              // onTap = () => adminController.generatePdf();
              onTap = () => adminController.downloadCatalog();
              break;
          }

          return Material(
            color:Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(9),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(icon, size: 50),
                  ),
                  const SizedBox(height: 10),
                  Text(title),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Map<String, dynamic> res = await authCtrl.signout();
          if (!res["error"]) Get.offAllNamed(Routes.signin);
          else ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Other error")));
        },
        backgroundColor: colorUi,
        child: Icon(Icons.logout),
      ),
    );
  }
}
