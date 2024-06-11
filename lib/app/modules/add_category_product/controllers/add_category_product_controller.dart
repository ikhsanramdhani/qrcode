import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddCategoryProductController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addCategoryProduct(String name) async {

    Map<String, dynamic> request = {
      "nama_category" : name.toUpperCase()
    };

    try {
      
      bool resBool = false;
      var existingCategory = await firestore.collection("categoryProducts").doc(name).get();

      if (existingCategory.exists) {
        resBool = true;
      } else {
        await firestore.collection("categoryProducts").doc(name).set(request);
      }

      return {
        "error": resBool
      };

    } catch (e) {
      return {
        "error": true
      };
    }

  }

}
