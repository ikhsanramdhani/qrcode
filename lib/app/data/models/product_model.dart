class ProductModel {
  
  final String name;
  final String nip;
  final String code;
  final String category;
  final String spec;
  final String status;

  ProductModel({
    required this.name,
    required this.nip,
    required this.code,
    required this.category,
    required this.spec,
    required this.status
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    name: json['nama_barang'] ?? "", 
    nip: json['nip'], 
    code: json['kode_barang'] ?? "", 
    category: json['jenis_barang'] ?? "", 
    spec: json['spesifikasi'] ?? "", 
    status: json['status_barang'] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "nip": nip,
    "category": category,
    "code": code,
    "spec": spec,
    "status": status
  };

}