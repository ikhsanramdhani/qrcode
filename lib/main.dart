import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode/app/controllers/authentication_controller.dart';
import 'package:qrcode/app/modules/home/views/home_view.dart';
import 'package:qrcode/app/modules/home_admin/views/home_admin_view.dart';
import 'package:qrcode/firebase_options.dart';

import 'app/routes/app_pages.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(AuthenticationController(), permanent: true);

  runApp(QrCodeApp());
}

class QrCodeApp extends StatelessWidget {
  const QrCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Loading indicator
        }

        if (user == null) {
          return GetMaterialApp(
            title: "QR Code",
            debugShowCheckedModeBanner: false,
            getPages: AppPages.routes,
            initialRoute: Routes.signin,
          );
        } else {
          return GetMaterialApp(
            title: "QR Code",
            debugShowCheckedModeBanner: false,
            getPages: AppPages.routes,
            home: user.email == 'administrator@gmail.com' ? HomeAdminView() : HomeView(),
          );
        }

      },
    );
  }
}
