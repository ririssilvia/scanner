class Barang {
  String IdBarang;
  String BrgNama;
  String BrgMerk;
  String BrgJumlah;

  String get getIdBarang => this.IdBarang;

  set setIdBarang(String IdBarang) => this.IdBarang = IdBarang;

  get getBrgNama => this.BrgNama;

  set setBrgNama(BrgNama) => this.BrgNama = BrgNama;

  get getBrgMerk => this.BrgMerk;

  set setBrgMerk(BrgMerk) => this.BrgMerk = BrgMerk;

  get getBrgJumlah => this.BrgJumlah;

  set setBrgJumlah(BrgJumlah) => this.BrgJumlah = BrgJumlah;

  Barang(this.IdBarang, this.BrgNama, this.BrgMerk, this.BrgJumlah);

  factory Barang.fromMap(Map<String, dynamic> json) {
    return Barang(
      json['IdBarang'],
      json['BrgNama'],
      json['BrgMerk'],
      json['BrgJumlah'],
    );
  }
}
