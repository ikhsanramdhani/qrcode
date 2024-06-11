import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrcode/app/data/models/product_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

class HomeAdminController extends GetxController {
  
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<ProductModel> allProducts = List<ProductModel>.empty().obs;

  Future<void> downloadCatalog() async {
    final pdf = pw.Document();

    final ttf = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Regular.ttf'));
    final boldTtf = pw.Font.ttf(await rootBundle.load('assets/fonts/NotoSans-Bold.ttf'));

    var getData = await firestore.collection("products").get();

    allProducts([]);

    for (var element in getData.docs) {
      print("element : ${element.data()}");
      allProducts.add(ProductModel.fromJson(element.data()));
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          List<pw.TableRow> allData = List.generate(
            allProducts.length,
            (index) {
              ProductModel product = allProducts[index];
              return pw.TableRow(
                verticalAlignment: pw.TableCellVerticalAlignment.middle,
                children: [
                  // No
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      "${index + 1}",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10, font: ttf
                      ),
                    ),
                  ),
                  // Kode Barang
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      product.code,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // Nama Barang
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      product.name,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      product.nip,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      product.spec,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10,
                        font: ttf,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Text(
                      product.status,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 10,
                        font: ttf,
                      ),
                    ),
                  ),
                  // QR Code
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.BarcodeWidget(
                      color: PdfColor.fromHex("#000000"),
                      barcode: pw.Barcode.qrCode(),
                      data: product.code,
                      textStyle: pw.TextStyle(
                        font: ttf
                      ),
                      height: 50,
                      width: 50,
                    ),
                  ),
                ],
              );
            },
          );

          return [
            pw.Center(
              child: pw.Text(
                "CATALOG BARANG",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 24,
                  font: ttf
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColor.fromHex("#000000"),
                width: 2,
              ),
              children: [
                pw.TableRow(
                  children: [
                    // No
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "No",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Kode Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Kode Barang",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Nama Barang
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Nama Barang",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // Qty
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "NIP",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Spesifikasi",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Status Barang",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                    // QR Code
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(20),
                      child: pw.Text(
                        "Kode QR",
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          fontSize: 10,
                          font: ttf,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                ...allData,
              ],
            ),
          ];
        },
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/Catalog Barang.pdf');
    await file.writeAsBytes(await pdf.save());

    await OpenFile.open(file.path);
  }

  Future<Map<String, dynamic>> getProductByCode(String code) async {

    try {
      
      var hasil = await firestore.collection("products").where("kode_barang", isEqualTo: code).get();

      if (hasil.docs.isEmpty) {
        return {
          "error": true
        };
      }

      Map<String, dynamic> data = hasil.docs.first.data();
      return {
        "error": false,
        "data": ProductModel.fromJson(data)
      };


    } catch (e) {
      return {
        "error" : true
      };
    }

  }

}
