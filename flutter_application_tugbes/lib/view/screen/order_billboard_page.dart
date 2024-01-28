import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/model/sewa_model.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/admin_navigation_bar.dart';
import 'package:intl/intl.dart';

class OrderBillboardPage extends StatefulWidget {
  final String idbillboard;
  const OrderBillboardPage({super.key, required this.idbillboard});

  @override
  State<OrderBillboardPage> createState() => _OrderBillboardPageState();
}

class _OrderBillboardPageState extends State<OrderBillboardPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();
  final currentDate = DateTime.now();

  final ApiServices _dataService = ApiServices();

  PlatformFile? file;
  String? _namaFile;
  String? _pathFile;
  bool _gambarTerisi = false;

  @override
  void dispose() {
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    super.dispose();
  }

  String? _validateTanggalMulai(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateTanggalSelesai(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  bool _validateFile(String? pathFile) {
    if (pathFile == null) {
      return true;
    }
    return false;
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    file = result.files.single;

    setState(() {
      _namaFile = file!.name;
      _pathFile = file!.path;
    });
  }

  Widget buildFilePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (_pathFile != null)
            SizedBox(
              width: 300,
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.file(
                        File(_pathFile.toString()),
                      )
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          if (_namaFile != null) Text('File: $_namaFile'),
          if (_gambarTerisi && _namaFile == null)
            const Text(
              'Content harus diisi',
              style: TextStyle(color: Color.fromRGBO(212, 50, 50, 1)),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromRGBO(18, 140, 126, 1),
            )),
            onPressed: () async {
              _pickFile();
            },
            child: const Text(
              'Masukkan Content',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
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
                      "Sewa Billboard",
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
                    makeInput(
                      label: "Tanggal Mulai",
                      controller: _tanggalMulaiController,
                      validator: _validateTanggalMulai,
                    ),
                    makeInput(
                        label: "Tanggal Selesai",
                        controller: _tanggalSelesaiController,
                        validator: _validateTanggalSelesai),
                    buildFilePicker(context),
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
                      if (!isValid || _validateFile(_pathFile)) {
                        if (_validateFile(_pathFile)) {
                          setState(() {
                            _gambarTerisi = true;
                          });
                        }
                        return;
                      }

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => TambahBillboardPage2(
                      //       tanggalMulai: _tanggalMulaiController.text,
                      //       tanggalSelesai: _tanggalSelesaiController.text,
                      //       pathFile: _pathFile.toString(),
                      //       namaFile: _namaFile.toString(),
                      //     ),
                      //   ),
                      // );
                      final postSewa = SewaInput(
                          tanggalMulai: _tanggalMulaiController.text,
                          tanggalSelesai: _tanggalSelesaiController.text,
                          imagePath: _pathFile,
                          imageName: _namaFile);
                      DataResponse? res = await _dataService.postSewa(
                          widget.idbillboard, postSewa);
                      if (res!.status == 201) {
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
                      "Simpan",
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
          readOnly: true,
          onTap: () async {
            final selectDate = await showDatePicker(
              context: context,
              initialDate: currentDate,
              firstDate: DateTime(1990),
              lastDate: DateTime(currentDate.year + 5),
            );
            setState(() {
              if (selectDate != null) {
                controller.text =
                    DateFormat('dd-MM-yyyy').format(selectDate).toString();
              }
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
                : IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.grey,
                    ),
                  ),
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
