import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer';

class ImageService {
  static Future<List<String>> searchAiImages(String prompt) async {
    try {
      final res = await http
          .get(Uri.parse('https://lexica.art/api/v1/search?q=$prompt'));

      final data = jsonDecode(res.body);

      return List.from(data['images']).map((e) => e['src'].toString()).toList();
    } catch (e) {
      log('searchAiImagesE: $e');
      return [];
    }
  }
}
