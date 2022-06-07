// ignore_for_file: file_names

class PengaturanBiayaKurirModel {
  int? minimalBiayaPengiriman;
  int? maksimalBiayaPengiriman;
  int? biayaPerKilo;

  PengaturanBiayaKurirModel({
    this.minimalBiayaPengiriman,
    this.maksimalBiayaPengiriman,
    this.biayaPerKilo,
  });

  factory PengaturanBiayaKurirModel.fromJson(Map<String, dynamic> json) =>
      PengaturanBiayaKurirModel(
        minimalBiayaPengiriman: json["biaya_minimal"],
        maksimalBiayaPengiriman: json["biaya_maksimal"],
        biayaPerKilo: json["biaya_per_kilo"],
      );

  Map<String, dynamic> toJson() => {
        "biaya_minimal": minimalBiayaPengiriman,
        "biaya_maksimal": maksimalBiayaPengiriman,
        "biaya_per_kilo": biayaPerKilo,
      };
}
