import 'package:flutter/material.dart';
import 'package:simply_sells/includes/api.dart';
import 'dart:convert' show HtmlEscape;

class CustInput extends StatefulWidget {
//  const CustInput({Key? key}) : super(key: key);
  CustInput({this.cust});
  final dynamic cust;

  @override
  _CustInputState createState() => _CustInputState();
}

class _CustInputState extends State<CustInput> {
  int inputMode = 1; // 0: insert, 1: update
  final cNama = TextEditingController();
  final cAlamat = TextEditingController();
  final cTelepon = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.cust == null) inputMode = 0;

    if (inputMode == 1) {
      cNama.text = widget.cust.nama;
      cAlamat.text = widget.cust.alamat;
      cTelepon.text = widget.cust.telepon;
    }
  }

  @override
  void dispose() {
    cNama.dispose();
    cAlamat.dispose();
    cTelepon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Detail"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            splashColor: Colors.cyanAccent,
            onPressed: () async {
              await save();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Data saved..."),
                duration: Duration(milliseconds: 500),
              ));
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.person_remove_outlined,
            ),
            splashColor: Colors.cyanAccent,
            onPressed: (inputMode == 0 ? null : deleteDialog),
          )
        ],
      ),
      body: custInputContent(),
    );
  }

  void deleteDialog() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirmation'),
              content: const Text('Delete this data?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await delete();
                    Navigator.pop(context, 'OK');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Data ${widget.cust.nama} deleted!"),
                      duration: Duration(milliseconds: 500),
                    ));
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }

  delete() async {
    //https://project.graylite.com/tgp/dbweb/bb.cust/delete/id/123

    String url =
        "https://project.graylite.com/tgp/dbweb/bb.cust/delete/id/${widget.cust.id}";
    await callAPI(url);
  }

  save() async {
    HtmlEscape htmlEscape = const HtmlEscape();
    var myAlamat = cAlamat.text;
    myAlamat = myAlamat.replaceAll("/", "\\");
    print(htmlEscape.convert(myAlamat));
//Dharmahusada Indah Timur XIII\133 Blok L-999 (dekat Galaxy Mal 3) Surabaya

//    print("${cNama.text} ${cAlamat.text} ${cTelepon.text} ");
    //https://project.graylite.com/tgp/dbweb/bb.cust/insert/nama/alamat/telp

    String url = "";
    if (inputMode == 0) // insert
      url =
          "https://project.graylite.com/tgp/dbweb/bb.cust/insert/${cNama.text}/$myAlamat/${cTelepon.text}";
    else {
      var param =
          "id/${widget.cust.id}/nama/${cNama.text}/alamat/$myAlamat/telepon/${cTelepon.text}";
      url = "https://project.graylite.com/tgp/dbweb/bb.cust/update/$param";
    }

    print(url);
    await callAPI(url);
  }

  Widget custInputContent() {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Nama"),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: cNama,
          ),
          Text("Alamat"),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: cAlamat,
          ),
          Text("Telepon"),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            controller: cTelepon,
          ),
        ],
      ),
    ));
  }
}
