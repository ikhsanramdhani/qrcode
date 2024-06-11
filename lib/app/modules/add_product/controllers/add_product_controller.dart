import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddProductController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {

    try {
      
      bool resBool = false;
      var existingCodeProduct = await firestore.collection("products").doc(data['kode_barang']).get();

      if (existingCodeProduct.exists) {
        resBool = true;
      } else {
        await firestore.collection("products").doc(data['kode_barang']).set(data);
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
