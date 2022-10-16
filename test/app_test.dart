import 'package:flutter/material.dart';

import 'package:flutter_movie_application/widgets/screens/home_page/home_page.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("Testing the tap behaviour of the search icon in home page",
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: HomePage(),
    ));

    var widgetTextField = find.byKey(const ValueKey("searchText"));

    await tester.enterText(widgetTextField, "the godfather");

    expect(find.text("the godfather"), findsOneWidget);
  });
}
