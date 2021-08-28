import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:simply_sells/includes/quotes.dart';
//import 'package:simply_sells/pages/invoice/invhome.dart';

//import 'package:simply_sells/pages/item.dart';
//import 'package:simply_sells/pages/cust.dart';
//import 'package:simply_sells/pages/invoice.dart';

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
    return homeScaffold();
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
        SizedBox(height: 10),
        Center(
          child: SizedBox(
            height: 120,
            width: 120,
            child: Image(image: AssetImage('images/bblogo.png')),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: mainMenuX(),
        ),
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

  Widget mainMenu() {
    return Center(
        child: ElevatedButton.icon(
      icon: Icon(
        Icons.favorite,
        color: Colors.pink,
        size: 24.0,
      ),
      label: Text('Elevated Button'),
      onPressed: () {
        print('Pressed');
      },
      style: ElevatedButton.styleFrom(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
      ),
    ));
    // return Column(
    //   children: [
    //     Container(
    //       color: Colors.cyanAccent,
    //       child: IconButton(
    //           onPressed: () => print("pressed"), icon: Icon(Icons.list)),
    //     ),
    //     Text("Sales"),
    //   ],
    // );
  }

  Widget mainMenuX() {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(flex: 1, child: Center(child: Text("Sales"))),
                Expanded(flex: 1, child: Center(child: Text("Payment"))),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(flex: 1, child: Center(child: Text("Purchase"))),
                Expanded(flex: 1, child: Center(child: Text("Pay Purchased"))),
              ],
            )),
        Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(flex: 1, child: Center(child: Text("Sales Report"))),
                Expanded(flex: 1, child: Center(child: Text("Payment Report"))),
              ],
            )),
      ],
    );
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
