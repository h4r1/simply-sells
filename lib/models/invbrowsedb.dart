import 'dart:convert';
import '../includes/api.dart';


class InvBrowseData {
  final int id;
  final String nomor;
  final String tanggal;
  final int jumlah;
  final String nama;

  InvBrowseData(this.id, this.nomor, this.tanggal, this.jumlah, this.nama);

  factory InvBrowseData.fromMap(Map<String, dynamic> json) {
    return InvBrowseData(json['id'], json['nomor'], json['tanggal'],
        json['jumlah'], json['nama']);
  }
  factory InvBrowseData.fromJson(Map<String, dynamic> json) {
    return InvBrowseData(json['id'], json['nomor'], json['tanggal'],
        json['jumlah'], json['nama']);
  }
}

class InvBrowse {
  List<InvBrowseData> decodeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<InvBrowseData>((json) => InvBrowseData.fromMap(json))
        .toList();
  }

  Future<List<InvBrowseData>> read() async {
    String apiURL = "https://project.graylite.com/tgp/dbwebbb/browseinv";

    List<InvBrowseData> retval;
    var responseBody = await callAPI(apiURL);
    retval = decodeData(responseBody);
    return retval;
  }
}
