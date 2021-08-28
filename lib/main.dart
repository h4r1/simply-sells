import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'pages/hometab.dart';
import 'pages/home.dart';
import 'package:simply_sells/pages/invoice/invhome.dart';
//import 'pages/homev1.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        textTheme: GoogleFonts.mcLarenTextTheme(
          Theme.of(context).textTheme
        ),
      ),
//      home: MyHomePage(title: 'THE TITLE'),
      initialRoute: 'homePage',
      routes: {  
        'homePage': (context) => MyHomePage(title: ""),
        'invPage': (context) => InvHome(),
  },

    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
//    return GridViewDemo();
//    return MyGrid();
  }
}
