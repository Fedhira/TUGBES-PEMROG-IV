import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/app_properties.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
// import 'package:flutter_application_tugbes/model/user_model.dart';
import 'package:flutter_application_tugbes/view/screen/billboard_page.dart';
import 'package:flutter_application_tugbes/view/screen/sewa_page.dart';
import 'package:flutter_application_tugbes/view/screen/home_page.dart';
import 'package:flutter_application_tugbes/view/screen/profile_page.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
// import 'package:flutter_application_tugbes/services/api_services.dart';

class AdminNavigationBar extends StatefulWidget {
  final DataResponse? res;
  final int currentPageIndex;

  const AdminNavigationBar(
      {super.key, this.res, required this.currentPageIndex});

  @override
  State<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  // final ApiServices _dataService = ApiServices();
  // late UserModel? user;
  // late String? _namaLengkap;
  // late String? _ktp;
  // late String? _email;
  // late String? _noHp;

  // @override
  // void initState() {
  //   super.initState();
  //   userInital();
  // }

  // void userInital() async {
  //   final user = await _dataService.getUser();
  //   setState(() {
  //     _namaLengkap = user!.namaLengkap;
  //     _ktp = user.ktp;
  //     _email = user.email;
  //     _noHp = user.nomorHp;
  //   });
  // }

  List<Widget>? _pages;
  int? _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.currentPageIndex;
    _pages = <Widget>[
      const HomePage(),
      BillboardPage(res: widget.res),
      SewaPage(),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages![_currentPageIndex!],
      bottomNavigationBar: Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20)),
        ),
        child: NavigationBar(
          animationDuration: const Duration(milliseconds: 200),
          indicatorColor: Colors.transparent,
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: _currentPageIndex!,
          height: 70,
          indicatorShape: const CircleBorder(),
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Iconsax.home,
                color: Colors.grey,
              ),
              label: 'Home',
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  yellow,
                  BlendMode.srcIn,
                ),
                child: Icon(
                  Iconsax.home,
                ),
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              label: 'Billboard',
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  yellow,
                  BlendMode.srcIn,
                ),
                child: Icon(
                  Icons.search,
                ),
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.receipt,
                color: Colors.grey,
              ),
              label: 'Daftar Sewa',
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  yellow,
                  BlendMode.srcIn,
                ),
                child: Icon(
                  Iconsax.receipt,
                ),
              ),
            ),
            NavigationDestination(
              icon: Icon(
                Iconsax.user,
                color: Colors.grey,
              ),
              label: 'Profile',
              selectedIcon: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  yellow,
                  BlendMode.srcIn,
                ),
                child: Icon(
                  Iconsax.user,
                ),
              ),
            ),
          ],
          onDestinationSelected: (value) {
            setState(() {
              _currentPageIndex = value;
            });
          },
        ),
      ),
    );
  }
}
