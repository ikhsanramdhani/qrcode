class UserModel {
  
  final String name;
  final String dept;
  final String nip;

  UserModel({
    required this.name,
    required this.dept,
    required this.nip
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json["nama"] ?? "", 
    dept: json["bagian"] ?? "", 
    nip: json["nip"] ?? ""
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "dept": dept,
    "nip": nip
  };

}