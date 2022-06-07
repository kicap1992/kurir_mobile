// dart model for kurir

// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

class KurirModel {
  String? id;
  String? nama;
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
