import 'package:http/http.dart' as http;

class ImageApi {
  static Future<Map<dynamic, dynamic>> getImage(String title, String language, String type) async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/image?title=${Uri.encodeComponent(title)}&language=${Uri.encodeComponent(language)}&type=${Uri.encodeComponent(type)}'));
    if (response.statusCode == 200) {
      return {'image': response.body};
    } else {
      throw 'Failed to load series';
    }
  }
}