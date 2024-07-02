import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {

  NetworkHelper(this.url);

  final String url;

  Future getData() async {
    final uri = Uri.parse(url); // Correctly parsing the URL

    try {
      http.Response response = await http.get(uri);
      if (response.statusCode == 200) {
        String data = response.body;

        var decodedData = jsonDecode(data);
        return decodedData;
      } else {
        print('Failed to load data: ${response.statusCode}');
        return null; // Return null or appropriate value to indicate failure
      }
    } catch (e) {
      print('Error: $e');
      return null; // Return null or appropriate value to indicate an error
    }
  }
}
