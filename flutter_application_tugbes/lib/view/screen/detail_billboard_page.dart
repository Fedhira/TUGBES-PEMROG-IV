import 'package:flutter_application_tugbes/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/plugins/zoombuttons_plugin.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/admin_navigation_bar.dart';
import 'package:flutter_application_tugbes/view/screen/edit_billboard_page_1.dart';
import 'package:flutter_application_tugbes/view/screen/order_billboard_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBillboardPage extends StatefulWidget {
  final BillboardsModel billboard;
  const DetailBillboardPage({Key? key, required this.billboard})
      : super(key: key);

  @override
  State<DetailBillboardPage> createState() => _DetailBillboardPageState();
}

class _DetailBillboardPageState extends State<DetailBillboardPage> {
  final ApiServices _dataService = ApiServices();
  late SharedPreferences logindata;
  bool admin = true;

  @override
  void initState() {
    super.initState();
    initial();
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

  void _showDeleteConfirmationDialog(String id, String nama) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus data $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                DataResponse? res = await _dataService.deleteBillboard(id);
                if (res!.status == 204) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdminNavigationBar(res: res, currentPageIndex: 1),
                    ),
                    (route) => false,
                  );
                } else {
                  displaySnackbar(res.message);
                }
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [yellow, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.network(
                  widget.billboard.gambar,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 350,
                ),
              ),
              buttonArrow(context),
              scroll(),
            ],
          ),
        ),
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Colors.black,
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 1.0,
        minChildSize: 0.6,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.billboard.nama,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.billboard.address,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: secondaryText),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: !widget.billboard.booking && admin
                        ? [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditBillboardPage1(
                                      billboard: widget.billboard,
                                    ),
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: yellow,
                                child: Icon(
                                  Iconsax.edit_2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                            // ),
                            InkWell(
                              onTap: () {
                                _showDeleteConfirmationDialog(
                                    widget.billboard.id, widget.billboard.nama);
                              },
                              child: const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ]
                        : !widget.billboard.booking && !admin
                            ? [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderBillboardPage(
                                          idbillboard: widget.billboard.id,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const CircleAvatar(
                                    radius: 25,
                                    backgroundColor: green,
                                    child: Icon(
                                      Icons.shopping_cart_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ]
                            : [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Booked",
                                    style: TextStyle(
                                        color: Colors
                                            .red, // Warna background merah
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .fontSize,
                                        fontStyle: FontStyle.italic
                                        // Menggunakan ukuran font yang sama dengan gaya temanya
                                        ),
                                  ),
                                )
                              ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text("Description",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  list(context, 'Kode: ${widget.billboard.kode}'),
                  list(context,
                      'Ukuran: ${widget.billboard.panjang} x ${widget.billboard.lebar} m'),
                  list(context, 'Harga: Rp. ${widget.billboard.harga}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      height: 4,
                    ),
                  ),
                  Text(
                    "Lokasi",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  list(context, 'Kab./Kota: ${widget.billboard.regency}'),
                  list(context, 'Kecamatan: ${widget.billboard.district}'),
                  list(context, 'Kelurahan: ${widget.billboard.village}'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 200,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                            double.parse(widget.billboard.latitude),
                            double.parse(widget.billboard.longitude)),
                        initialZoom: 16.0,
                        keepAlive: true,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(
                                  double.parse(widget.billboard.latitude),
                                  double.parse(widget.billboard.longitude)),
                              child: const Icon(
                                Icons.location_on,
                                size: 45.0,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
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
                  )
                ],
              ),
            ),
          );
        });
  }

  list(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 10,
            backgroundColor: Color(0xFFE3FFF8),
            child: Icon(
              Iconsax.minus_copy,
              size: 15,
              color: primary,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: secondaryText),
          ),
        ],
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
