import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_movie_application/widgets/bloc/search_bloc.dart';
import 'package:flutter_movie_application/widgets/screens/home_page/movie_card.dart';
import 'package:flutter_movie_application/widgets/utils/api.dart';
import 'package:flutter_movie_application/widgets/bloc/movie_bloc.dart';
import 'package:flutter_movie_application/widgets/utils/search_event.dart';
import 'package:http/http.dart' as http;
import 'package:velocity_x/velocity_x.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int page = 1;
  List<dynamic> _movies = [];
  late TextEditingController query;
  final MovieBloc _bloc = MovieBloc();
  final SearchBloc _searchBloc = SearchBloc();

  void getMovieData() async {
    try {
      final http.Response response = await MyApi.getMovieList(page);
      if (response.statusCode == 200) {
        final List<dynamic> detail = jsonDecode(response.body)['results'];
        if (detail.isNotEmpty) {
          page = page + 1;
          _movies.addAll(detail);
          _bloc.add.add(_movies);
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: "Something went wrong".text.letterSpacing(1).make(),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> refreshItem() async {
    _movies.clear();
    query.clear();
    page = 1;
    wait();
    try {
      final http.Response response = await MyApi.getMovieList(page);
      if (response.statusCode == 200) {
        final List<dynamic> detail = jsonDecode(response.body)['results'];
        if (detail.isNotEmpty) {
          page = page + 1;
          _movies.addAll(detail);
          _bloc.add.add(_movies);
        }
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: "Could not refresh something went wrong"
            .text
            .letterSpacing(1)
            .make(),
        backgroundColor: Colors.red,
      ));
    }
  }

  void wait() async {
    await Future.delayed(const Duration(seconds: 1000));
  }

  @override
  void initState() {
    getMovieData();
    query = TextEditingController(text: "");
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
    _searchBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Object>(
            stream: _searchBloc.getValue,
            initialData: false,
            builder: (context, snapshot) {
              return snapshot.data == false
                  ? TextButton.icon(
                      key: const ValueKey("searchButton"),
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(50, 30),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.centerLeft),
                      onPressed: () {
                        _searchBloc.event.add(OpenSearchBoxEvent());
                      },
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      label: "Search Top Rated Movies"
                          .text
                          .white
                          .letterSpacing(1)
                          .make())
                  : TextField(
                      key: const ValueKey("searchText"),
                      controller: query,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search by title or desc..",
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchBloc.event.add(CloseSearchBoxEvent());
                          },
                          icon: const Icon(Icons.cancel),
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (value) {
                        List<dynamic> filteredMovie = _movies.filter((element) {
                          return "${element['title']}"
                                  .toLowerCase()
                                  .contains(value) ||
                              "${element['overview']}"
                                  .toLowerCase()
                                  .contains(value);
                        }).toList();
                        _bloc.add.add(filteredMovie);
                      },
                    );
            }),
        centerTitle: false,
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: refreshItem,
        child: StreamBuilder(
          stream: _bloc.getItem,
          initialData: const [],
          builder: (context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.length + 1,
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return MovieCard(movie: snapshot.data[index]);
                  } else {
                    getMovieData();
                    return const CircularProgressIndicator().centered();
                  }
                });
          },
        ),
      )),
    );
  }
}
