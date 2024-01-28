import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_tugbes/model/signup_model.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/view/screen/login_page.dart';

class SignUpPage2 extends StatefulWidget {
  final String email;
  final String password;
  final String konfirmasiPassword;

  const SignUpPage2(
      {super.key,
      required this.email,
      required this.password,
      required this.konfirmasiPassword});
  @override
  State<SignUpPage2> createState() => _SignUpPage2State();
}

class _SignUpPage2State extends State<SignUpPage2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _namaLengkapController = TextEditingController();
  final _ktpController = TextEditingController();
  final _nomorHpController = TextEditingController();

  final ApiServices _dataService = ApiServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _namaLengkapController.dispose();
    _ktpController.dispose();
    _nomorHpController.dispose();
    super.dispose();
  }

  String? _validateNamaLengkap(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    if (value.length < 3) {
      return 'Masukkan minimal 3 karakter';
    }
    return null;
  }

  String? _validateKtp(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  String? _validateNomorHp(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: const Text(
                                "Data Diri",
                                style: TextStyle(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FadeInUp(
                              duration: const Duration(milliseconds: 1200),
                              child: Text(
                                "Lengkapi data diri maneh",
                                style: TextStyle(
                                    fontSize: 15, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeInUp(
                                duration: const Duration(milliseconds: 1200),
                                child: makeInput(
                                    label: "Nama Lengkap",
                                    controller: _namaLengkapController,
                                    validator: _validateNamaLengkap),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1300),
                                child: makeInput(
                                    label: "KTP",
                                    controller: _ktpController,
                                    validator: _validateKtp),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1400),
                                child: makeInput(
                                    label: "Nomor Hp",
                                    controller: _nomorHpController,
                                    validator: _validateNomorHp),
                              ),
                            ],
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1400),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                              padding: const EdgeInsets.only(top: 3, left: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: const Border(
                                    bottom: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                onPressed: () async {
                                  final isValidForm =
                                      _formKey.currentState!.validate();
                                  if (isValidForm) {
                                    final postModel = SignUpInput(
                                        email: widget.email,
                                        password: widget.password,
                                        konfirmasiPassword:
                                            widget.konfirmasiPassword,
                                        namaLengkap:
                                            _namaLengkapController.text,
                                        ktp: _ktpController.text,
                                        nomorHp: _nomorHpController.text);
                                    SignUpResponse? res =
                                        await _dataService.signup(postModel);
                                    if (res!.status == 200) {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            message: res.message +
                                                ' dengan email ' +
                                                res.email!,
                                          ),
                                        ),
                                        (route) => false,
                                      );
                                    } else {
                                      displaySnackbar(res.message);
                                    }
                                  }
                                },
                                color: Colors.greenAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // FadeInUp(
                        //   duration: const Duration(milliseconds: 1600),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       const Text("Already have an account?"),
                        //       MaterialButton(
                        //         onPressed: () {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (context) =>
                        //                       const LoginPage()));
                        //         },
                        //         child: const Text(
                        //           "Login",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w600,
                        //               fontSize: 18),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                )
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
