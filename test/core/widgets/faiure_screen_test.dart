import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_recommendation_app_course/core/widgets/faiure_screen.dart';

void main() {
  testWidgets('failure screen ...', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FailureScreen(message: 'no'),
      ),
    );

    expect(find.text('no'), findsOneWidget);
  });
}
