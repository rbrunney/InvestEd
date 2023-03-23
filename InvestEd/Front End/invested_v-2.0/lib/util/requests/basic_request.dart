import 'package:http/http.dart';

class BasicRequest {
  static Future<String> makeGetRequest(String url) async {
    final requestLink = Uri.parse(url);
    Response response = await get(requestLink);

    return response.body;
  }
  
}
