import 'package:flutter_application_tugbes/app_properties.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/model/sewa_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/screen/detail_sewa_page.dart';
import 'package:flutter_application_tugbes/view/widget/response_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skeletonizer/skeletonizer.dart';

// ignore: must_be_immutable
class SewaPage extends StatefulWidget {
  DataResponse? res;

  SewaPage({super.key, this.res});

  @override
  // ignore: library_private_types_in_public_api
  _SewaPageState createState() => _SewaPageState();
}

class _SewaPageState extends State<SewaPage> {
  List<SewaModel> searchResults = [];
  List<SewaModel> _sewaMdl = [];
  final ApiServices _dataService = ApiServices();
  TextEditingController searchController = TextEditingController();
  Iterable<SewaModel>? sewa;

  @override
  void initState() {
    super.initState();
    searchResults = _sewaMdl;
    refreshBillboardList();
  }

  void refreshBillboardList() async {
    try {
      sewa = await _dataService.getAllSewa();
      final Iterable<SewaModel> booked = sewa!
          .where((element) => element.bayar == null && element.status == null);
      final Iterable<SewaModel> bayar = sewa!
          .where((element) => element.bayar == true && element.status == null);
      final Iterable<SewaModel> approve = sewa!
          .where((element) => element.bayar == true && element.status == true);
      Iterable<SewaModel> temp = bayar.followedBy(booked).followedBy(approve);
      setState(() {
        if (sewa != null) {
          _sewaMdl.addAll(temp);
          if (sewa!.isEmpty) {
            _sewaMdl.addAll([
              SewaModel(
                  idbillboard: "idbillboard",
                  kode: "kode",
                  nama: "nama",
                  panjang: "panjang",
                  lebar: "lebar",
                  harga: "harga",
                  latitude: "latitude",
                  longitude: "longitude",
                  address: "address",
                  regency: "regency",
                  district: "district",
                  village: "village",
                  gambar: "gambar",
                  id: "id",
                  content: "content",
                  tanggalMulai: "tanggalMulai",
                  tanggalSelesai: "tanggalSelesai",
                  iduser: "iduser",
                  namaLengkap: "namaLengkap",
                  ktp: "ktp",
                  email: "email",
                  noHp: "noHp")
            ]);
          }
        }
      });
      print("object");
      print(_sewaMdl.isEmpty);
      print(_sewaMdl.isNotEmpty);
      print(sewa != null);
      print(_sewaMdl);
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
          _sewaMdl = [];
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
                      'Daftar Sewa',
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
                        List<SewaModel> tempList = [];
                        for (var billboard in _sewaMdl) {
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
                          _sewaMdl.addAll(sewa!);
                        });
                      }
                    },
                  ),
                ),
                messageCard(context),
                // if (_sewaMdl.isNotEmpty)
                Expanded(
                  child: Skeletonizer(
                    ignoreContainers: true,
                    enabled: _sewaMdl.isEmpty,
                    child: ListView.builder(
                      itemCount: _sewaMdl.isNotEmpty ? _sewaMdl.length : 10,
                      itemBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _sewaMdl.isNotEmpty &&
                                  _sewaMdl[index].idbillboard == "idbillboard"
                              ? const Center(
                                  child: Text("Kamu belum melakukan sewa"),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetailSewaPage(
                                                  sewa: _sewaMdl[index],
                                                )));
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: _sewaMdl.isNotEmpty
                                            ? LinearGradient(
                                                colors: _sewaMdl[index].bayar ==
                                                            null &&
                                                        _sewaMdl[index]
                                                                .status ==
                                                            null
                                                    ? [yellow, Colors.white]
                                                    : _sewaMdl[index]
                                                                .bayar! &&
                                                            _sewaMdl[index]
                                                                    .status ==
                                                                null
                                                        ? [
                                                            Colors.green,
                                                            Colors.white
                                                          ]
                                                        : [
                                                            Colors.blue,
                                                            Colors.white
                                                          ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight)
                                            : null,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: _sewaMdl.isNotEmpty
                                                        ? Image.network(
                                                            _sewaMdl[index]
                                                                .content,
                                                            height: 100,
                                                            width: 100,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Skeletonizer(
                                                            enabled: true,
                                                            child: Container(
                                                              height: 100,
                                                              width: 100,
                                                              color: Colors
                                                                  .grey[300],
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children:
                                                          _sewaMdl.isNotEmpty
                                                              ? <Widget>[
                                                                  Container(
                                                                      height:
                                                                          5),
                                                                  Text(
                                                                    _sewaMdl[
                                                                            index]
                                                                        .nama,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          19,
                                                                      color: Colors
                                                                              .grey[
                                                                          800],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Iconsax
                                                                              .timer_start_copy,
                                                                          color: Colors.grey[
                                                                              800],
                                                                          size:
                                                                              14),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        _sewaMdl[index]
                                                                            .tanggalMulai,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey[800],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .timer_off_outlined,
                                                                          color: Colors.grey[
                                                                              700],
                                                                          size:
                                                                              14),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        _sewaMdl[index]
                                                                            .tanggalSelesai,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.grey[800],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ]
                                                              : <Widget>[
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    child:
                                                                        Skeletonizer(
                                                                      enabled:
                                                                          true,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            19,
                                                                        width:
                                                                            200,
                                                                        color: Colors
                                                                            .grey[300],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Iconsax
                                                                              .timer_start_copy,
                                                                          color: Colors.grey[
                                                                              800],
                                                                          size:
                                                                              14),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Skeletonizer(
                                                                          enabled:
                                                                              true,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                14,
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.grey[300],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          10),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .timer_off_outlined,
                                                                          color: Colors.grey[
                                                                              700],
                                                                          size:
                                                                              14),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                        child:
                                                                            Skeletonizer(
                                                                          enabled:
                                                                              true,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                14,
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.grey[300],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ]),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.chevron_right,
                                                      color: Colors.black,
                                                      size: 30),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Expanded(
                                          //   // padding: const EdgeInsets.fromLTRB(
                                          //   //     15, 15, 15, 0),
                                          //   child: Column(
                                          //       crossAxisAlignment:
                                          //           CrossAxisAlignment.start,
                                          //       children: _sewaMdl.isNotEmpty
                                          //           ? <Widget>[
                                          //               Text(
                                          //                 _sewaMdl[index].nama,
                                          //                 style: TextStyle(
                                          //                   fontSize: 24,
                                          //                   color: Colors.grey[800],
                                          //                 ),
                                          //               ),
                                          //               SizedBox(height: 10),
                                          //               Row(
                                          //                 children: [
                                          //                   Icon(Icons.location_on,
                                          //                       color: Colors.grey[700],
                                          //                       size: 14),
                                          //                   SizedBox(width: 5),
                                          //                   Text(
                                          //                     _sewaMdl[index]
                                          //                         .address,
                                          //                     style: TextStyle(
                                          //                       fontSize: 19,
                                          //                       color: Colors.grey[700],
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //               SizedBox(height: 10),
                                          //               Row(
                                          //                 children: [
                                          //                   Icon(Iconsax.size,
                                          //                       color: Colors.grey[700],
                                          //                       size: 14),
                                          //                   SizedBox(width: 5),
                                          //                   Text(
                                          //                     "${_sewaMdl[index].panjang} x ${_sewaMdl[index].lebar} m",
                                          //                     style: TextStyle(
                                          //                       fontSize: 14,
                                          //                       color: Colors.grey[700],
                                          //                     ),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //               Row(
                                          //                 children: <Widget>[
                                          //                   const Spacer(),
                                          //                   TextButton(
                                          //                     style:
                                          //                         TextButton.styleFrom(
                                          //                       foregroundColor:
                                          //                           Colors.transparent,
                                          //                     ),
                                          //                     child: const Text(
                                          //                       "LIHAT",
                                          //                       style: TextStyle(
                                          //                           color:
                                          //                               Colors.black),
                                          //                     ),
                                          //                     onPressed: () {
                                          //                       Navigator.push(
                                          //                           context,
                                          //                           MaterialPageRoute(
                                          //                               builder:
                                          //                                   (context) =>
                                          //                                       DetailSewaPage(
                                          //                                         billboard:
                                          //                                             _sewaMdl[index],
                                          //                                       )));
                                          //                     },
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ]
                                          //           : <Widget>[
                                          //               ClipRRect(
                                          //                 borderRadius:
                                          //                     BorderRadius.circular(8),
                                          //                 child: Skeletonizer(
                                          //                   enabled: true,
                                          //                   child: Container(
                                          //                     height: 24,
                                          //                     width: 200,
                                          //                     color: Colors.grey[300],
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //               SizedBox(height: 10),
                                          //               ClipRRect(
                                          //                 borderRadius:
                                          //                     BorderRadius.circular(8),
                                          //                 child: Skeletonizer(
                                          //                   enabled: true,
                                          //                   child: Container(
                                          //                     height: 19,
                                          //                     width: 150,
                                          //                     color: Colors.grey[300],
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //               SizedBox(height: 10),
                                          //               ClipRRect(
                                          //                 borderRadius:
                                          //                     BorderRadius.circular(8),
                                          //                 child: Skeletonizer(
                                          //                   enabled: true,
                                          //                   child: Container(
                                          //                     height: 14,
                                          //                     width: 100,
                                          //                     color: Colors.grey[300],
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //               Padding(
                                          //                 padding:
                                          //                     const EdgeInsets.only(
                                          //                         bottom: 10),
                                          //                 child: Row(
                                          //                   children: <Widget>[
                                          //                     const Spacer(),
                                          //                     ClipRRect(
                                          //                       borderRadius:
                                          //                           BorderRadius
                                          //                               .circular(8),
                                          //                       child: Skeletonizer(
                                          //                         enabled: true,
                                          //                         child: Container(
                                          //                           height: 24,
                                          //                           width: 60,
                                          //                           color: Colors
                                          //                               .grey[300],
                                          //                         ),
                                          //                       ),
                                          //                     )
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             ]),
                                          // ),
                                          SizedBox(height: 5),
                                        ],
                                      ),
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
                //       final billModel = _sewaMdl[index];
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
        // floatingActionButton: FloatingActionButton(
        //   shape: const CircleBorder(),
        //   backgroundColor: green,
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const TambahSewaPage1()));
        //   },
        //   child: const Icon(
        //     Icons.add,
        //     color: Colors.white,
        //   ),
        // ),
      ),
    );
  }
}
