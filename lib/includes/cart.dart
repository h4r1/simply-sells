import 'package:simply_sells/includes/api.dart';

import 'package:simply_sells/includes/pdfapi.dart';
import 'package:simply_sells/includes/pdfinvdb.dart';
import 'package:simply_sells/includes/pdfinvapi.dart';

class CItem {
  int id = 0;
  String nama = '';
  int harga = 0;
  int qty = 0;
}

class ShoppingCart {
  static String nama = "My Shopping Cart";
  static String sqlID = "";
  static DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  static List<CItem> itemData = [];
  static dynamic custID;
  static dynamic grandTotal;
  static dynamic qtyTotal;

  static List<PdfInvData> printData = [];

  static showPDF() async {
    final pdfFile = await PdfInvoiceApi.generate(printData);
    PdfApi.openFile(pdfFile);
  }

  static loadPDF() async {
    print("Load PDF!");
    var retval = PdfInv().read(sqlID);
    retval.then((value) {
      printData = value;
      showPDF();
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
*/
    String myDate = "${date.year}-${date.month}-${date.day}";
    String hdr =
        '{"nomor":"*new*","tanggal":"$myDate","custid":${custID.id},"jumlah":$grandTotal';
    String dtl = '';

    for (var i = 0; i < itemData.length; i++) {
      var subtotal = itemData[i].qty * itemData[i].harga;
      dtl +=
          '{"baris":${i + 1},"itemid":${itemData[i].id},"qty":${itemData[i].qty},"harga":${itemData[i].harga},"subtotal":$subtotal}';
      if (i < itemData.length - 1) {
        dtl += ",";
      }
    }
    String myjson =
        '{"header":"BB.SI","hcolumn":$hdr},"detail":"BB.SI2","dcolumn":[$dtl]}';

    String url =
        "https://project.graylite.com/tgp/dbhdrdtl/insertnewid/$myjson";
//    print(url);

    // sqlID for printing
    sqlID = await callAPI(url);
//    print(sqlID);
//    print(sqlID.runtimeType);
  }

  static clearCart() {
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
    newItem.id = itemRec.id;
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

  static printName() {
    print("Hello ${ShoppingCart.nama}");
  }
}
