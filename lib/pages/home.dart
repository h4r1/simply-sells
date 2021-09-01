import 'package:flutter/material.dart';
import 'package:simply_sells/includes/quotes.dart';

class GridListItems {
  var color;
  String title;
  var icon;
  var route;

  GridListItems({color, title, icon, route})
      : color = Colors.cyan,
        title = title,
        icon = icon,
        route = route;
}

class MyGrid extends StatefulWidget {
  const MyGrid({Key? key}) : super(key: key);

  @override
  _MyGridState createState() => _MyGridState();
}

class _MyGridState extends State<MyGrid> {
  List<GridListItems> items = [
    GridListItems(
        color: Colors.amber,
        title: 'Sales',
        icon: Icons.sell,
        route: 'invPage'),
    GridListItems(
        color: Colors.yellow,
        title: 'Payment',
        icon: Icons.point_of_sale,
        route: 'paymentPage'),
    GridListItems(
        color: Colors.pink,
        title: 'Purchasing',
        icon: Icons.local_mall,
        route: 'purcPage'),
    GridListItems(
        color: Colors.red,
        title: 'Pay Purchased',
        icon: Icons.money,
        route: 'payPurcPage'),
    GridListItems(
        color: Colors.blue,
        title: 'Sales Report',
        icon: Icons.description,
        route: 'salesRptPage'),
    GridListItems(
        color: Colors.blue[300],
        title: 'Payment Report',
        icon: Icons.description_outlined,
        route: 'payRptPage'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20.0),

      // children: items.map((i) {
      //   return Center(
      //     child: Text(
      //       "${i.title}",
      //       style: Theme.of(context).textTheme.headline5,
      //     ),
      //   );
      // }).toList(),
      children: items
          .map((data) => GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(data.route);
                },
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            // decoration: BoxDecoration(
                            //   border: Border.all(color: data.color),
                            // ),
//                            color: data.color,
                            color: Colors.black12,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    data.icon,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  Text(data.title,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                      textAlign: TextAlign.center)
                                ])))),
              ))
          .toList(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? quotesContent;
  String? quotesAuthor;

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
//        SizedBox(height: 10),
        // Center(
        //   child: SizedBox(
        //     height: 120,
        //     width: 120,
        //     child: Image(image: AssetImage('images/bblogorect.png')),
        //   ),
        // ),
//        SizedBox(height: 10),
        Expanded(
//          flex: 3,
          child: MyGrid(),
        ),

        Container(
          height: 180, 
          margin: EdgeInsets.only(top: 15),
          child: quoteArea()),
      ],
    ));
  }

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

  Widget quoteArea() {
    return SingleChildScrollView(
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