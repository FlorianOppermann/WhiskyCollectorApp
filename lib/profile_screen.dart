import 'package:flutter/material.dart';
import 'package:whisky_collector/data/whisky.dart';
import 'package:whisky_collector/lib/widgets/stat_card.dart';

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
      appBar: AppBar(
        title: const Text('Whisky Collection Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                      title: 'Anzahl Whiskies',
                      value: getTotalWhiskies().toString()),
                  StatCard(
                      title: 'Durchschnittsalter',
                      value: '${getAverageAge().toStringAsFixed(1)}Jahre'),
                  StatCard(
                      title: 'Durchschnittspreis',
                      value: '${getAveragePrice().toStringAsFixed(2)}€'),
                  StatCard(
                      title: 'Gesamtwert',
                      value: '${getTotalValue().toStringAsFixed(2)}€'),
                  StatCard(
                      title: 'Durchschnitts- bewertung',
                      value: '${getAverageRating().toStringAsFixed(1)} Sterne'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
