import 'package:flutter/material.dart';
import 'package:simply_sells/includes/cart.dart';
import 'package:simply_sells/includes/mywidget.dart';
import 'package:simply_sells/includes/itemdb.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  Icon _searchIcon = const Icon(Icons.search);

  final String pageTitle = 'Product';
  Widget _appBarTitle = Text("");

  List data = [];
  List filteredData = [];

  _ItemPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredData = data;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });

//    print(_searchText);
  }

  @override
  void initState() {
    getData();
    super.initState();
    _appBarTitle = Text(pageTitle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        leading: IconButton(
          icon: _searchIcon,
          onPressed: _searchPressed,
        ),
      ),
      body: Container(
        child: _buildList(),
//        child: Text("Hello!"),
      ),
    );
  }

  void addCart(arrItem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${arrItem.nama} added to cart..."),
      duration: Duration(milliseconds: 500),
    ));

    ShoppingCart.itemAdd(arrItem);

    print("add to cart... ${arrItem.id}");
  }

  Widget _buildList() {
    if (_searchText.isNotEmpty) {
      List tempList = [];
      for (int i = 0; i < filteredData.length; i++) {
        if (filteredData[i]
            .nama
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredData[i]);
        }
      }
      filteredData = tempList;
    }

    if (filteredData.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredData.length,
        itemBuilder: (BuildContext context, int index) {
          String strHarga = commaSprtr(filteredData[index].harga.toString());
          return Card(
              elevation: 4,
              color: Colors.white70,
              child: ListTile(
                title: Text(filteredData[index].nama),
                subtitle: Text("Rp. $strHarga"),
                trailing: IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    addCart(filteredData[index]);
                  },
                ),
              ));
        },
      );
    }

    return waitProgress();
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _filter,
          decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        _appBarTitle = Text(pageTitle);
        filteredData = data;
        _filter.clear();
      }
    });
  }

  void getData() async {
    Future<List<ItemData>> apiData;

    data = [];
    filteredData = [];
    apiData = Item().read();

    apiData.then((retval) {
      for (var item in retval) {
        data.add(item);
        filteredData.add(item);
      }

      setState(() {});
    });
  }
}
