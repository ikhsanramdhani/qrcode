import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailProductController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isLoadDelete = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> editProduct(Map<String, dynamic> data) async {

    try {

      await firestore.collection("products").doc(data['kode_barang']).update({
        "nama_barang": data['nama_barang'],
        "jenis_barang": data['jenis_barang'],
        "status_barang": data['status_barang'],
        "spesifikasi": data['spesifikasi'],
        "nip": data['nip'],
      });

      return {
        "error": false
      };

    } catch (e) {
      return {
        "error": true
      };
    }

  }

  Future<Map<String, dynamic>> deleteProduct(String kode_barang) async {

    try {
      
      await firestore.collection("products").doc(kode_barang).delete();
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
