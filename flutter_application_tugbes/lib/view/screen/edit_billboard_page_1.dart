import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter_application_tugbes/view/screen/edit_billboard_page_2.dart';

class EditBillboardPage1 extends StatefulWidget {
  final BillboardsModel billboard;
  const EditBillboardPage1({super.key, required this.billboard});

  @override
  State<EditBillboardPage1> createState() => _EditBillboardPage1State();
}

class _EditBillboardPage1State extends State<EditBillboardPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _panjangController = TextEditingController();
  final _lebarController = TextEditingController();
  final _hargaController = TextEditingController();

  PlatformFile? file;
  String? _namaFile;
  String? _pathFile;
  bool _gambarTerisi = false;

  @override
  void initState() {
    super.initState();
    _kodeController.text = widget.billboard.kode;
    _namaController.text = widget.billboard.nama;
    _panjangController.text = widget.billboard.panjang;
    _lebarController.text = widget.billboard.lebar;
    _hargaController.text = widget.billboard.harga;
  }

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    _panjangController.dispose();
    _lebarController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  String? _validateKode(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateNama(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validatePanjang(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    const String expression = r'^[0-9]+$';
    final RegExp regExp = RegExp(expression);

    if (!regExp.hasMatch(value)) {
      return 'Field harus angka';
    }
    return null;
  }

  String? _validateLebar(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    const String expression = r'^[0-9]+$';
    final RegExp regExp = RegExp(expression);

    if (!regExp.hasMatch(value)) {
      return 'Field harus angka';
    }
    return null;
  }

  String? _validateHarga(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    const String expression = r'^[0-9]+$';
    final RegExp regExp = RegExp(expression);

    if (!regExp.hasMatch(value)) {
      return 'Field harus angka';
    }
    return null;
  }

  bool _validateFile(String? pathFile) {
    if (pathFile == null && widget.billboard.gambar.isEmpty) {
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
            )
          else
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
                      Image.network(widget.billboard.gambar),
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
              'Gambar harus diisi',
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
              'Masukkan Gambar',
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
                      "Edit Billboard",
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
                      label: "Kode Billboard",
                      controller: _kodeController,
                      validator: _validateKode,
                    ),
                    makeInput(
                        label: "Nama Billboard",
                        controller: _namaController,
                        validator: _validateNama),
                    Row(
                      children: [
                        Expanded(
                          child: makeInput(
                              label: "Panjang",
                              keyboardType: TextInputType.number,
                              controller: _panjangController,
                              validator: _validatePanjang),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Text("X"),
                        ),
                        Expanded(
                          child: makeInput(
                              label: "Lebar",
                              keyboardType: TextInputType.number,
                              controller: _lebarController,
                              validator: _validateLebar),
                        ),
                      ],
                    ),
                    makeInput(
                        label: "Harga",
                        keyboardType: TextInputType.number,
                        controller: _hargaController,
                        validator: _validateHarga),
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
                    onPressed: () {
                      final isValid = _formKey.currentState!.validate();
                      if (!isValid || _validateFile(_pathFile)) {
                        if (_validateFile(_pathFile)) {
                          setState(() {
                            _gambarTerisi = true;
                          });
                        }
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditBillboardPage2(
                            billboard: widget.billboard,
                            kode: _kodeController.text,
                            nama: _namaController.text,
                            panjang: _panjangController.text,
                            lebar: _lebarController.text,
                            harga: _hargaController.text,
                            pathFile: _pathFile.toString(),
                            namaFile: _namaFile.toString(),
                            imageUrl: _namaFile != null || _pathFile != null
                                ? null
                                : widget.billboard.gambar,
                          ),
                        ),
                      );
                    },
                    color: Colors.greenAccent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Selanjutnya",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.arrow_right_alt_outlined)
                      ],
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
              // controller.text = value;
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
}
