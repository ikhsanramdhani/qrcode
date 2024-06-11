import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryProductController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamCategoryProducts() async* {
    yield* firestore.collection("categoryProducts").snapshots();
  }

  Future<Map<String, dynamic>> deleteCategoryProduct(String name) async {

    try {
      
      await firestore.collection("categoryProducts").doc(name).delete();
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
