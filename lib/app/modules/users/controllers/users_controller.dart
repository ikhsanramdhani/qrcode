import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UsersController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUsers() async* {
    yield* firestore.collection("users").snapshots();
  }

}
