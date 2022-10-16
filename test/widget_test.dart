import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_movie_application/main.dart';
import 'package:flutter_movie_application/widgets/bloc/internet_bloc.dart';
import 'package:flutter_movie_application/widgets/screens/home_page/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Material App testing", (WidgetTester tester) async {
    // step 1
    await tester.pumpWidget(const MyApp());

    // step 2
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets("Home page text testing", (WidgetTester tester) async {
    // step 1
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    // step 2
    expect(find.text("Search Top Rated Movies"), findsOneWidget);
  });

  testWidgets("BlocProvicer", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BlocProvider(
          create: (context) => InternetBloc(), child: const HomePage()),
    ));

    expect(find.text("Search Top Rated Movies"), findsOneWidget);
  });
}
