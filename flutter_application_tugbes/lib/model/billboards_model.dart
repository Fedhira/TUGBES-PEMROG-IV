//DIGUNAKAN UNTUK GET ALL DATA
import 'package:dio/dio.dart';

class BillboardsModel {
  final String id;
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
  final bool booking;

  BillboardsModel({
    required this.id,
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
    required this.booking,
  });

  factory BillboardsModel.fromJson(Map<String, dynamic> json) =>
      BillboardsModel(
        id: json["_id"],
        kode: json["kode"],
        nama: json["nama"],
        panjang: json["panjang"],
        lebar: json["lebar"],
        harga: json["harga"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        address: json["address"],
        regency: json["regency"],
        district: json["district"],
        village: json["village"],
        gambar: json["gambar"],
        booking: json["booking"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "kode": kode,
        "nama": nama,
        "panjang": panjang,
        "lebar": lebar,
        "harga": harga,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "regency": regency,
        "district": district,
        "village": village,
        "gambar": gambar,
        "booking": booking,
      };
}

//DIGUNAKAN UNTUK FORM INPUT
class BillboardInput {
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
  final String? imagePath;
  final String? imageName;
  final String? imageUrl;

  BillboardInput({
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
    this.imagePath,
    this.imageName,
    this.imageUrl,
  });

  FormData formData() => FormData.fromMap({
        "kode": kode,
        "nama": nama,
        "panjang": panjang,
        "lebar": lebar,
        "harga": harga,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "regency": regency,
        "district": district,
        "village": village,
        "file": imageUrl ??
            MultipartFile.fromFileSync(imagePath!, filename: imageName),
      });
}

//DIGUNAKAN UNTUK RESPONSE
class BillboardResponse {
  final String? insertedId;
  final String message;
  final int status;

  BillboardResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory BillboardResponse.fromJson(Map<String, dynamic> json) =>
      BillboardResponse(
        insertedId: json["data"] != null ? json["data"]["_id"] : null,
        message: json["message"],
        status: json["status"],
      );
}
