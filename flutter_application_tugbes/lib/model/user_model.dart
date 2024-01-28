//DIGUNAKAN UNTUK GET ALL DATA
class UserModel {
  final String id;
  final String namaLengkap;
  final String email;
  final String nomorHp;
  final String ktp;

  UserModel({
    required this.id,
    required this.namaLengkap,
    required this.email,
    required this.nomorHp,
    required this.ktp,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        namaLengkap: json["nama_lengkap"],
        email: json["email"],
        nomorHp: json["no_hp"],
        ktp: json["ktp"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nama_lengkap": namaLengkap,
        "email": email,
        "no_hp": nomorHp,
        "ktp": ktp,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class UserResponse {
  final String? data;
  final String message;
  final int status;

  UserResponse({
    this.data,
    required this.message,
    required this.status,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
        data: json["data"],
        message: json["message"],
        status: json["status"],
      );
}
