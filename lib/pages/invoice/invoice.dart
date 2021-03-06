import 'package:flutter/material.dart';
import 'package:simply_sells/includes/cart.dart';
import 'package:intl/intl.dart';
import 'package:simply_sells/includes/mywidget.dart';
import 'package:simply_sells/pages/invoice/invinput.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoicing"),
        actions: [
          IconButton(
              onPressed: () async {
                await ShoppingCart.save();
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        Text("Invoice save! You can print the invoice now..."),
                    duration: Duration(milliseconds: 500),
                  ));
                });
              },
              splashColor: Colors.cyanAccent,
              icon: Icon(Icons.save)),
          IconButton(
              onPressed: () {
                if (ShoppingCart.id != 0) {
                  ShoppingCart.loadPDF();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Can't print, data is not saved..."),
                    duration: Duration(milliseconds: 500),
                  ));
                }
              },
              splashColor: Colors.cyanAccent,
//              icon: Icon(Icons.print_rounded)),
              icon: Icon(Icons.picture_as_pdf)),
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Empty the cart?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'OK');
                      setState(() {
                        ShoppingCart.clearCart();
                      });
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: invoiceContent(),
//      body: _buildList(),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime currentDate = ShoppingCart.date;

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));

    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        ShoppingCart.date = pickedDate;
      });
    }
  }

  Widget invoiceContent() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String myDate = formatter.format(ShoppingCart.date);
    ShoppingCart.calculate();

    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 100,
                child: Text(
                  "Date",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                child: Text(myDate),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.date_range),
                  onPressed: () => _selectDate(context),
                ),
              )
            ],
          ),
          Row(children: [
            Container(
              width: 100,
              child: Text(
                "Invoice No.",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Text(ShoppingCart.nomor),
          ]),
          Container(
            width: double.infinity,
            height: 100,
            child: SingleChildScrollView(
              child: Card(
                elevation: 4,
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text("${ShoppingCart.custID?.nama ?? ''}"),
                        ),
                        Container(
                          child: Text("${ShoppingCart.custID?.alamat ?? ''}"),
                        ),
                        Container(
                          child: Row(
                            children: [
                              Icon(Icons.phone_android),
                              InkWell(
                                onTap: () =>
                                    callWhatsApp(ShoppingCart.custID?.telepon),
                                child: Text(
                                    "${ShoppingCart.custID?.telepon ?? '---'}"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          Divider(color: Colors.black),
          Expanded(
//              height: 350,
              child: SingleChildScrollView(
            child: _buildList(),
          )),
          SizedBox(
            height: 20,
          ),
          Divider(color: Colors.black),
          Center(
            child: Text(
              "${commaSprtr(ShoppingCart.itemData.length.toString())} items, Total Qty: ${commaSprtr(ShoppingCart.qtyTotal.toString())}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              "Grand Total: ${commaSprtr(ShoppingCart.grandTotal.toString())} IDR",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),

/*              
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                      "${ShoppingCart.itemData.length} items, Total Qty: ${ShoppingCart.qtyTotal}"),
                ),

                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Grand Total: ${commaSprtr(ShoppingCart.grandTotal.toString())} IDR",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ],
            ),
          )
          */
        ],
      ),
    );
  }

/* 
  Widget _buildDataTable() {
    return DataTable(
        columns: [
          DataColumn(label: Text('Nama')),
          DataColumn(label: Text('Qty')),
          DataColumn(label: Text('Harga')),
          DataColumn(label: Text('Subtotal')),
        ],
        rows: List.generate(ShoppingCart.itemData.length, (idx) {
          return DataRow(cells: [
            DataCell(Text(ShoppingCart.itemData[idx].nama)),
            DataCell(Text(ShoppingCart.itemQty[idx].toString())),
            DataCell(Container(
              width: 100,
              child: Text(
                commaSprtr(ShoppingCart.itemData[idx].harga.toString()),
                textAlign: TextAlign.end,
              ),
            )),
            DataCell(Text(ShoppingCart.itemData[idx].harga.toString())),
          ]);
        }));
  }


  Widget _buildTable() {
    List<TableRow> rows = [];
    for (int i = 0; i < ShoppingCart.itemData.length + 50; ++i) {
      rows.add(TableRow(children: [
        Text("number " + i.toString()),
        Text("squared " + (i * i).toString()),
      ]));
    }
    return Table(children: rows);
  }
*/
  Widget _buildList() {
    if (ShoppingCart.itemData.isNotEmpty) {
      return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: ShoppingCart.itemData.length,
        itemBuilder: (BuildContext context, int idx) {
          String strHarga =
              commaSprtr(ShoppingCart.itemData[idx].harga.toString());

          var subtotal =
              ShoppingCart.itemData[idx].qty * ShoppingCart.itemData[idx].harga;
          var strSub = commaSprtr(subtotal.toString());

          return ListTile(
            leading: Text("${idx + 1}."),
            minLeadingWidth: 1,
            title: Text(
              "${ShoppingCart.itemData[idx].nama}",
              style: TextStyle(fontSize: 14),
            ),
            subtitle: Row(children: [
              Expanded(
                child: Text(
                    "${commaSprtr(ShoppingCart.itemData[idx].qty.toString())} x Rp. $strHarga",
                    style: TextStyle(fontSize: 12)),
              ),
//              Container(width: 40, child: Text("Rp. "),),
              Container(
                width: 120,
                alignment: Alignment.centerRight,
                child: Text(
                  "$strSub IDR",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              )
            ]),

/*
            title: Row(children: [
              Expanded(
                child: Text(
                  "${idx + 1}. ${ShoppingCart.itemData[idx].nama}",
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Container(
                width: 130,
                alignment: Alignment.centerRight,
                child: Text(
                  "$strSub",
                  style: TextStyle(fontSize: 14),
                ),
              )
            ]),
            subtitle: Text("${ShoppingCart.itemQty[idx]} x Rp. $strHarga"),
  */
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print("Edit item...");
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return (InvInput(idx));
              })).whenComplete(() {
                setState(() {});
              });
            },
          );
        },
      );
    }

    return (Center(child: Text("(No item)")));
  }
}
