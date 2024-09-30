import 'package:flutter/material.dart';
import 'package:whisky_collector/data/whisky.dart';

class ProfileScreen extends StatelessWidget {
  final List<Whisky> whiskies;

  ProfileScreen({required this.whiskies});

  int getTotalWhiskies() {
    return whiskies.length;
  }

  double getAverageAge() {
    if (whiskies.isEmpty) return 0.0;
    int totalAge = whiskies.fold(0, (sum, whisky) => sum + whisky.age);
    return totalAge / whiskies.length;
  }

  double getAveragePrice() {
    if (whiskies.isEmpty) return 0.0;
    double totalPrice = whiskies.fold(0.0, (sum, whisky) => sum + whisky.price);
    return totalPrice / whiskies.length;
  }

  double getAverageRating() {
    List<int?> ratings = whiskies
        .map((whisky) => whisky.rating)
        .where((rating) => rating != null)
        .toList();
    if (ratings.isEmpty) return 0.0;
    int totalRating = ratings.fold(0, (sum, rating) => sum + rating!);
    return totalRating / ratings.length;
  }

  double getTotalValue() {
    if (whiskies.isEmpty) return 0.0;
    double totalValue = whiskies.fold(0.0, (sum, whisky) {
      if (whisky.price != null) {
        return sum + whisky.price!;
      } else {
        return sum;
      }
    });
    return totalValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          //algin text: left
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Deine Whisky Sammlung',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Anzahl der Whiskys: ${getTotalWhiskies()}'),
            Text(
                'Durchschnittsalter: ${getAverageAge().toStringAsFixed(1)} Jahre'),
            Text(
                'Durchschnittspreis: ${getAveragePrice().toStringAsFixed(2)} €'),
            Text(
                'Durchschnittliche Bewertung: ${getAverageRating().toStringAsFixed(1)} Sterne'),
            Text(
                'Gesamtwert der Sammlung: ${getTotalValue().toStringAsFixed(2)} €'),
            SizedBox(height: 20),
            Text('Weitere Statistiken kommen bald!'),
          ],
        ),
      ),
    );
  }
}
