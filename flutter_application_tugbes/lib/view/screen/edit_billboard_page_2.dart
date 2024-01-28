import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/admin_navigation_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_application_tugbes/plugins/zoombuttons_plugin.dart';

class EditBillboardPage2 extends StatefulWidget {
  final BillboardsModel billboard;
  final String kode;
  final String nama;
  final String panjang;
  final String lebar;
  final String harga;
  final String? pathFile;
  final String? namaFile;
  final String? imageUrl;

  const EditBillboardPage2(
      {super.key,
      required this.billboard,
      required this.kode,
      required this.nama,
      required this.panjang,
      required this.lebar,
      required this.harga,
      this.pathFile,
      this.namaFile,
      this.imageUrl});

  @override
  State<EditBillboardPage2> createState() => _EditBillboardPage2State();
}

class _EditBillboardPage2State extends State<EditBillboardPage2> {
  late final customMarkers = <Marker>[];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _kabupatenkotaController = TextEditingController();
  final _kecamatanController = TextEditingController();
  final _kelurahanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
    _kabupatenkotaController.text = widget.billboard.regency;
    _kecamatanController.text = widget.billboard.district;
    _kelurahanController.text = widget.billboard.village;
    _alamatController.text = widget.billboard.address;
    _latitudeController.text = widget.billboard.latitude;
    _longitudeController.text = widget.billboard.longitude;
    customMarkers.add(buildPin(LatLng(double.parse(widget.billboard.latitude),
        double.parse(widget.billboard.longitude))));
  }

  @override
  void dispose() {
    _kabupatenkotaController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _alamatController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  String? _validateKabupatenKota(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateKecamatan(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateKelurahan(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateAlamat(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateLatitude(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    const String expression = r'^[0-9\-\.]+$';
    final RegExp regExp = RegExp(expression);

    if (!regExp.hasMatch(value)) {
      return 'Field harus angka';
    }
    return null;
  }

  String? _validateLongitude(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    const String expression = r'^[0-9\-\.]+$';
    final RegExp regExp = RegExp(expression);

    if (!regExp.hasMatch(value)) {
      return 'Field harus angka';
    }
    return null;
  }

  Marker buildPin(LatLng point) => Marker(
        point: point,
        child:
            const Icon(Icons.location_on, size: 45, color: Colors.blueAccent),
        width: 80,
        height: 80,
      );

  void _pickLocation(_, result) {
    setState(() {
      if (customMarkers.isNotEmpty) {
        customMarkers.clear();
      }
      customMarkers.add(buildPin(result));
      _latitudeController.text = result.latitude.toString();
      _longitudeController.text = result.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Column(
                  children: <Widget>[
                    Text(
                      "Lokasi Billboard",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: makeInput(
                              label: "Kabupaten/Kota",
                              controller: _kabupatenkotaController,
                              validator: _validateKabupatenKota),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        Expanded(
                          child: makeInput(
                              label: "Kecamatan",
                              controller: _kecamatanController,
                              validator: _validateKecamatan),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: makeInput(
                              label: "Kelurahan",
                              controller: _kelurahanController,
                              validator: _validateKelurahan),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        Expanded(
                          child: makeInput(
                              label: "Alamat",
                              controller: _alamatController,
                              validator: _validateAlamat),
                        ),
                      ],
                    ),
                    makeInput(
                        label: "Latitude",
                        keyboardType: TextInputType.number,
                        controller: _latitudeController,
                        validator: _validateLatitude),
                    makeInput(
                        label: "Longitude",
                        keyboardType: TextInputType.number,
                        controller: _longitudeController,
                        validator: _validateLongitude),
                    SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          onTap: _pickLocation,
                          initialCenter: LatLng(
                              double.parse(widget.billboard.latitude),
                              double.parse(widget.billboard.longitude)),
                          initialZoom: 12.0,
                          keepAlive: true,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.app',
                          ),
                          // const MarkerLayer(
                          //   markers: [
                          //     Marker(
                          //       width: 80.0,
                          //       height: 80.0,
                          //       point:
                          //           LatLng(-6.916053058182122, 107.6208371361958),
                          //       child: Icon(
                          //         Icons.location_on,
                          //         size: 45.0,
                          //         color: Colors.redAccent,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          MarkerLayer(markers: customMarkers),
                          const FlutterMapZoomButtons(
                            minZoom: 4,
                            maxZoom: 19,
                            mini: true,
                            zoomInColor: Colors.greenAccent,
                            zoomOutColor: Colors.greenAccent,
                            padding: 5,
                            alignment: Alignment.bottomRight,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3, left: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () async {
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid) {
                        return;
                      }
                      final putBillboard = BillboardInput(
                          kode: widget.kode,
                          nama: widget.nama,
                          panjang: widget.panjang,
                          lebar: widget.lebar,
                          harga: widget.harga,
                          latitude: _latitudeController.text,
                          longitude: _longitudeController.text,
                          address: _alamatController.text,
                          regency: _kabupatenkotaController.text,
                          district: _kecamatanController.text,
                          village: _kelurahanController.text,
                          imagePath: widget.pathFile,
                          imageName: widget.namaFile,
                          imageUrl: widget.imageUrl);
                      DataResponse? res = await _dataService.putBillboard(
                          widget.billboard.id, putBillboard);
                      if (res!.status == 200) {
                        // ignore: use_build_context_synchronously
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminNavigationBar(
                                res: res, currentPageIndex: 1),
                          ),
                          (route) => false,
                        );
                      } else {
                        displaySnackbar(res.message);
                      }
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Text(
                      "Update",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeInput(
      {label, keyboardType, controller, validator, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          onChanged: (value) {
            setState(() {
              controller.text = value;
            });
          },
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
      ],
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
