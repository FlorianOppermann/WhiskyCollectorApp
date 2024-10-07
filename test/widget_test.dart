import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whisky_collector/data/whisky.dart';
import 'package:whisky_collector/profile_screen.dart';

void main() {
  testWidgets('DashboardPage displays correct statistics',
      (WidgetTester tester) async {
    // Arrange
    /* Whisky({
    required this.distillery,
    required this.age,
    required this.price,
    this.imagePath,
    this.type,
    this.aroma,
    this.taste,
    this.finish,
    this.flavorProfiles = const [],
    this.alcoholContent,
    this.region,
    this.rating,
    this.notes = const [], // Initialisierung der Liste
  });*/
    final whiskies = [
      Whisky(distillery: 'Glenfiddich', age: 12, price: 50.0),
      Whisky(distillery: 'Macallan', age: 15, price: 70.0),
    ];

    // Act
    await tester.pumpWidget(MaterialApp(
      home: ProfileScreen(whiskies: whiskies),
    ));

    // Assert
    expect(find.text('Anzahl Whiskies'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Durchschnittsalter'), findsOneWidget);
    expect(find.text('13.5Jahre'), findsOneWidget);
    expect(find.text('Durchschnittspreis'), findsOneWidget);
    expect(find.text('60.00€'), findsOneWidget);
    expect(find.text('Gesamtwert'), findsOneWidget);
    expect(find.text('120.00€'), findsOneWidget);
    expect(find.text('Durchschnitts- bewertung'), findsOneWidget);
  });
}
