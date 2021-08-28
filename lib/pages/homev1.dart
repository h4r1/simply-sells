import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simply_sells/includes/quotes.dart';
import 'package:simply_sells/pages/item.dart';
import 'package:simply_sells/pages/cust.dart';
import 'package:simply_sells/pages/invoice.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  String? quotesContent;
  String? quotesAuthor;

  void loadQuote() {
    var retval = DailyQuotes.getQuote();

    retval.then((value) {
      print("${value['content']} by ${value['author']}");

      setState(() {
        quotesContent = value['content'];
        quotesAuthor = value['author'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPages(),
      bottomNavigationBar: buildBottomBar(),
    );
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
          icon: Icon(Icons.home),
          label: 'Home',
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

  Widget homeScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text("Simply Sells"),
      ),
      body: homeContent(),
    );
  }

  Widget homeContent() {
    return Center(
        child: Column(
      children: [
        Expanded(
            child: Center(
          child: 
          SizedBox(
//            height: 160,
//            width: 160,
            child: Image(image: AssetImage('images/bblogo.png')),
          ),
          
        )),
        Container(
          height: 180,
          child: SingleChildScrollView(
            child: InkWell(
              child: quoteCard(),
              onTap: () {
                print("Refresh!");
                setState(() {
                  quotesContent = "Loading...";
                  quotesAuthor = "";
                });
                loadQuote();
              },
            ),
          ),
        ),

      ],
    ));
  }

  Widget quoteCard() {
    return Card(
        elevation: 5,
//        shadowColor: Colors.blue,
        margin: EdgeInsets.all(10.0),
        color: Colors.cyanAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          margin: EdgeInsets.all(3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.auto_stories_outlined,
                          color: Colors.blue[600],
                        )),
                  ),
                  Text("Quote of the Day",
                      style: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.bold)),
                  Container(
                    child: IconButton(
                        onPressed: null,
                        icon: Icon(
                          Icons.auto_stories_outlined,
                          color: Colors.blue[600],
                        )),
                  ),
                ]),
              ),
              ListTile(
//                 leading: Icon(
// //                  Icons.lightbulb,
//                   Icons.auto_stories_outlined,
//                   color: Colors.yellow,
//                 ),
                title: Text(
                  '"${this.quotesContent ?? "Loading..."}"',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  // style: GoogleFonts.mcLaren(
                  //   fontSize: 12,
                  //   color: Colors.white,
                  // ),
                ),
                subtitle: Text(
                  this.quotesAuthor ?? "",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.black54),
                ),
              ),
            ],
          ),
        ));
  }

}
