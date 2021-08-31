import 'dart:convert';
import 'package:simply_sells/includes/api.dart';

import 'package:simply_sells/includes/pdfapi.dart';
import 'package:simply_sells/models/custdb.dart';
import 'package:simply_sells/models/pdfinvdb.dart';
import 'package:simply_sells/includes/pdfinvapi.dart';

class CItem {
  int id = 0;
  int itemid = 0;
  String nama = '';
  int harga = 0;
  int qty = 0;
  dynamic subtotal = 0;
}

class ShoppingCart {
  static int id = 0;
  static String nomor = "*new*";
  static DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static dynamic custID;
  static dynamic grandTotal;
  static dynamic qtyTotal;

  static List<CItem> itemData = [];

  static List<PdfInvData> printData = [];

  static showPDF() async {
    final pdfFile = await PdfInvoiceApi.generate(printData);
    PdfApi.openFile(pdfFile);
  }

  static loadPDF() async {
    print("Load PDF!");

    if (id == 0) {
      return;
    }
    var retval = PdfInv().read(id);
    retval.then((value) {
      printData = value;
      showPDF();
    });
  }

  static load(int id) async {
    clearCart();

    String url = "https://project.graylite.com/tgp/dbwebbb/readinv/$id";
//    print(url);

    // sqlID for printing
    var response = await callAPI(url);
    var data = json.decode(response);
    var h = data[0];

    ShoppingCart.id = h["id"];
    nomor = h["nomor"];
    String myDate = h["tanggal"];
    myDate = myDate.trim();
    date = DateTime.parse(myDate);
    grandTotal = h["jumlah"];

    custID =
        new CustData(h["custid"], h["namacust"], h["alamat"], h["telepon"]);

    data.forEach((item) {
      CItem newItem = CItem();
      newItem.id = item["rowid"];
      newItem.itemid = item["itemid"];
      newItem.nama = item["namaitem"];
      newItem.harga = item["harga"];
      newItem.qty = item["qty"];
      newItem.subtotal = item["subtotal"];
      itemData.add(newItem);
    });
  }

  static save() async {
    print("Save invoice to database...");
/*
https://project.graylite.com/tgp/dbhdrdtl/insertnewid/
{"header":"BB.SI","hcolumn":{"nomor":"C0001","tanggal":"2021-8-24","custid":3,"jumlah":22000},
"detail":"BB.SI2","dcolumn":[
{"baris":1,"itemid":3,"qty":2,"harga":5000,"subtotal":10000},
{"baris":2,"itemid":1,"qty":3,"harga":4000,"subtotal":12000}
]}

https://project.graylite.com/tgp/dbhdrdtl/savesi/
{"header":"BB.SI","hcolumn":{"id":3,"nomor":"C0001","tanggal":"2021-8-31","custid":3,"jumlah":31000},
"detail":"BB.SI2","dcolumn":[
{"id":5,"baris":1,"itemid":3,"qty":3,"harga":5000,"subtotal":15000},
{"id":6,"baris":2,"itemid":1,"qty":4,"harga":4000,"subtotal":16000}
]}
*/

    String myDate = "${date.year}-${date.month}-${date.day}";
    String hdr =
        '{"id":$id,"nomor":"$nomor","tanggal":"$myDate","custid":${custID.id},"jumlah":$grandTotal';
    String dtl = '';

    for (var i = 0; i < itemData.length; i++) {
      var subtotal = itemData[i].qty * itemData[i].harga;
      dtl +=
          '{"id":${itemData[i].id},"baris":${i + 1},"itemid":${itemData[i].itemid},"qty":${itemData[i].qty},"harga":${itemData[i].harga},"subtotal":$subtotal}';
      if (i < itemData.length - 1) {
        dtl += ",";
      }
    }
    String myjson =
        '{"header":"BB.SI","hcolumn":$hdr},"detail":"BB.SI2","dcolumn":[$dtl]}';

    // String url =
    //     "https://project.graylite.com/tgp/dbhdrdtl/insertnewid/$myjson";
    String url = "https://project.graylite.com/tgp/dbhdrdtl/savesi/$myjson";
//    print(url);

    // sqlID for printing
    var strID = await callAPI(url);
    id = int.parse(strID);

    await load(id);

//    print(sqlID);
//    print(sqlID.runtimeType);
  }

  static clearCart() {
    id = 0;
    nomor = "*new*";
    date =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    custID = null;
    itemData.clear();
  }

  static setPrice(idx, newPrice) {
    itemData[idx].harga = newPrice;
  }

  static itemAdd(itemRec) {
    CItem newItem = CItem();

    newItem.id = 0;
    newItem.itemid = itemRec.id;
    newItem.nama = itemRec.nama;
    newItem.harga = itemRec.harga;
    newItem.qty = 1; // default value
    itemData.add(newItem);
  }

  static calculate() {
    grandTotal = 0;
    qtyTotal = 0;
    for (var i = 0; i < itemData.length; i++) {
      grandTotal = grandTotal + (itemData[i].qty * itemData[i].harga);
      qtyTotal += itemData[i].qty;
    }
  }
}
