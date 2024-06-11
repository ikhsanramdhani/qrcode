import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailUserController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isLoadDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editUser(Map<String, dynamic> data) async {

    try {
      
      await firestore.collection("users").doc(data['nip']).update({
        "nama": data['nama'],
        "bagian": data['bagian']
      });

      return {
        "error": false
      };

    } catch (e) {
      return {
        "error" : true
      };
    }

  }

  Future<Map<String, dynamic>> deleteUser(String nip) async {

    try {
      
      await firestore.collection("users").doc(nip).delete();
      return {
        "error": false
      };

    } catch (e) {
      return {
        "error" : true
      };
    }

  }

}
