class CategoryProductModel {
  
  final String name;

  CategoryProductModel({
    required this.name
  });

  factory CategoryProductModel.fromJson(Map<String, dynamic> json) => CategoryProductModel(name: json['nama_category'] ?? "");

  Map<String, dynamic> toJson() => {
    "name" : name
  };

}