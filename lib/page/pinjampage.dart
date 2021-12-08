import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qrcodepeminjaman/model/Barang.dart';
import 'package:qrcodepeminjaman/page/formwidget.dart';
import 'package:qrcodepeminjaman/page/myhomepage.dart';

class PinjamPage extends StatefulWidget {
  final String code;
  const PinjamPage(this.code);

  @override
  _PinjamPageState createState() => _PinjamPageState();
}

class _PinjamPageState extends State<PinjamPage> {
  List barang = [];

  Future<Barang> getbarang(String idbarang) async {
    final String uri =
        'http://192.168.43.178/peminjaman/api/api_tampil.php?idbarang=' +
            idbarang;

    http.Response result = await http.get(Uri.parse(uri));
    if (json.decode(result.body)['status'] == 200) {
      Barang barang = Barang.fromMap(json.decode(result.body)['data']);
      return barang;
    } else {
      throw Exception('Failed to fetch access token');
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
        title: Text('Peminjaman'),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => MyHomePage()),
                (Route<dynamic> route) => false)),
      ),
      body: FutureBuilder(
          future: getbarang(widget.code),
          builder: (BuildContext context, AsyncSnapshot<Barang> snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Detail barang',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Nama Barang'),
                              Text(
                                snapshot.data!.BrgNama,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Merk Barang'),
                              Text(
                                snapshot.data!.BrgMerk.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Jumlah Stok Barang'),
                              Text(
                                snapshot.data!.BrgJumlah.toString(),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            'Form Peminjaman',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        FormWidget(
                            snapshot.data!.IdBarang, snapshot.data!.BrgNama, snapshot.data!.BrgJumlah)
                      ],
                    )),
              );
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new CircularProgressIndicator();
          }),
    );
  }
}
