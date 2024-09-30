import 'package:flutter/material.dart';
import 'dart:io'; // Importiere das File-Modul
import 'package:whisky_collector/data/whisky.dart';
import 'package:whisky_collector/lib/widgets/whisky_detail_page.dart'; // Importiere das Whisky-Modell

class WhiskyCard extends StatelessWidget {
  final Whisky whisky;
  final Function(Whisky) updateWhisky; // Funktion zum Aktualisieren des Whiskys
  final Function(Whisky) deleteWhisky; // Funktion zum Löschen des Whiskys

  WhiskyCard({
    required this.whisky,
    required this.updateWhisky,
    required this.deleteWhisky, // Hinzugefügt
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(whisky.distillery),
        // Image und Rating in der rechten Seite der Karte
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating auf der linken Seite
            Icon(Icons.star),
            Text('${whisky.rating ?? "0"} / 5', style: const TextStyle(fontSize: 14)),
            // Platz zwischen Rating und Bild
            const SizedBox(width: 10),
            // Bild auf der rechten Seite
            whisky.imagePath != null
                ? Image.file(File(whisky.imagePath!), height: 50, width: 50, fit: BoxFit.cover)
                : const Icon(Icons.image_not_supported),
          ],
        ),
        subtitle: Text('Alter: ${whisky.age} Jahre\nPreis: ${whisky.price}€'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WhiskyDetailPage(
                whisky: whisky,
                updateWhisky: updateWhisky,
                deleteWhisky: deleteWhisky, // Übergabe der deleteWhisky-Funktion
              ),
            ),
          );
        },
      ),
    );
  }
}
