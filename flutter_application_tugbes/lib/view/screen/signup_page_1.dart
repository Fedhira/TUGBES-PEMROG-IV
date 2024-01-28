import 'package:animate_do/animate_do.dart';
// import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/view/screen/login_page.dart';
import 'package:flutter_application_tugbes/view/screen/signup_page_2.dart';

class SignUpPage1 extends StatefulWidget {
  const SignUpPage1({super.key});
  @override
  State<SignUpPage1> createState() => _SignUpPage1State();
}

class _SignUpPage1State extends State<SignUpPage1> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiPasswordController = TextEditingController();

  // final ApiServices _dataService = ApiServices();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }

    const String emailRegex = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';

    final RegExp regExp = RegExp(emailRegex);

    if (!regExp.hasMatch(value)) {
      return 'Email tidak palit';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? _validateKonfirmasiPassword(String? value) {
    if (value!.isEmpty) {
      return 'Field tidak boleh kosong';
    }
    if (_passwordController.text != value) {
      return 'Konfirmasi password salah';
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
                                "Sign Up",
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
                                "Create an account, It's free",
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
                                    label: "Email",
                                    controller: _emailController,
                                    validator: _validateEmail,
                                    keyboardType: TextInputType.emailAddress),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1300),
                                child: makeInput(
                                    label: "Password",
                                    obscureText: true,
                                    controller: _passwordController,
                                    validator: _validatePassword),
                              ),
                              FadeInUp(
                                duration: const Duration(milliseconds: 1400),
                                child: makeInput(
                                    label: "Konfirmasi Password",
                                    obscureText: true,
                                    controller: _konfirmasiPasswordController,
                                    validator: _validateKonfirmasiPassword),
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
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignUpPage2(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          konfirmasiPassword:
                                              _konfirmasiPasswordController
                                                  .text,
                                        ),
                                      ),
                                    );
                                  }
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(Icons.arrow_right_alt_outlined)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("Already have an account?"),
                              MaterialButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
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
