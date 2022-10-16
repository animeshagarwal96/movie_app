import 'package:http/http.dart' as http;

class MyApi {
  static String url =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=85ea5d84b241d3b84b16baac17bdf75e&language=en-US&page=';

  static Future<http.Response> getMovieList(int page) {
    return http.get(Uri.parse("$url$page"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'});
  }
}
