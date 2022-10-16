import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movie_application/widgets/bloc/internet_bloc.dart';
import 'package:flutter_movie_application/widgets/utils/internet_state.dart';
import 'package:velocity_x/velocity_x.dart';

class MovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;
  const MovieCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(children: [
          AspectRatio(
            aspectRatio: 1.6 / 2.6,
            child: BlocConsumer<InternetBloc, InternetState>(
              listener: ((context, state) {
                if (state is InternetBackState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content:
                        "Internet is connected".text.letterSpacing(1).make(),
                    backgroundColor: Colors.green,
                  ));
                } else if (state is InternetLostState) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: "Internet is not connected"
                        .text
                        .letterSpacing(1)
                        .make(),
                    backgroundColor: Colors.red,
                  ));
                }
              }),
              builder: (context, state) {
                if (state is InternetLostState) {
                  return Container();
                } else {
                  return Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://image.tmdb.org/t/p/original${movie['poster_path']}"),
                            fit: BoxFit.cover)),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(1.0),
                                Colors.black.withOpacity(.5),
                              ])),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "${movie['title']} (${movie['vote_average']})"
                                .text
                                .xl3
                                .letterSpacing(1)
                                .white
                                .make()
                                .p8(),
                            const Spacer(),
                            "Release On : ${movie['release_date']}"
                                .text
                                .xl
                                .letterSpacing(1)
                                .white
                                .make()
                                .py16(),
                            "${movie['overview']}"
                                .text
                                .letterSpacing(1)
                                .white
                                .make()
                          ]),
                    ),
                  );
                }
              },
            ),
          )
        ]),
      ),
    );
  }
}
