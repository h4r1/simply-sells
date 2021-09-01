import 'package:flutter/material.dart';
import 'package:simply_sells/includes/cart.dart';
import 'package:simply_sells/includes/mywidget.dart';

class InvInput extends StatefulWidget {
  final int index;
  InvInput(this.index);

  @override
  _InvInputState createState() => _InvInputState();
}

class _InvInputState extends State<InvInput> {
  final cPrice = TextEditingController();
  final cQty = TextEditingController();

  String strPrice = '0';
  String strQty = '0';
  String strSubtotal = '0';

  @override
  void initState() {
    super.initState();
    strPrice = ShoppingCart.itemData[widget.index].harga.toString();
    cPrice.text = strPrice;
    strPrice = commaSprtr(strPrice);

    strQty = ShoppingCart.itemData[widget.index].qty.toString();
    cQty.text = strQty;
    strQty = commaSprtr(strQty);

    var subtotal = ShoppingCart.itemData[widget.index].qty *
        ShoppingCart.itemData[widget.index].harga;
    print(subtotal);
    strSubtotal = commaSprtr(subtotal.toString());
  }

  void calcChanges() {
    var curQty = int.parse(cQty.text);
    var curPrice = int.parse(cPrice.text);
    var subtotal = curQty * curPrice;

    strQty = commaSprtr(curQty.toString());
    strPrice = commaSprtr(curPrice.toString());
    strSubtotal = commaSprtr(subtotal.toString());
  }

  @override
  void dispose() {
    cPrice.dispose();
    cQty.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Item"),
        actions: [
          IconButton(
            icon: Icon(Icons.create_rounded),
            splashColor: Colors.cyanAccent,
            onPressed: () {
              saveInput();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Data edited for row ${widget.index + 1} ..."),
                duration: Duration(milliseconds: 500),
              ));
              Navigator.pop(context);
            },
          ),
          IconButton(
              icon: Icon(Icons.cancel),
              splashColor: Colors.cyanAccent,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("No changes..."),
                  duration: Duration(milliseconds: 500),
                ));
                Navigator.pop(context);
              })
        ],
      ),
      body: invInputContent(),
    );
  }

  void saveInput() {
    int myPrice = int.parse(cPrice.text);
    ShoppingCart.itemData[widget.index].harga = myPrice;

    int myQty = int.parse(cQty.text);
    ShoppingCart.itemData[widget.index].qty = myQty;

//    print(ShoppingCart.itemData[widget.index].harga);
  }

  Widget invInputContent() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
            "${widget.index + 1}.  ${ShoppingCart.itemData[widget.index].nama}"),
        SizedBox(
          height: 30,
        ),
        Row(
//          crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 180,
                child: 
                
                TextField(
                  decoration: InputDecoration(
                    labelText: "Qty",
//                helperText: "Qty = $strQty",
                    prefixIcon: IconButton(
                        icon: Icon(Icons.remove_circle),
                        onPressed: () {
                          var curQty = int.parse(cQty.text);
                          curQty--;
                          setState(() {
                            cQty.text = curQty.toString();
//                            strQty = commaSprtr(cQty.text);
                            calcChanges();
                          });
                        }),
                    suffixIcon: IconButton(
                        icon: Icon(Icons.add_circle),
                        onPressed: () {
                          var curQty = int.parse(cQty.text);
                          curQty++;
                          setState(() {
                            cQty.text = curQty.toString();
//                            strQty = commaSprtr(cQty.text);
                            calcChanges();
                          });
                        }),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (text) {
                    setState(() {
//                      strQty = commaSprtr(text);
                      calcChanges();
                    });
                  },
                  keyboardType: TextInputType.phone,
                  controller: cQty,
                ),
              ),
            ]),
        Center(
          child: Text("Qty = $strQty"),
        ),
        SizedBox(
          height: 30,
        ),
        Center(
            child: Container(
          width: 180,
          child: TextField(
            decoration: InputDecoration(
              labelText: "Price Rp.",
//            helperText: "Rp. $strPrice",
              border: OutlineInputBorder(),
            ),
            onChanged: (text) {
              setState(() {
//                strPrice = commaSprtr(text);
                calcChanges();
              });
            },
            keyboardType: TextInputType.phone,
            controller: cPrice,
          ),
        )),
        Center(
          child: Text("Rp. $strPrice"),
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            "Subtotal Rp. $strSubtotal",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ]),
    );
  }
}
