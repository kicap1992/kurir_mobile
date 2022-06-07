// ignore_for_file: file_names, non_constant_identifier_names

class PetaKecamatanModel {
  String kecamatan;
  List<dynamic> polygon;

  PetaKecamatanModel({
    required this.kecamatan,
    required this.polygon,
  });

  factory PetaKecamatanModel.fromJson(Map<String, dynamic> json) =>
      PetaKecamatanModel(
        kecamatan: json["kecamatan"],
        polygon: List<dynamic>.from(json["polygon"].map((x) => x)),
      );
}

class LatitudeLongitude {
  double latitude;
  double longitude;

  LatitudeLongitude({
    required this.latitude,
    required this.longitude,
  });

  factory LatitudeLongitude.fromJson(Map<String, dynamic> json) =>
      LatitudeLongitude(
        latitude: json["lat"].toDouble(),
        longitude: json["lng"].toDouble(),
      );
}

class PetaKelurahanDesaModel {
  String kelurahan_desa;
  List<dynamic>? polygon;

  PetaKelurahanDesaModel({
    required this.kelurahan_desa,
    this.polygon,
  });

  factory PetaKelurahanDesaModel.fromJson(Map<String, dynamic> json) =>
      PetaKelurahanDesaModel(
        kelurahan_desa: json["kelurahan_desa"],
        polygon: json["polygon"] == null
            ? null
            : List<dynamic>.from(json["polygon"].map((x) => x)),
      );
}
