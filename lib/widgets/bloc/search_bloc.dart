import 'dart:async';

import 'package:flutter_movie_application/widgets/utils/search_event.dart';

class SearchBloc {
  bool isOpen = false;

  var searchBoxController = StreamController<bool>();

  StreamSink<bool> get add => searchBoxController.sink;

  Stream<bool> get getValue => searchBoxController.stream;

  var searchEventController = StreamController<SearchEvent>();

  Sink<SearchEvent> get event => searchEventController.sink;

  SearchBloc() {
    searchEventController.stream.listen(onChangeEvent);
  }

  void onChangeEvent(SearchEvent event) {
    if (event is OpenSearchBoxEvent) {
      isOpen = true;
    } else {
      isOpen = false;
    }

    add.add(isOpen);
  }

  void dispose() {
    searchBoxController.close();
    searchEventController.close();
  }
}
