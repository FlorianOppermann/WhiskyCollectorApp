import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddWhiskyPopup extends StatefulWidget {
  final TextEditingController destilleController;
  final TextEditingController ageController;
  final TextEditingController priceController;
  final Future<String?> Function(File) saveImage; // Funktion zum Speichern des Bildes
  final Function(String?) addWhisky; // Funktion zum Hinzufügen des Whiskys

  const AddWhiskyPopup({
    Key? key,
    required this.destilleController,
    required this.ageController,
    required this.priceController,
    required this.saveImage,
    required this.addWhisky,
  }) : super(key: key);

  @override
  _AddWhiskyPopupState createState() => _AddWhiskyPopupState();
}

class _AddWhiskyPopupState extends State<AddWhiskyPopup> {
  File? _image; // Variable für das Bild
  final ImagePicker _picker = ImagePicker(); // ImagePicker-Instanz

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        debugPrint('Kein Bild ausgewählt.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neuen Whisky hinzufügen'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: widget.destilleController,
              decoration: const InputDecoration(
                labelText: 'Destille',
              ),
            ),
            TextField(
              controller: widget.ageController,
              decoration: const InputDecoration(
                labelText: 'Alter (Jahre)',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: widget.priceController,
              decoration: const InputDecoration(
                labelText: 'Preis',
              ),
            ),
            const SizedBox(height: 10),
            _image == null
                ? const Text('Kein Bild ausgewählt.')
                : Image.file(
              _image!,
              height: 150,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Kamera'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Galerie'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Abbrechen'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Speichern'),
          onPressed: () async {
            // Wenn ein Bild vorhanden ist, speichere es lokal und hole den Pfad
            String? imagePath;
            if (_image != null) {
              imagePath = await widget.saveImage(_image!); // Bild speichern und Pfad holen
            }

            // Füge den Whisky mit dem Bildpfad hinzu
            widget.addWhisky(imagePath);

            // Schließe das Popup
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
