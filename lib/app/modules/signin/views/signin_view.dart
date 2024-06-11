import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/authentication_controller.dart';
import 'package:qrcode/app/routes/app_pages.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  SigninView({Key? key}) : super(key: key);

  final padding = const EdgeInsets.all(20);
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  final authCtrl = Get.find<AuthenticationController>();
  final colorUi = const Color.fromARGB(255, 195, 255, 147);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOGIN', style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: colorUi,
      ),
      body: ListView(
        padding: padding,
        children: [
          TextField(
            autocorrect: false,
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10)
              )
            ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => TextField(
               autocorrect: false,
              controller: passCtrl,
              keyboardType: TextInputType.text,
              obscureText: controller.isHidden.value,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  onPressed: () {
                    controller.isHidden.toggle();
                  }, 
                  icon: Icon(
                    controller.isHidden.isTrue ? Icons.remove_red_eye_outlined : Icons.remove_red_eye
                  )
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )
              ),
            ),
          ),
          const SizedBox(height: 35),
          ElevatedButton(
            onPressed: () async {
              
              if (controller.isLoading.isFalse) {
                
                if (emailCtrl.text.isNotEmpty && passCtrl.text.isNotEmpty) {
                  
                  controller.isLoading(true);
                  Map<String, dynamic> res = await authCtrl.signin(emailCtrl.text, passCtrl.text);
                  controller.isLoading(false);

                  if (res["error"] == true) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed Sign In")));
                  } else {
                    Get.offAllNamed(emailCtrl.text == 'administrator@gmail.com' ? Routes.homeAdmin : Routes.home);
                  }

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email dan Password harus di isi")));
                }

              } 
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: colorUi,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            child: Obx(
              () => Text(controller.isLoading.isFalse ? "LOGIN" : "...", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black))
            )
          )
        ],
      )
    );
  }
}
