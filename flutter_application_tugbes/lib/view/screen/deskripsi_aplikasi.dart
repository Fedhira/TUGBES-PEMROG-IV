import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_application_tugbes/app_properties.dart';

class InfoAplikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: yellow,
      // appBar: AppBar(
      //   title: Text('Info Aplikasi'),
      //   backgroundColor: Colors.white,
      // ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: yellow,
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
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: 'Deskripsi Aplikasi',
              content:
                  'Aplikasi penyewaan billboard mirip dengan toko online untuk iklan besar di pinggir jalan yang biasa kita lihat. Aplikasi ini memungkinkan pengiklan untuk dengan mudah mencari dan menyewa lokasi untuk menampilkan iklan mereka di billboard. Dengan hanya beberapa kali sentuh di layar, mereka dapat memilih lokasi, melihat harga sewa, dan bahkan mengatur durasi tayang iklan. Dengan menggunakan aplikasi ini, penyewaan billboard menjadi lebih cepat dan efisien, tanpa perlu mengalami kesulitan dengan metode konvensional. Aplikasi ini dapat menjadi solusi yang sederhana dan efektif jika Anda ingin iklan Anda terlihat secara strategis.',
            ),
            SizedBox(height: 20),
            _buildSectionCard(
              title: 'Tujuan Aplikasi',
              content:
                  'Kemudahan Penyewaan: Aplikasi ini bertujuan memberikan kemudahan dalam proses penyewaan ruang iklan billboard tanpa memerlukan langkah-langkah rumit.\n\n'
                  'Pencarian Lokasi yang Efisien: Tujuan aplikasi adalah memberikan pengiklan alat pencarian yang efisien untuk menemukan lokasi billboard yang strategis sesuai dengan target audiens mereka.\n\n'
                  'Transparansi Harga: Aplikasi ini dirancang untuk memberikan transparansi dalam hal harga sewa, memungkinkan pengguna untuk dengan jelas melihat dan memahami biaya yang terkait dengan kampanye iklan mereka.\n\n'
                  'Kemudahan Berkomunikasi: Melalui aplikasi ini, pengiklan dapat dengan mudah berkomunikasi dengan pemilik billboard atau pihak terkait untuk memastikan bahwa kampanye iklan berjalan sesuai rencana.',
            ),
            SizedBox(height: 20),
            Center(
              child: _buildSectionCard(
                title: 'Tim Pembuat Aplikasi',
                content:
                    'Fatwa Fathillah Fatah - 1214038\nFedhira Syaila Putri A - 1214028',
              ),
            ),
            SizedBox(height: 20),
          ]
              .map(
                (widget) => FadeInUp(
                  duration: Duration(milliseconds: 1300),
                  child: widget,
                ),
              )
              .toList(),
        ),
      ),
      // floatingActionButton: FadeInUp(
      //   duration: Duration(milliseconds: 1300),
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => AdminNavigationBar(
      //                   currentPageIndex: 3,
      //                 )),
      //       );
      //     },
      //     child: Icon(Icons.arrow_forward),
      //     backgroundColor: Colors.black,
      //     elevation: 5,
      //   ),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSectionCard({required String title, required String content}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              content,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
