// dart model for kurir

// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

class KurirModel {
  String? id;
  String? nama;
  String? nik;
  String? email;
  String? no_telp;
  String? alamat;
  String? no_kenderaan;
  String? status;
  String? photo_url;
  String? ktp_url;
  String? ktp_holding_url;
  String? kenderaan_url;

  KurirModel({
    this.id,
    this.nama,
    this.nik,
    this.email,
    this.no_telp,
    this.alamat,
    this.no_kenderaan,
    this.status,
    this.photo_url,
    this.ktp_url,
    this.ktp_holding_url,
    this.kenderaan_url,
  });

  factory KurirModel.fromJson(Map<String, dynamic> json) => KurirModel(
        id: json["_id"],
        nama: json["nama"],
        nik: json["nik"],
        email: json["email"],
        no_telp: json["no_telp"],
        alamat: json["alamat"],
        no_kenderaan: json["no_kenderaan"],
        status: json["status"],
        photo_url: json["photo_url"],
        ktp_url: json["ktp_url"],
        ktp_holding_url: json["ktp_holding_url"],
        kenderaan_url: json["kenderaan_url"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nama": nama,
        "nik": nik,
        "email": email,
        "no_telp": no_telp,
        "alamat": alamat,
        "no_kenderaan": no_kenderaan,
        "status": status,
        "photo_url": photo_url,
        "ktp_url": ktp_url,
        "ktp_holding_url": ktp_holding_url,
        "kenderaan_url": kenderaan_url,
      };
}

class Data {
  String? sId;
  String? email;
  String? noTelp;
  String? nama;
  String? alamat;
  String? photoUrl;
  String? status;
  List<String>? pengirimanBarang;

  Data(
      {this.sId,
      this.email,
      this.noTelp,
      this.nama,
      this.alamat,
      this.photoUrl,
      this.status,
      this.pengirimanBarang});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    noTelp = json['no_telp'];
    nama = json['nama'];
    alamat = json['alamat'];
    photoUrl = json['photo_url'];
    status = json['status'];
    pengirimanBarang = json['pengiriman_barang'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['no_telp'] = noTelp;
    data['nama'] = nama;
    data['alamat'] = alamat;
    data['photo_url'] = photoUrl;
    data['status'] = status;
    data['pengiriman_barang'] = pengirimanBarang;
    return data;
  }
}

class coba {
  String? message;
  List<Data>? data;

  coba({this.message, this.data});

  coba.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PengirimModel {
  String? sId;
  String? email;
  String? noTelp;
  String? nama;
  String? alamat;
  String? photoUrl;
  String? status;
  List<String>? pengirimanBarang;

  PengirimModel(
      {this.sId,
      this.email,
      this.noTelp,
      this.nama,
      this.alamat,
      this.photoUrl,
      this.status,
      this.pengirimanBarang});

  PengirimModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    noTelp = json['no_telp'];
    nama = json['nama'];
    alamat = json['alamat'];
    photoUrl = json['photo_url'];
    status = json['status'];
    pengirimanBarang = json['pengiriman_barang'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['no_telp'] = noTelp;
    data['nama'] = nama;
    data['alamat'] = alamat;
    data['photo_url'] = photoUrl;
    data['status'] = status;
    data['pengiriman_barang'] = pengirimanBarang;
    return data;
  }
}
