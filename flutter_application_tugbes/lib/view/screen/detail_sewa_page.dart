import 'package:flutter_application_tugbes/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/model/sewa_model.dart';
import 'package:flutter_application_tugbes/plugins/zoombuttons_plugin.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/admin_navigation_bar.dart';
import 'package:flutter_application_tugbes/view/screen/edit_order_page.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailSewaPage extends StatefulWidget {
  final SewaModel sewa;
  const DetailSewaPage({Key? key, required this.sewa}) : super(key: key);

  @override
  State<DetailSewaPage> createState() => _DetailSewaPageState();
}

class _DetailSewaPageState extends State<DetailSewaPage> {
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
          title: const Text('Batal Sewa'),
          content: Text('Apakah Anda yakin ingin batal sewa $nama ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                DataResponse? res = await _dataService.deleteSewa(id);
                if (res!.status == 204) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AdminNavigationBar(res: res, currentPageIndex: 2),
                    ),
                    (route) => false,
                  );
                } else {
                  displaySnackbar(res.message);
                }
              },
              child: const Text('BATAL'),
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
                  widget.sewa.gambar,
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
                  if (widget.sewa.bayar == true)
                    const Column(
                      children: [
                        Text(
                          "Sudah Dibayar",
                          style: TextStyle(
                              color: Colors.green, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  Text(
                    widget.sewa.nama,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.sewa.address,
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
                    children: widget.sewa.status == null && !admin
                        ? [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditOrderPage(sewa: widget.sewa),
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
                                    widget.sewa.id, widget.sewa.nama);
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
                        : widget.sewa.status == null && admin
                            ? []
                            : [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Approved",
                                    style: TextStyle(
                                        color: Colors
                                            .blue, // Warna background merah
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
                  Text("Detail Sewa",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.sewa.content,
                      width: 200,
                    ),
                  ),
                  list(context, 'Tanggal Mulai: ${widget.sewa.tanggalMulai}'),
                  list(context,
                      'Tanggal Selesai: ${widget.sewa.tanggalSelesai}'),
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
                  list(context, 'Kode: ${widget.sewa.kode}'),
                  list(context,
                      'Ukuran: ${widget.sewa.panjang} x ${widget.sewa.lebar} m'),
                  list(context, 'Harga: Rp. ${widget.sewa.harga}'),
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
                  list(context, 'Kab./Kota: ${widget.sewa.regency}'),
                  list(context, 'Kecamatan: ${widget.sewa.district}'),
                  list(context, 'Kelurahan: ${widget.sewa.village}'),
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
                            double.parse(widget.sewa.latitude),
                            double.parse(widget.sewa.longitude)),
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
                              point: LatLng(double.parse(widget.sewa.latitude),
                                  double.parse(widget.sewa.longitude)),
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
                  ),
                  const SizedBox(
                    height: 35,
                  ),
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
