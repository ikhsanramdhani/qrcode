import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddUserController extends GetxController {

  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addUser(Map<String, dynamic> data) async {

    try {
      bool resBool = false;
      var existingNip = await firestore.collection("users").doc(data['nip']).get();
      var existingName = await firestore.collection("users").where('nama', isEqualTo: data['nama']).limit(1).get();
      var existingDept = await firestore.collection("users").where('bagian', isEqualTo: data['bagian']).limit(1).get();

      if (existingNip.exists || (existingName.docs.isNotEmpty && existingDept.docs.isNotEmpty)) {
        resBool = true;
      } else {
        await firestore.collection("users").doc(data['nip']).set(data);
      }
      return {
        "error": resBool
      };

    } catch (e) {
      return {
        "error" : true
      };
    }

  }

}
