class SignUpInput {
  final String email;
  final String password;
  final String konfirmasiPassword;
  final String namaLengkap;
  final String ktp;
  final String nomorHp;
  SignUpInput({
    required this.email,
    required this.password,
    required this.konfirmasiPassword,
    required this.namaLengkap,
    required this.ktp,
    required this.nomorHp,
  });
  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "confirmpass": konfirmasiPassword,
        "namalengkap": namaLengkap,
        "ktp": ktp,
        "nohp": nomorHp,
      };
}

//DIGUNAKAN UNTUK RESPONSE
class SignUpResponse {
  final String? email;
  final String message;
  final int status;
  SignUpResponse({
    this.email,
    required this.message,
    required this.status,
  });
  factory SignUpResponse.fromJson(Map<String, dynamic> json) => SignUpResponse(
        email: json["data"] != null ? json["data"]["email"] : null,
        message: json["message"],
        status: json["status"],
      );
}
