import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWhiskyPopup extends StatefulWidget {
  final TextEditingController destilleController;
  final TextEditingController ageController;
  final TextEditingController priceController;
  final Future<String?> Function(File) saveImage;
  final Function(String?) addWhisky;

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
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: 'Kein Bild ausgewählt.');
      }
    });
  }

  void _validateAndSave() async {
    // Überprüfe, ob alle erforderlichen Felder ausgefüllt sind
    if (widget.destilleController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Bitte eine Destille eingeben.');
      return;
    }
    if (widget.ageController.text.isEmpty ||
        int.tryParse(widget.ageController.text) == null) {
      Fluttertoast.showToast(msg: 'Bitte ein gültiges Alter eingeben.');
      return;
    }
    if (widget.priceController.text.isEmpty ||
        double.tryParse(widget.priceController.text) == null) {
      Fluttertoast.showToast(msg: 'Bitte einen gültigen Preis eingeben.');
      return;
    }
    if (_image == null) {
      Fluttertoast.showToast(msg: 'Bitte ein Bild auswählen.');
      return;
    }

    // Wenn alle Eingaben korrekt sind, speichere das Bild und füge den Whisky hinzu
    String? imagePath = await widget.saveImage(_image!);
    widget.addWhisky(imagePath);

    // Popup schließen
    Navigator.of(context).pop();
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
          onPressed: _validateAndSave,
        ),
      ],
    );
  }
}
