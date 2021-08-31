import 'package:flutter/material.dart';
import 'package:simply_sells/models/invbrowsedb.dart';
import 'package:simply_sells/includes/mywidget.dart';
import 'package:simply_sells/includes/cart.dart';

import 'package:simply_sells/pages/invoice/item.dart';
import 'package:simply_sells/pages/invoice/cust.dart';
import 'package:simply_sells/pages/invoice/invoice.dart';

class InvHome extends StatefulWidget {
  const InvHome({Key? key}) : super(key: key);

  @override
  _InvHomeState createState() => _InvHomeState();
}

class _InvHomeState extends State<InvHome> {
  int index = 0;
  List data = [];

  @override
  void initState() {
    getData();
    ShoppingCart.clearCart();
    super.initState();
  }

  void getData() async {
    Future<List<InvBrowseData>> apiData;

    data = [];
    apiData = InvBrowse().read();

    apiData.then((retval) {
      for (var item in retval) {
        data.add(item);
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Invoice"),
      // ),
//      body: _buildList(),
      body: buildPages(),
      bottomNavigationBar: buildBottomBar(),
    );
  }

  Widget _buildList() {
    if (data.isNotEmpty) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int i) {
          String strJumlah = commaSprtr(data[i].jumlah.toString());
          return InkWell(
              onTap: () async {
                await ShoppingCart.load(data[i].id);

                setState(() {
                  index = 3;
                });
              },
              child: Card(
                  elevation: 4,
                  color: (i.isOdd ? Colors.white70 : Colors.white),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${data[i].tanggal}",
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        Text(
                          "${data[i].nomor}",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),

                    subtitle: Text(data[i].nama),
                    trailing: Text("Rp. $strJumlah"),

                    // trailing: IconButton(
                    //   icon: const Icon(Icons.shopping_cart_outlined),
                    //   onPressed: () {
                    //     addCart(filteredData[index]);
                    //   },
                    // ),
                  )));
        },
      );
    }

    return waitProgress();
  }

  Widget buildBottomBar() {
//    final style = TextStyle(color: Colors.white);

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      currentIndex: index,
      items: [
        BottomNavigationBarItem(
//          icon: Text('Home', style: style),
          icon: Icon(Icons.list),
          label: 'List',
        ),
        BottomNavigationBarItem(
//          icon: Icon(Icons.view_in_ar),
          icon: Icon(Icons.widgets),
          label: 'Product',
        ),
        BottomNavigationBarItem(
//          icon: Icon(Icons.portrait),
          icon: Icon(Icons.person),
          label: 'Customer',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
      ],
      onTap: (int index) => setState(() => this.index = index),
    );
  }

  Widget homeScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invoice"),
      ),
      body: _buildList(),
    );
  }

  Widget buildPages() {
    switch (index) {
      case 0:
        return homeScaffold();
      case 1:
        return ItemPage();
      case 2:
        return CustPage();
      case 3:
        return InvoicePage();

      default:
        return Container();
    }
  }
}
