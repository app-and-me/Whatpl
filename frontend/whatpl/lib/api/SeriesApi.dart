import 'dart:convert';
import 'package:http/http.dart' as http;

class SeriesApi {
  static Future<Map<String, dynamic>> getSeriesByCsv() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/series/tmdb/'));
    if (response.statusCode == 200) {
      Map<String, dynamic> series = json.decode(response.body);
      return series;
    } else {
      throw 'Failed to load series';
    }
  }

  static Future<Map<String, dynamic>> getSeriesByTitle(String title, String mediaType, String language) async {
    mediaType = mediaType == 'drama' ? 'tv' : mediaType;
    
    final response = await http.get(Uri.parse('http://localhost:3000/api/$mediaType?title=$title&language=$language'));
    if (response.statusCode == 200) {
      Map<String, dynamic> series = json.decode(response.body);
      return series;
    } else {
      print(response.body);
      throw 'Failed to load series';
    }
  }
}