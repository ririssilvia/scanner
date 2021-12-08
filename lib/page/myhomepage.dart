import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qrcodepeminjaman/model/Barang.dart';
import 'package:qrcodepeminjaman/page/pinjampage.dart';

class MyHomePage extends StatefulWidget {
  //MyHomePage({Key ? key, required this.barangs}) : super(key: key);
  //final Future<List<Barang>> barangs;
  @override
  _MyHomePagestate createState() => _MyHomePagestate();
}

class _MyHomePagestate extends State<MyHomePage> {
  String code = "";
  String getcode = "";

  Future scanbarcode() async {
    getcode = await FlutterBarcodeScanner.scanBarcode(
        "#009922", "cancel", true, ScanMode.DEFAULT);
    setState(() {
      code = getcode;
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => PinjamPage(code)),
        (Route<dynamic> route) => false);
  }

  void setbarang(String idBarang, String nama, String swKelas, String brgNama,
      String spesifikasi, int qty, String tglPinjam) async {
    final String uri =
        'http://192.168.43.154/PeminjamanBarangMenggunakanQCode/api/api_tambah.php';
    Map data = {
      'IdBarang': idBarang,
      'Nama': nama,
      'SwKelas': swKelas,
      'BrgNama': brgNama,
      'Spesifikasi': spesifikasi,
      'qty': qty,
      'TglPinjam': tglPinjam,
      'status': 'Pinjam',
    };
    var body = json.encode(data);
    http.Response result = await http.post(Uri.parse(uri),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body);
    if (result.statusCode == 200) {
      print("Sukses");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR code'),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(),
          children: [
            Image.asset(
              'assets/images/login.png',
              height: 333,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 60,
              child: FlatButton(
                color: Color.fromARGB(43, 144, 255, 255),
                onPressed: () {
                  scanbarcode();
                },
                child: Text(
                  'SCAN QR-CODE',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
