import 'package:http/http.dart' as http;

dynamic callAPI(String parmURL) async {
//  print(parmURL);
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
