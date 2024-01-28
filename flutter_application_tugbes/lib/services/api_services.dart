import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter_application_tugbes/model/login_model.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/model/sewa_model.dart';
import 'package:flutter_application_tugbes/model/signup_model.dart';
import 'package:flutter_application_tugbes/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_application_tugbes/services/auth_manager.dart';
import 'dart:convert';

class ApiServices {
  final Dio dio = Dio();
  final String _baseUrl =
      'https://asia-southeast2-keamanansistem.cloudfunctions.net';

  Future<String?> getToken() async {
    return await AuthManager.getToken();
  }

  Future<Iterable<SewaModel>?> getAllSewa() async {
    try {
      var response = await dio.get('$_baseUrl/sewa',
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        if (responseData['data'] == null) {
          return [];
        }
        final sewaList = (responseData['data'] as List)
            .map((billboard) => SewaModel.fromJson(billboard))
            .toList();
        return sewaList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataResponse?> postSewa(String id, SewaInput sw) async {
    try {
      final response = await dio.post('$_baseUrl/sewa?id=$id',
          data: sw.formData(),
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataResponse?> putSewa(String id, SewaInput sw) async {
    try {
      final response = await dio.put('$_baseUrl/sewa?id=$id',
          data: sw.formData(),
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteSewa(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/sewa?id=$id',
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Iterable<BillboardsModel>?> getAllBillboard() async {
    try {
      var response = await dio.get('$_baseUrl/billboard');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        final billboardList = (responseData['data'] as List)
            .map((billboard) => BillboardsModel.fromJson(billboard))
            .toList();
        return billboardList;
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<BillboardsModel?> getSingleBillboard(String id) async {
    try {
      var response = await dio.get('$_baseUrl/billboard?id=$id');
      if (response.statusCode == 200) {
        final data = json.decode(response.data);
        return BillboardsModel.fromJson(data['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataResponse?> postBillboard(BillboardInput bb) async {
    try {
      final response = await dio.post('$_baseUrl/billboard',
          data: bb.formData(),
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<DataResponse?> putBillboard(String id, BillboardInput bb) async {
    try {
      final response = await dio.put('$_baseUrl/billboard?id=$id',
          data: bb.formData(),
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future deleteBillboard(String id) async {
    try {
      final response = await dio.delete('$_baseUrl/billboard?id=$id',
          options: Options(
            headers: {'Authorization': await getToken()},
          ));
      if (response.statusCode == 200) {
        return DataResponse.fromJson(json.decode(response.data));
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<SignUpResponse?> signup(SignUpInput signup) async {
    try {
      final response = await dio.post(
        '$_baseUrl/register',
        data: signup.toJson(),
      );
      if (response.statusCode == 200) {
        return SignUpResponse.fromJson(json.decode(response.data));
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        final data = json.decode(e.response!.data);
        return SignUpResponse.fromJson(data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> login(LoginInput login) async {
    try {
      final response = await dio.post(
        '$_baseUrl/login',
        data: login.toJson(),
      );
      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.data));
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        final data = json.decode(e.response!.data);
        return LoginResponse.fromJson(data);
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUser() async {
    try {
      var response = await dio.get(
        '$_baseUrl/user',
        options: Options(
          headers: {'Authorization': await getToken()},
        ),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.data);
        if (responseData['data'] == null) {
          return null;
        }
        return UserModel.fromJson(responseData['data']);
      }
      return null;
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode != 200) {
        debugPrint('Client error - the request cannot be fulfilled');
        return null;
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
