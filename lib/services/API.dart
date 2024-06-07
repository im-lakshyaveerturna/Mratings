import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieData {
  static const String _apiKey = '4d10c89cbcmshe2fd1c1667c77ffp1e3733jsnedabffda54c0';
  static const String _apiHost = 'imdb8.p.rapidapi.com';

  static const String _apiKey2 = '4d10c89cbcmshe2fd1c1667c77ffp1e3733jsnedabffda54c0';
  static const String _apiHost2 = 'movies-tv-shows-database.p.rapidapi.com';

  Map<String, dynamic> map1 = {};
  Map<String, dynamic> map2 = {};
  String moviename = '';

  Future<void> fetchMovies(query) async {
    final String url1 = 'https://imdb8.p.rapidapi.com/auto-complete';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': _apiKey,
      'X-RapidAPI-Host': _apiHost,
    };
    final Map<String, String> params = {
      'q': query,
    };

    final Uri uri = Uri.parse(url1).replace(queryParameters: params);

    try {
      final http.Response response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        map1 = jsonDecode(response.body);
        print(map1);
        try {

          if (map1.isNotEmpty && map1['d'] != null && map1['d'].isNotEmpty) {
            moviename = map1['d'][0]['l'];

          } else {
            print('No movie data found');
          }
        } catch (e) {
          print('Error decoding JSON: $e');
          print('Received data: $map1');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchAdditionalData(String movieId) async {
    final String url2 = 'https://movies-tv-shows-database.p.rapidapi.com/';
    final Map<String, String> headers2 = {
      'X-RapidAPI-Key': _apiKey2,
      'X-RapidAPI-Host': _apiHost2,
      'Type': 'get-movie-details', // Adjust this header according to your API documentation
    };

    final Map<String, String> params = {
      'movieid': movieId, // Correctly passing the movieid parameter
    };
    final Uri uri = Uri.parse(url2).replace(queryParameters: params);

    try {
      final http.Response response = await http.get(uri, headers: headers2);

      final String? contentType = response.headers['content-type'];
      if (response.statusCode == 200 && contentType != null && contentType.contains('application/json')) {
        final data = response.body;
        try {
          map2 = json.decode(data);
          print(map2);
        } catch (e) {
          print('Error decoding JSON: $e');
          print('Received data: $data');
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
        print('Response content type: $contentType');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
