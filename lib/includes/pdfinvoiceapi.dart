import 'dart:io';
import 'package:simply_sells/includes/mywidget.dart';
import 'package:simply_sells/includes/printinvdb.dart';
import 'package:simply_sells/includes/pdf_api.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/services.dart';

class PdfInvoiceApi {
  static Future<File> generate(List<PrintInvData> invoice) async {
    MemoryImage logo = MemoryImage(
      (await rootBundle.load('images/bblogo.png')).buffer.asUint8List(),
    );

    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice, logo),
        //     SizedBox(height: 3 * PdfPageFormat.cm),
        //     buildTitle(invoice),
        buildDetail(invoice),
        // Divider(),
        // buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'invoice.pdf', pdf: pdf);
  }

  static Widget buildFooter(List<PrintInvData> invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(5),
            child: Text("Total Rp. ${commaSprtr(invoice[0].jumlah.toString())}",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 20),
          Text(
              "Pembayaran dapat ditransfer ke rekening BCA: 000 111 222 333 atas nama Tiny Omega."),
        ],
      );

  static Widget buildTotal(List<PrintInvData> invoice) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.all(5),
      child: Text("Total Rp. ${commaSprtr(invoice[0].jumlah.toString())}"),
    );
  }

  static Widget buildDetail(List<PrintInvData> invoice) {
    final headers = ['No.', 'Nama Barang', 'Qty', 'Harga Rp.', 'Jumlah Rp.'];

    final data = invoice.map((item) {
      return [
        '${item.baris}.',
        '${item.namaitem}',
        '${item.qty}',
        '${commaSprtr(item.harga.toString())}',
        '${commaSprtr(item.subtotal.toString())}',
      ];
    }).toList();

    var borderColor = PdfColor(0, 0, 0);
    var myTable = Table.fromTextArray(
      headers: headers,
      data: data,
//      border: null,
//      border: TableBorder,
      // border: TableBorder(
      //     horizontalInside: BorderSide(width: 1, style: BorderStyle.solid)),
      border: TableBorder(
          top: BorderSide(width: 1),
          left: BorderSide(width: 1),
          right: BorderSide(width: 1),
          bottom: BorderSide(width: 1),
          verticalInside: BorderSide(
              color: borderColor, width: 1, style: BorderStyle.solid)),

      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 20,
      cellAlignments: {
        0: Alignment.centerRight,
        1: Alignment.centerLeft,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
      },
    );

    return myTable;
  }

  static Widget buildHeader(List<PrintInvData> invoice, MemoryImage logo) {
    var myBold = TextStyle(fontWeight: FontWeight.bold);

    return Column(children: [
      Text('INVOICE',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      SizedBox(height: 20),
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: 60, height: 60, child: Image(logo)),
            SizedBox(width: 10),
Container(
height: 60, 
child: 
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text("BB Florist"),
    Text("Jl. Kusuma Bangsa"),
    Text("Surabaya"),
  ]
),


),


//             Text("""
// Bunga Bakung Florist
// Jl. Kanginan
// Surabaya
//             """),
            SizedBox(width: 80), 
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Tanggal    ", style: myBold),
                        Text("Nomor ", style: myBold),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${invoice[0].tanggal}"),
                        Text("${invoice[0].nomor}"),
                      ]),
                ],
              ),
              SizedBox(height: 20),
              Text("Kepada Yth.", style: myBold),
              Text(invoice[0].namacust),
              Text(invoice[0].alamat),
              Text(invoice[0].telepon),
              SizedBox(height: 20),
            ])
          ]),
    ]);
  }
}
