import 'package:flutter_application_tugbes/app_properties.dart';

// import 'package:flutter_application_2/screens/faq_page.dart';
// import 'package:flutter_application_2/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/main.dart';
import 'package:flutter_application_tugbes/services/auth_manager.dart';
import 'package:flutter_application_tugbes/view/screen/deskripsi_aplikasi.dart';
import 'package:flutter_application_tugbes/view/screen/developer_page.dart';
// import 'package:flutter_application_tugbes/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  // final UserModel? user;
  // final String? namaLengkap;
  // final String? ktp;
  // final String? email;
  // final String? noHp;
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late SharedPreferences userdata;
  String namalengkap = '';
  String ktp = '';
  String nohp = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    initialUser();
  }

  void initialUser() async {
    userdata = await SharedPreferences.getInstance();
    setState(() {
      namalengkap = userdata.getString('namalengkap').toString();
      ktp = userdata.getString('ktp').toString();
      nohp = userdata.getString('nohp').toString();
      email = userdata.getString('email').toString();
    });
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Anda yakin ingin logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Tidak'),
            ),
            TextButton(
              onPressed: () async {
                await AuthManager.logout();
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil(
                  dialogContext,
                  MaterialPageRoute(
                    builder: (context) => const LandingPage(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9F9),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: kToolbarHeight),
            child: Column(
              children: <Widget>[
                const CircleAvatar(
                  maxRadius: 48,
                  backgroundImage: AssetImage('assets/background.jpg'),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    namalengkap,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: green,
                            blurRadius: 4,
                            spreadRadius: 1,
                            offset: Offset(0, 1))
                      ]),
                  height: 150,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.co_present_outlined),
                              // icon: Image.asset('assets/icons/wallet.png'),
                              onPressed: () {},
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //         builder: (_) => WalletPage())),
                            ),
                            Text(
                              ktp,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.phone_android),
                              onPressed: () {},
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //         builder: (_) => TrackingPage()))
                            ),
                            Text(
                              nohp,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.email_outlined),
                              onPressed: () {},
                              // Navigator.of(context).push(
                              //     MaterialPageRoute(
                              //         builder: (_) => TrackingPage()))
                            ),
                            Text(
                              email,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  title: const Text('Info Aplikasi'),
                  subtitle: const Text('Deskripsi dan Tujuan Aplikasi'),
                  leading: Image.asset(
                    'assets/icons/settings_icon.png',
                    fit: BoxFit.scaleDown,
                    width: 30,
                    height: 30,
                  ),
                  trailing: const Icon(Icons.chevron_right, color: yellow),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => InfoAplikasiPage())),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Developer'),
                  subtitle: const Text('Pembuat Aplikasi'),
                  leading: Image.asset('assets/icons/support.png'),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: yellow,
                  ),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ProfilPenggunaPage())),
                ),
                const Divider(),
                ListTile(
                  title: const Text('FAQ'),
                  subtitle: const Text('Questions and Answer'),
                  leading: Image.asset('assets/icons/faq.png'),
                  trailing: const Icon(Icons.chevron_right, color: yellow),
                  // onTap: () => Navigator.of(context)
                  //     .push(MaterialPageRoute(builder: (_) => FaqPage())),
                ),
                const Divider(),
                SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mediumYellow,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          onPressed: () async {
                            _showLogoutConfirmationDialog(context);
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Logout'),
                              SizedBox(width: 10.0),
                              Icon(Icons.logout, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
