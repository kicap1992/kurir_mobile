// ignore_for_file: file_names

import 'package:kurir/models/usersModel.dart';

class PengirimanModel {
  KordinatPengiriman? kordinatPengiriman;
  KordinatPermulaan? kordinatPermulaan;
  Biaya? biaya;
  String? sId;
  String? namaPenerima;
  String? noTelponPenerima;
  String? alamatPenerima;
  String? statusPengiriman;
  KurirModel? kurir;
  PengirimModel? pengirim;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? fotoPengiriman;

  PengirimanModel(
      {this.kordinatPengiriman,
      this.kordinatPermulaan,
      this.biaya,
      this.sId,
      this.namaPenerima,
      this.noTelponPenerima,
      this.alamatPenerima,
      this.statusPengiriman,
      this.kurir,
      this.pengirim,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.fotoPengiriman});

  PengirimanModel.fromJson(Map<String, dynamic> json) {
    kordinatPengiriman = json['kordinat_pengiriman'] != null
        ? KordinatPengiriman.fromJson(json['kordinat_pengiriman'])
        : null;
    kordinatPermulaan = json['kordinat_permulaan'] != null
        ? KordinatPermulaan.fromJson(json['kordinat_permulaan'])
        : null;
    biaya = json['biaya'] != null ? Biaya.fromJson(json['biaya']) : null;
    sId = json['_id'];
    namaPenerima = json['nama_penerima'];
    noTelponPenerima = json['no_telpon_penerima'];
    alamatPenerima = json['alamat_penerima'];
    statusPengiriman = json['status_pengiriman'];
    kurir = json['kurir'] != null ? KurirModel.fromJson(json['kurir']) : null;
    pengirim = json['pengirim'] != null
        ? PengirimModel.fromJson(json['pengirim'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    iV = json['__v'];
    fotoPengiriman = json['foto_pengiriman'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (kordinatPengiriman != null) {
      data['kordinat_pengiriman'] = kordinatPengiriman!.toJson();
    }
    if (kordinatPermulaan != null) {
      data['kordinat_permulaan'] = kordinatPermulaan!.toJson();
    }
    if (biaya != null) {
      data['biaya'] = biaya!.toJson();
    }
    data['_id'] = sId;
    data['nama_penerima'] = namaPenerima;
    data['no_telpon_penerima'] = noTelponPenerima;
    data['alamat_penerima'] = alamatPenerima;
    data['status_pengiriman'] = statusPengiriman;
    if (kurir != null) {
      data['kurir'] = kurir!.toJson();
    }
    if (pengirim != null) {
      data['pengirim'] = pengirim!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['__v'] = iV;
    data['foto_pengiriman'] = fotoPengiriman;
    return data;
  }
}

class KordinatPengiriman {
  String? lat;
  String? lng;
  String? kelurahanDesa;

  KordinatPengiriman({this.lat, this.lng, this.kelurahanDesa});

  KordinatPengiriman.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    kelurahanDesa = json['kelurahan_desa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    data['kelurahan_desa'] = kelurahanDesa;
    return data;
  }
}

class KordinatPermulaan {
  String? lat;
  String? lng;

  KordinatPermulaan({this.lat, this.lng});

  KordinatPermulaan.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}

class Biaya {
  int? biayaMinimal;
  int? biayaMaksimal;
  int? biayaPerKilo;

  Biaya({this.biayaMinimal, this.biayaMaksimal, this.biayaPerKilo});

  Biaya.fromJson(Map<String, dynamic> json) {
    biayaMinimal = json['biaya_minimal'];
    biayaMaksimal = json['biaya_maksimal'];
    biayaPerKilo = json['biaya_per_kilo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['biaya_minimal'] = biayaMinimal;
    data['biaya_maksimal'] = biayaMaksimal;
    data['biaya_per_kilo'] = biayaPerKilo;
    return data;
  }
}
