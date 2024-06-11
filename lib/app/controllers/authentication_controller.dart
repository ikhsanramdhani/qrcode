import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationController extends GetxController {

  String? uid;
  late FirebaseAuth auth;

  @override
  void onInit() {
    auth = FirebaseAuth.instance;

    auth.authStateChanges().listen((event) {
      uid = event?.uid;
    });

    super.onInit();
  }

  Future<Map<String, dynamic>> signin(String email, String pass) async {

    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
      return {
        "error": false
      };
    } catch (e) {
      return {
        "error" : true
      };
    }

  }

  Future<Map<String, Object>> signout() async {

    try {
      await auth.signOut();
      return {
        "error": false
      };
    } catch (e) {
      return {
        "error": true
      };
    }

  }

}
