import 'package:flutter/material.dart';
import 'package:flutter_application_tugbes/main.dart';
import 'package:flutter_application_tugbes/model/billboards_model.dart';
import 'package:flutter_application_tugbes/model/response_model.dart';
import 'package:flutter_application_tugbes/services/api_services.dart';
import 'package:flutter_application_tugbes/view/widget/response_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_tugbes/services/auth_manager.dart';
// import 'package:flutter_application_tugbes/view/screen/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtl = TextEditingController();
  final _numberCtl = TextEditingController();
  String _result = '-';
  final ApiServices _dataService = ApiServices();
  final List<BillboardsModel> _billboardMdl = [];
  DataResponse? res;
  bool isEdit = false;
  String idBillboard = '';

  late SharedPreferences logindata;
  String email = '';
  String token = '';

  @override
  void initState() {
    super.initState();
    inital();
  }

  void inital() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      email = logindata.getString('email').toString();
      token = logindata.getString('token').toString();
    });
  }

  Future<void> refreshBillboardList() async {
    final users = await _dataService.getAllBillboard();
    setState(() {
      if (_billboardMdl.isNotEmpty) _billboardMdl.clear();
      if (users != null) _billboardMdl.addAll(users);
    });
  }

  @override
  void dispose() {
    _nameCtl.dispose();
    _numberCtl.dispose();
    super.dispose();
  }

  Widget hasilCard(BuildContext context) {
    return Column(children: [
      if (res != null)
        ResponseCard(
          res: res!,
          onDismissed: () {
            setState(() {
              res = null;
            });
          },
        )
      else
        const Text(''),
    ]);
  }

  Widget _buildListBillboard() {
    return ListView.separated(
        itemBuilder: (context, index) {
          final ctList = _billboardMdl[index];
          return Card(
            child: ListTile(
              // leading: Text(ctList.id),
              title: Text(ctList.kode),
              subtitle: Text(ctList.nama),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () async {
                      final billboards =
                          await _dataService.getSingleBillboard(ctList.id);
                      setState(() {
                        if (billboards != null) {
                          _nameCtl.text = billboards.kode;
                          _numberCtl.text = billboards.nama;
                          isEdit = true;
                          idBillboard = billboards.id;
                        }
                      });
                    },
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () {
                      _showDeleteConfirmationDialog(ctList.id, ctList.kode);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10.0),
        itemCount: _billboardMdl.length);
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
                setState(() {
                  res = res;
                });
                Navigator.of(context).pop();
                await refreshBillboardList();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(
        title: const Text('Billboards API'),
        actions: [
          IconButton(
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                color: Colors.tealAccent,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.account_circle_rounded),
                            const SizedBox(width: 8.0),
                            Text(
                              'Login sebagai : $email',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.key),
                            const SizedBox(width: 8.0),
                            Text(
                              'Token : token',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameCtl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nama',
                  suffixIcon: IconButton(
                    onPressed: _nameCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: _numberCtl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Nomor HP',
                  suffixIcon: IconButton(
                    onPressed: _numberCtl.clear,
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: [
                      // ElevatedButton(
                      //   onPressed: () async {
                      //     if (_nameCtl.text.isEmpty ||
                      //         _numberCtl.text.isEmpty) {
                      //       displaySnackbar('Semua field harus diisi');
                      //       return;
                      //     }
                      //     final postModel = BillboardInput(
                      //       namaKontak: _nameCtl.text,
                      //       nomorHp: _numberCtl.text,
                      //     );
                      //     DataResponse? res;
                      //     if (isEdit) {
                      //       res = await _dataService.putBillboard(
                      //           idBillboard, postModel);
                      //     } else {
                      //       res = await _dataService.postBillboard(postModel);
                      //     }
                      //     setState(() {
                      //       res = res;
                      //       isEdit = false;
                      //     });
                      //     _nameCtl.clear();
                      //     _numberCtl.clear();
                      //     await refreshBillboardList();
                      //   },
                      //   child: Text(isEdit ? 'UPDATE' : 'POST'),
                      // ),
                      if (isEdit)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () {
                            _nameCtl.clear();
                            _numberCtl.clear();
                            setState(() {
                              isEdit = false;
                            });
                          },
                          child: const Text('Cancel Update'),
                        ),
                    ],
                  )
                ],
              ),
              // hasilCard(context),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await refreshBillboardList();
                        setState(() {});
                      },
                      child: const Text('Refresh Data'),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _result = '-';
                        _billboardMdl.clear();
                        res = null;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const Text(
                'List Billboard',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: _billboardMdl.isEmpty
                    ? Text(_result)
                    : _buildListBillboard(),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic displaySnackbar(String msg) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
