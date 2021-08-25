import 'dart:convert';
import 'api.dart';

class PdfInvData {
  final String nomor;
  final String tanggal;
  final int jumlah;
  final String namacust;
  final String alamat;
  final String telepon;
  final int baris;
  final String namaitem;
  final int qty;
  final int harga;
  final int subtotal;

  PdfInvData(
      this.nomor,
      this.tanggal,
      this.jumlah,
      this.namacust,
      this.alamat,
      this.telepon,
      this.baris,
      this.namaitem,
      this.qty,
      this.harga,
      this.subtotal);

  factory PdfInvData.fromMap(Map<String, dynamic> json) {
    return PdfInvData(
        json['nomor'],
        json['tanggal'],
        json['jumlah'],
        json['namacust'],
        json['alamat'],
        json['telepon'],
        json['baris'],
        json['namaitem'],
        json['qty'],
        json['harga'],
        json['subtotal']);
  }
  factory PdfInvData.fromJson(Map<String, dynamic> json) {
    return PdfInvData(
        json['nomor'],
        json['tanggal'],
        json['jumlah'],
        json['namacust'],
        json['alamat'],
        json['telepon'],
        json['baris'],
        json['namaitem'],
        json['qty'],
        json['harga'],
        json['subtotal']);
  }
}

class PdfInv {
  List<PdfInvData> decodeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PdfInvData>((json) => PdfInvData.fromMap(json))
        .toList();
  }

  Future<List<PdfInvData>> read(id) async {
    String apiURL = "https://project.graylite.com/tgp/dbwebbb/printinv/$id";

    List<PdfInvData> retval;
    var responseBody = await callAPI(apiURL);
    retval = decodeData(responseBody);
    return retval;
  }

  void update(apiURL) async {
//    String apiURL = "https://project.graylite.com/tgp/dbweb/lht/all";
    await callAPI(apiURL);
  }
}