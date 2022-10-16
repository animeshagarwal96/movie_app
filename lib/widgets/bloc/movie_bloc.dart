import 'dart:async';

class MovieBloc {
  var movieListController = StreamController<List>();

  Sink<List> get add => movieListController.sink;

  Stream<List> get getItem => movieListController.stream;

  var movieChangeListener = StreamController<List>();

  // Specific for any event: Not used till now
  MovieBloc() {
    movieChangeListener.stream.listen(getMovieUpdate);
  }

  void getMovieUpdate(List<dynamic> movies) {
    add.add(movies);
  }

  void dispose() {
    movieListController.close();
    movieChangeListener.close();
  }
}
