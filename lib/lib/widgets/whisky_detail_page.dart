import 'package:flutter/material.dart';
import 'dart:io';
import 'package:whisky_collector/data/whisky.dart';
import 'package:whisky_collector/lib/widgets/edit_whisky_page.dart';

class WhiskyDetailPage extends StatefulWidget {
  final Whisky whisky;
  final Function(Whisky) updateWhisky; // Funktion zum Aktualisieren
  final Function(Whisky) deleteWhisky; // Funktion zum Löschen

  WhiskyDetailPage({
    required this.whisky,
    required this.updateWhisky,
    required this.deleteWhisky, // Hinzugefügt
  });

  @override
  _WhiskyDetailPageState createState() => _WhiskyDetailPageState();
}

class _WhiskyDetailPageState extends State<WhiskyDetailPage> {
  late Whisky _whisky;
  final TextEditingController _noteController = TextEditingController();
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
    _whisky = widget.whisky;
    _currentRating = _whisky.rating ?? 0;
  }

  void _addTastingNote() {
    if (_noteController.text.isNotEmpty) {
      setState(() {
        final newNotes = List<String>.from(_whisky.notes);
        newNotes.add(_noteController.text);
        _whisky = Whisky(
          distillery: _whisky.distillery,
          age: _whisky.age,
          price: _whisky.price,
          imagePath: _whisky.imagePath,
          type: _whisky.type,
          aroma: _whisky.aroma,
          taste: _whisky.taste,
          finish: _whisky.finish,
          flavorProfiles: _whisky.flavorProfiles,
          alcoholContent: _whisky.alcoholContent,
          region: _whisky.region,
          rating: _whisky.rating,
          notes: newNotes,
        );
      });
      widget.updateWhisky(_whisky);
      _noteController.clear();
    }
  }

  // Methode zum Festlegen des Ratings
  void _setRating(int rating) {
    setState(() {
      _currentRating = rating;
      _whisky = Whisky(
        distillery: _whisky.distillery,
        age: _whisky.age,
        price: _whisky.price,
        imagePath: _whisky.imagePath,
        type: _whisky.type,
        aroma: _whisky.aroma,
        taste: _whisky.taste,
        finish: _whisky.finish,
        flavorProfiles: _whisky.flavorProfiles,
        alcoholContent: _whisky.alcoholContent,
        region: _whisky.region,
        rating: _currentRating, // Rating wird gesetzt
        notes: _whisky.notes,
      );
    });
    widget.updateWhisky(_whisky);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_whisky.distillery),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('Bearbeiten'),
                value: 'edit',
              ),
              PopupMenuItem(
                child: Text('Löschen'),
                value: 'delete',
              ),
            ],
            onSelected: (String value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditWhiskyPage(
                      whisky: _whisky,
                      saveImage: (image) async {
                        return image.path;
                      },
                      updateWhisky: (updatedWhisky) {
                        setState(() {
                          _whisky = updatedWhisky;
                        });
                        widget.updateWhisky(updatedWhisky); // Update im Speicher
                      },
                    ),
                  ),
                );
              }
              if (value == 'delete') {
                widget.deleteWhisky(_whisky); // Whisky löschen
                Navigator.pop(context); // Zurück zur Liste
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _whisky.distillery,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.timer, size: 15),
                            Text('Alter: ${_whisky.age} Jahre'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.euro, size: 15),
                            Text('Preis: ${_whisky.price.toStringAsFixed(2)}€'),
                          ],
                        ),
                        Text(''),
                        Row(
                          children: [
                            Icon(Icons.grass, size: 15),
                            Text('Typ:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(_whisky.type ?? ''),
                        Text(''),

                        Row(
                          children: [
                            Icon(Icons.wine_bar, size: 15),
                            Text('Aroma:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(_whisky.aroma ?? ''),
                        Text(''),
                        Row(
                          children: [
                            Icon(Icons.dinner_dining, size: 15),
                            Text('Geschmack:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(_whisky.taste ?? ''),
                        Text(''),
                        Row(
                          children: [
                            Icon(Icons.sports_score, size: 15),
                            Text('Finish:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text(_whisky.finish ?? ''),
                        Text(''),
                        Row(
                          children: [
                            Icon(Icons.liquor, size: 15),
                            Text('Alkoholgehalt:', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),

                        Text('${_whisky.alcoholContent ?? "0.0"} %'),
                        Text(''),
                        Text('Region:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_whisky.region ?? ''),
                        Text(''),
                        Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(_whisky.rating != null ? '${_whisky.rating} / 5' : 'Kein Rating'),

                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  if (_whisky.imagePath != null)
                    Expanded(
                      flex: 1,
                      child: Image.file(
                        File(_whisky.imagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              // Anzeige der Tastingnotes
              Text(
                'Tasting Notes:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              for (var note in _whisky.notes) Text('- $note'),
              SizedBox(height: 20),
              // Eingabefeld für neue Tastingnote
              TextField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: 'Tastingnote hinzufügen',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _addTastingNote, // Hinzufügen der Tastingnote
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Rating Funktion
              Text(
                'Whisky bewerten:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _currentRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () => _setRating(index + 1),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}