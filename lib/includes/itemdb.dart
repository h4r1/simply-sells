import 'dart:convert';
import 'api.dart';

class ItemData {
  final int id;
  final String nama;
  final int harga;

  ItemData(this.id, this.nama, this.harga);

  factory ItemData.fromMap(Map<String, dynamic> json) {
    return ItemData(json['id'], json['nama'], json['harga']);
  }
  factory ItemData.fromJson(Map<String, dynamic> json) {
    return ItemData(json['id'], json['nama'], json['harga']);
  }
}

class Item {
  List<ItemData> decodeData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ItemData>((json) => ItemData.fromMap(json)).toList();
  }

  Future<List<ItemData>> read() async {
    String apiURL = "https://project.graylite.com/tgp/dbweb/bb.item/all";

    List<ItemData> retval;
    var responseBody = await callAPI(apiURL);
    retval = decodeData(responseBody);
    return retval;
  }

  void update(apiURL) async {
//    String apiURL = "https://project.graylite.com/tgp/dbweb/lht/all";
    await callAPI(apiURL);
  }
}
