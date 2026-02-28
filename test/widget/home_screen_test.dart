import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nefes_app/features/home/presentation/home_screen.dart';

void main() {
  group('HomeScreen', () {
    testWidgets('should display greeting card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      expect(find.text('Nefes'), findsOneWidget);
      expect(find.text('Bugün Ne Yapmak İstersin?'), findsOneWidget);
    });

    testWidgets('should display quick action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      expect(find.text('Meditasyon'), findsOneWidget);
      expect(find.text('AI Sohbet'), findsOneWidget);
      expect(find.text('Ruh Hali'), findsOneWidget);
      expect(find.text('Dua & Zikir'), findsOneWidget);
    });

    testWidgets('should display daily verse', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      expect(find.text('Günün Ayeti'), findsOneWidget);
    });

    testWidgets('should display stats card', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      expect(find.text('İstatistiklerim'), findsOneWidget);
      expect(find.text('Gün Serisi'), findsOneWidget);
      expect(find.text('Dakika'), findsOneWidget);
      expect(find.text('Oturum'), findsOneWidget);
    });
  });
}
