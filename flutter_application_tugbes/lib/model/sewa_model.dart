//DIGUNAKAN UNTUK GET ALL DATA
import 'package:dio/dio.dart';

class SewaModel {
  final String idbillboard;
  final String kode;
  final String nama;
  final String panjang;
  final String lebar;
  final String harga;
  final String latitude;
  final String longitude;
  final String address;
  final String regency;
  final String district;
  final String village;
  final String gambar;

  final String id;
  final String content;
  final String tanggalMulai;
  final String tanggalSelesai;
  final bool? bayar;
  final bool? status;

  final String iduser;
  final String namaLengkap;
  final String ktp;
  final String email;
  final String noHp;

  SewaModel({
    required this.idbillboard,
    required this.kode,
    required this.nama,
    required this.panjang,
    required this.lebar,
    required this.harga,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.regency,
    required this.district,
    required this.village,
    required this.gambar,
    required this.id,
    required this.content,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    this.bayar,
    this.status,
    required this.iduser,
    required this.namaLengkap,
    required this.ktp,
    required this.email,
    required this.noHp,
  });

  factory SewaModel.fromJson(Map<String, dynamic> json) => SewaModel(
        idbillboard: json["billboard"]["_id"],
        kode: json["billboard"]["kode"],
        nama: json["billboard"]["nama"],
        panjang: json["billboard"]["panjang"],
        lebar: json["billboard"]["lebar"],
        harga: json["billboard"]["harga"],
        latitude: json["billboard"]["latitude"],
        longitude: json["billboard"]["longitude"],
        address: json["billboard"]["address"],
        regency: json["billboard"]["regency"],
        district: json["billboard"]["district"],
        village: json["billboard"]["village"],
        gambar: json["billboard"]["gambar"],
        //
        id: json["_id"],
        content: json["content"],
        tanggalMulai: json["tanggal_mulai"],
        tanggalSelesai: json["tanggal_selesai"],
        bayar: json["bayar"],
        status: json["status"],
        //
        iduser: json["user"]["_id"],
        namaLengkap: json["user"]["namalengkap"],
        ktp: json["user"]["ktp"],
        email: json["user"]["email"],
        noHp: json["user"]["nohp"],
      );

  Map<String, dynamic> toJson() => {
        "billboard._id": idbillboard,
        "billboard.kode": kode,
        "billboard.nama": nama,
        "billboard.panjang": panjang,
        "billboard.lebar": lebar,
        "billboard.harga": harga,
        "billboard.latitude": latitude,
        "billboard.longitude": longitude,
        "billboard.address": address,
        "billboard.regency": regency,
        "billboard.district": district,
        "billboard.village": village,
        "billboard.gambar": gambar,
        //
        "_id": id,
        "content": content,
        "tanggal_mulai": tanggalMulai,
        "tanggal_selesai": tanggalSelesai,
        "bayar": bayar,
        "status": status,
        //
        "user._id": iduser,
        "user.namalengkap": namaLengkap,
        "user.ktp": ktp,
        "user.email": email,
        "user.nohp": noHp,
      };
}

//DIGUNAKAN UNTUK FORM INPUT
class SewaInput {
  final String tanggalMulai;
  final String tanggalSelesai;
  final String? imagePath;
  final String? imageName;
  final String? imageUrl;

  SewaInput({
    required this.tanggalMulai,
    required this.tanggalSelesai,
    this.imagePath,
    this.imageName,
    this.imageUrl,
  });

  FormData formData() => FormData.fromMap({
        "tanggal_mulai": tanggalMulai,
        "tanggal_selesai": tanggalSelesai,
        "file": imageUrl ??
            MultipartFile.fromFileSync(imagePath!, filename: imageName),
      });
}

//DIGUNAKAN UNTUK RESPONSE
class SewaResponse {
  final String? insertedId;
  final String message;
  final int status;

  SewaResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory SewaResponse.fromJson(Map<String, dynamic> json) => SewaResponse(
        insertedId: json["data"] != null ? json["data"]["_id"] : null,
        message: json["message"],
        status: json["status"],
      );
}
