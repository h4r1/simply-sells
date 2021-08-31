import 'dart:convert';
import '../includes/api.dart';

class CustData {
  final int id;
  final String nama;
  final String alamat;
  final String telepon;

  CustData(this.id, this.nama, this.alamat, this.telepon);

  factory CustData.fromMap(Map<String, dynamic> json) {
    return CustData(json['id'], json['nama'], json['alamat'], json['telepon']);
  }
  factory CustData.fromJson(Map<String, dynamic> json) {
    return CustData(json['id'], json['nama'], json['alamat'], json['telepon']);
  }
}

class Cust {
  List<CustData> decodeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<CustData>((json) => CustData.fromMap(json)).toList();
  }

  Future<List<CustData>> read() async {
    String apiURL = "https://project.graylite.com/tgp/dbweb/bb.cust/all";

    List<CustData> retval;
    var responseBody = await callAPI(apiURL);
    retval = decodeData(responseBody);
    return retval;
  }

  void update(apiURL) async {
//    String apiURL = "https://project.graylite.com/tgp/dbweb/lht/all";
    await callAPI(apiURL);
  }
}
