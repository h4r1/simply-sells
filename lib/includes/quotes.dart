import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyQuotes {
  dynamic callAPI(String parmURL) async {
    var url = Uri.parse(parmURL);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return (response.body);
      } else {
        throw Exception('callAPI() error, url: ' + parmURL);
      }
    } catch (e) {
      print(e);
    }
  }

  static dynamic getQuote() async {
    var url = Uri.parse('https://api.quotable.io/random');

    var response = await http.get(url);
//    print('Response body: ${response.body}');

    var parsedJson = json.decode(response.body);
    // print('${parsedJson["content"]}');
    // print('by ${parsedJson["author"]}');

    return ({'content': parsedJson["content"], 'author': parsedJson["author"]});
  }
}
