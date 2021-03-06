import 'package:flutter/material.dart';
import 'package:simply_sells/includes/mywidget.dart';
import 'package:simply_sells/models/custdb.dart';
import 'package:simply_sells/includes/cart.dart';
import 'package:simply_sells/pages/invoice/custinput.dart';

class CustPage extends StatefulWidget {
  @override
  _CustPageState createState() => _CustPageState();
}

class _CustPageState extends State<CustPage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  Icon _searchIcon = const Icon(Icons.search);

  final String pageTitle = 'Customer';
  Widget _appBarTitle = Text("");

  List data = [];
  List filteredData = [];

  _CustPageState() {
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
          actions: [
            IconButton(
              icon: Icon(Icons.person_add_alt_1_outlined),
              splashColor: Colors.cyanAccent,
              onPressed: () => custAdd(null),
            ),
          ]),
      body: Container(
        child: _buildList(),
      ),
    );
  }

  void custAdd(custData) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return (CustInput(cust: custData));
    })).whenComplete(() {
//      setState(() {
      getData();
//      });
    });
  }

  void addCart(arrCust) {
    ShoppingCart.custID = arrCust;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("${arrCust.nama} used for cart..."),
      duration: Duration(milliseconds: 500),
    ));

    print("add to cart... ${arrCust.id}");
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
          return InkWell(
            child: custCard(index),
            onTap: () {
              print("card tap");
              custAdd(filteredData[index]);
            },
          );
        },
      );
    }

    return waitProgress();
  }

  Widget custCard(index) {
    return Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        elevation: 4,
        color: (index.isOdd ? Colors.white70 : Colors.white),
        child: ListTile(
          title: Text(
            filteredData[index].nama,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(filteredData[index].alamat),
              Row(
                children: [
                  Icon(Icons.phone_android),
                  InkWell(
                    onTap: () => callWhatsApp(filteredData[index].telepon),
                    child: Text(
                      filteredData[index].telepon,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              addCart(filteredData[index]);
            },
          ),
        ));
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

  void getDataX() async {
    Future<List<CustData>> apiData;

    data = [];
    filteredData = [];
    apiData = Cust().read();

    apiData.then((retval) {
      for (var Cust in retval) {
        data.add(Cust);
        filteredData.add(Cust);
      }

      setState(() {});
    });
  }

  void getData() async {
    List<CustData> apiData;

    data = [];
    filteredData = [];
    apiData = await Cust().read();

    for (var Cust in apiData) {
      data.add(Cust);
      filteredData.add(Cust);

      setState(() {});
    }
  }
}
