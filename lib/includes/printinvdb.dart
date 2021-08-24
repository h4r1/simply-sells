import 'dart:convert';
import 'api.dart';

class PrintInvData {
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

  PrintInvData(
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

  factory PrintInvData.fromMap(Map<String, dynamic> json) {
    return PrintInvData(
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
  factory PrintInvData.fromJson(Map<String, dynamic> json) {
    return PrintInvData(
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

class PrintInv {
  List<PrintInvData> decodeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<PrintInvData>((json) => PrintInvData.fromMap(json))
        .toList();
  }

  Future<List<PrintInvData>> read(id) async {
    String apiURL = "https://project.graylite.com/tgp/dbwebbb/printinv/$id";

    List<PrintInvData> retval;
    var responseBody = await callAPI(apiURL);
    retval = decodeData(responseBody);
    return retval;
  }

  void update(apiURL) async {
//    String apiURL = "https://project.graylite.com/tgp/dbweb/lht/all";
    await callAPI(apiURL);
  }
}
