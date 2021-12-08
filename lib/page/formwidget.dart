import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FormWidget extends StatefulWidget {
  final String IdBarang;
  final String BrgNama;
  final String BrgJumlah;
  FormWidget(this.IdBarang, this.BrgNama, this.BrgJumlah);

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  DateTime selectedDate = DateTime.now();
  String TglPinjam = '';
  String status = '500';
  bool _isFieldNamaValid = false;
  bool _isFieldSwKelasValid = false;
  bool _isFieldQtyValid = false;
  bool _isFieldSpesifikasiValid = false;
  bool _isFieldTglPinjamValid = false;
  TextEditingController _controllerNama = TextEditingController();
  TextEditingController _controllerSwKelas = TextEditingController();
  TextEditingController _controllerSpesifikasi = TextEditingController();
  TextEditingController _controllerQty = TextEditingController();
  DateTime _dateTime = DateTime.now();

  void setbarang(String idBarang, String nama, String swKelas, String brgNama,
      String spesifikasi, int qty, String tglPinjam) async {
    final String uri =
        'http://192.168.43.178/peminjaman/api/api_tambah.php';
    Map data = {
      'IdBarang': idBarang.toString(),
      'Nama': nama.toString(),
      'SwKelas': swKelas.toString(),
      'BrgNama': brgNama.toString(),
      'Spesifikasi': spesifikasi.toString(),
      'qty': int.parse(qty.toString()),
      'TglPinjam': tglPinjam.toString(),
      'TglKembali': tglPinjam.toString(),
      'status': 'Pinjam'
    };
    var body = json.encode(data);
    http.Response result = await http.post(Uri.parse(uri), body: body);
    setState(() {
      status = json.decode(result.body)['status'].toString();
    });
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controllerNama,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Nama Siswa",
            errorText: _isFieldNamaValid == null || _isFieldNamaValid
                ? null
                : "Nama Siswa harus diisi",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldNamaValid) {
              setState(() => _isFieldNamaValid = isFieldValid);
            }
          },
        ),
        TextField(
          controller: _controllerSwKelas,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Kelas",
            errorText: _isFieldSwKelasValid == null || _isFieldSwKelasValid
                ? null
                : "Kelas harus diisi",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldSwKelasValid) {
              setState(() => _isFieldSwKelasValid = isFieldValid);
            }
          },
        ),
        TextField(
          controller: _controllerSpesifikasi,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: "Spesifikasi",
            errorText:
                _isFieldSpesifikasiValid == null || _isFieldSpesifikasiValid
                    ? null
                    : "Spesifikasi harus diisi",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldSpesifikasiValid) {
              setState(() => _isFieldSpesifikasiValid = isFieldValid);
            }
          },
        ),
        TextField(
          controller: _controllerQty,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Qty",
            errorText: _isFieldQtyValid == null || _isFieldQtyValid
                ? null
                : "Qty harus diisi",
          ),
          onChanged: (value) {
            bool isFieldValid = value.trim().isNotEmpty;
            if (isFieldValid != _isFieldQtyValid) {
              setState(() => _isFieldQtyValid = isFieldValid);
            }
          },
        ),
        ElevatedButton(
          child: Text('Tanggal Pinjam'),
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2030))
                .then((date) {
              setState(() {
                _dateTime = date!;
                String formattedDate = DateFormat('yyyy-MM-dd').format(date);
                TglPinjam = formattedDate.toString();
              });
            });
          },
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
                onPressed: () async {
                  if (_isFieldNamaValid == null ||
                      _isFieldQtyValid == null ||
                      _isFieldSpesifikasiValid == null ||
                      _isFieldSwKelasValid == null ||
                      !_isFieldSwKelasValid ||
                      !_isFieldNamaValid ||
                      !_isFieldQtyValid ||
                      !_isFieldSpesifikasiValid) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Maaf!'),
                              content: const Text('Lengkapi form peminjaman'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Kembali'),
                                  child: const Text('Kembali'),
                                ),
                              ],
                            ));
                    return;
                  }
                  if (int.parse(_controllerQty.text.toString()) >
                      int.parse(widget.BrgJumlah)) {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                              title: const Text('Maaf!'),
                              content: const Text('Qty melebihi stok.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Kembali'),
                                  child: const Text('Kembali'),
                                ),
                              ],
                            ));
                  } else {
                    setbarang(
                        widget.IdBarang.toString(),
                        _controllerNama.text.toString(),
                        _controllerSwKelas.text.toString(),
                        widget.BrgNama.toString(),
                        _controllerSpesifikasi.text.toString(),
                        int.parse(_controllerQty.text.toString()),
                        TglPinjam);

                    // if (status == '200') {
                      setState(() {
                        _controllerNama.clear();
                        _controllerQty.clear();
                        _controllerSpesifikasi.clear();
                        _controllerSwKelas.clear();
                      });
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: const Text('Selamat!'),
                                content: const Text('Data berhasil disimpan'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ));
                    // } else {
                    //   showDialog<String>(
                    //       context: context,
                    //       builder: (BuildContext context) => AlertDialog(
                    //             title: const Text('Maaf!'),
                    //             content: const Text('Data gagal disimpan'),
                    //             actions: <Widget>[
                    //               TextButton(
                    //                 onPressed: () =>
                    //                     Navigator.pop(context, 'Kembali'),
                    //                 child: const Text('Kembali'),
                    //               ),
                    //             ],
                    //           ));
                    // }
                  }
                },
                child: Text('SUBMIT')),
          ),
        )
      ],
    );
  }
}
