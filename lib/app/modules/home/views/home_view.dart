import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/authentication_controller.dart';
import 'package:qrcode/app/modules/home_admin/controllers/home_admin_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  final AuthenticationController authCtrl = Get.find<AuthenticationController>();
  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  final HomeAdminController adminCtrl = HomeAdminController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: colorUi,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 1,
        gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ), 
        itemBuilder: (context, index) {
          return Material(
            color:Colors.grey.shade300,
            borderRadius: BorderRadius.circular(9),
            child: InkWell(
              onTap: () {
                adminCtrl.downloadCatalog();
              },
              borderRadius: BorderRadius.circular(9),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: Icon(Icons.document_scanner_outlined, size: 50),
                  ),
                  SizedBox(height: 10),
                  Text("Catalog"),
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
