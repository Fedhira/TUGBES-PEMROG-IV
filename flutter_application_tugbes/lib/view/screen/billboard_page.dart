import 'package:flutter_application_tugbes/app_properties.dart';
import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/screen/detail_billboard_page.dart';
import 'package:flutter_application_tugbes/view/screen/tambah_billboard_page_1.dart';
import 'package:flutter_application_tugbes/view/widget/response_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class BillboardPage extends StatefulWidget {
  DataResponse? res;

  BillboardPage({super.key, this.res});

  @override
  // ignore: library_private_types_in_public_api
  _BillboardPageState createState() => _BillboardPageState();
}

class _BillboardPageState extends State<BillboardPage>
    with SingleTickerProviderStateMixin {
  List<BillboardsModel> searchResults = [];
  List<BillboardsModel> _billboardMdl = [];
  final ApiServices _dataService = ApiServices();
  TextEditingController searchController = TextEditingController();
  Iterable<BillboardsModel>? billboards;
  late SharedPreferences logindata;
  bool admin = true;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    searchResults = _billboardMdl;
    refreshBillboardList();
    initial();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      if (logindata.getString('email').toString() == "admin@gmail.com") {
        admin = true;
      } else {
        admin = false;
      }
    });
  }

  void refreshBillboardList() async {
    try {
      billboards = await _dataService.getAllBillboard();
      final Iterable<BillboardsModel> notBooked =
          billboards!.where((element) => element.booking == false);
      final Iterable<BillboardsModel> booked =
          billboards!.where((element) => element.booking == true);
      Iterable<BillboardsModel> temp = notBooked.followedBy(booked);
      setState(() {
        if (billboards != null) _billboardMdl.addAll(temp);
      });
    } catch (e) {
      print("terlalu sering pindah halaman hey");
    }
  }

  Widget messageCard(BuildContext context) {
    return Column(children: [
      if (widget.res != null)
        ResponseCard(
          res: widget.res!,
          onDismissed: () {
            setState(() {
              widget.res = null;
            });
          },
        )
      else
        SizedBox(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 2));
        setState(() {
          _billboardMdl = [];
          refreshBillboardList();
        });
      },
      color: yellow,
      child: Scaffold(
          body: Material(
            color: const Color(0xffF9F9F9),
            child: Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Align(
                    alignment: Alignment(-1, 0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Daftar Billboard',
                        style: TextStyle(
                          color: darkGrey,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.only(left: 16.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          prefixIcon: SvgPicture.asset(
                            'assets/icons/search_icon.svg',
                            fit: BoxFit.scaleDown,
                          )),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          List<BillboardsModel> tempList = [];
                          for (var billboard in _billboardMdl) {
                            if (billboard.nama.toLowerCase().contains(value)) {
                              tempList.add(billboard);
                            }
                          }
                          setState(() {
                            searchResults.clear();
                            searchResults.addAll(tempList);
                          });
                          return;
                        } else {
                          setState(() {
                            searchResults.clear();
                            _billboardMdl.addAll(billboards!);
                          });
                        }
                      },
                    ),
                  ),
                  messageCard(context),
                  Expanded(
                    child: Skeletonizer(
                      ignoreContainers: true,
                      enabled: _billboardMdl.isEmpty,
                      child: ListView.builder(
                        itemCount: _billboardMdl.isNotEmpty
                            ? _billboardMdl.length
                            : 10,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: _billboardMdl.isNotEmpty
                                      ? LinearGradient(
                                          colors: !_billboardMdl[index].booking
                                              ? [yellow, Colors.white]
                                              : [Colors.grey, Colors.white],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight)
                                      : null,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(children: <Widget>[
                                          _billboardMdl.isNotEmpty
                                              ? Image.network(
                                                  _billboardMdl[index].gambar,
                                                  // height: 160,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Skeletonizer(
                                                  enabled: true,
                                                  child: Container(
                                                    height: 250,
                                                    width: double.infinity,
                                                    color: Colors.grey[300],
                                                  ),
                                                ),
                                          if (_billboardMdl.isNotEmpty &&
                                              _billboardMdl[index].booking)
                                            Positioned.fill(
                                              child: Center(
                                                child: Container(
                                                  height: 120,
                                                  width: 120,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                60)),
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Booked",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ]),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 0),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: _billboardMdl.isNotEmpty
                                              ? <Widget>[
                                                  Text(
                                                    _billboardMdl[index].nama,
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.grey[800],
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 14),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        _billboardMdl[index]
                                                            .address,
                                                        style: TextStyle(
                                                          fontSize: 19,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.size,
                                                          color:
                                                              Colors.grey[700],
                                                          size: 14),
                                                      SizedBox(width: 5),
                                                      Text(
                                                        "${_billboardMdl[index].panjang} x ${_billboardMdl[index].lebar} m",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.grey[700],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      const Spacer(),
                                                      TextButton(
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors
                                                                  .transparent,
                                                        ),
                                                        child: const Text(
                                                          "LIHAT",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailBillboardPage(
                                                                            billboard:
                                                                                _billboardMdl[index],
                                                                          )));
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ]
                                              : <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Skeletonizer(
                                                      enabled: true,
                                                      child: Container(
                                                        height: 24,
                                                        width: 200,
                                                        color: Colors.grey[300],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Skeletonizer(
                                                          enabled: true,
                                                          child: Container(
                                                            height: 14,
                                                            width: 14,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Skeletonizer(
                                                          enabled: true,
                                                          child: Container(
                                                            height: 19,
                                                            width: 150,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Skeletonizer(
                                                          enabled: true,
                                                          child: Container(
                                                            height: 14,
                                                            width: 14,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Skeletonizer(
                                                          enabled: true,
                                                          child: Container(
                                                            height: 14,
                                                            width: 100,
                                                            color: Colors
                                                                .grey[300],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 10),
                                                    child: Row(
                                                      children: <Widget>[
                                                        const Spacer(),
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          child: Skeletonizer(
                                                            enabled: true,
                                                            child: Container(
                                                              height: 24,
                                                              width: 60,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ]),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  // else
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 16.0),
                  //     child: const Center(
                  //       child: CircularProgressIndicator(
                  //         color: yellow,
                  //       ),
                  //     ),
                  //   )
                  // Flexible(
                  //   child: ListView.builder(
                  //     itemCount: searchResults.length,
                  //     itemBuilder: (_, index) {
                  //       final billModel = _billboardMdl[index];
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //           vertical: 16.0,
                  //         ),
                  //         child: StaggeredCardCard(
                  //           begin: Color(0xffFCE183),
                  //           end: Color(0xffF68D7F),
                  //           categoryName: billModel.nomorHp,
                  //           assetPath: searchResults[index].image,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          floatingActionButton: admin
              ? FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: green,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const TambahBillboardPage1()));
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                )
              : FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: green,
                  onPressed: () {
                    _animationController.forward(from: 0.0);
                    Future.delayed(const Duration(seconds: 2));
                    setState(() {
                      _billboardMdl = [];
                      refreshBillboardList();
                    });
                  },
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0)
                        .animate(_animationController),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                )),
    );
  }
}
