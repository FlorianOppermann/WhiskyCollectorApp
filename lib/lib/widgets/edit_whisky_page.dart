import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:whisky_collector/data/whisky.dart';

class EditWhiskyPage extends StatefulWidget {
  final Whisky whisky;
  final Future<String?> Function(File) saveImage; // Funktion zum Speichern des Bildes
  final Function(Whisky) updateWhisky; // Funktion zum Aktualisieren des Whiskys

  const EditWhiskyPage({
    Key? key,
    required this.whisky,
    required this.saveImage,
    required this.updateWhisky,
  }) : super(key: key);

  @override
  _EditWhiskyPageState createState() => _EditWhiskyPageState();
}

class _EditWhiskyPageState extends State<EditWhiskyPage> {
  late TextEditingController _distilleryController;
  late TextEditingController _ageController;
  late TextEditingController _priceController;
  late TextEditingController _typeController;
  late TextEditingController _aromaController;
  late TextEditingController _tasteController;
  late TextEditingController _finishController;
  late TextEditingController _alcoholContentController;
  late TextEditingController _regionController;

  File? _image; // Variable für das Bild
  final ImagePicker _picker = ImagePicker(); // ImagePicker-Instanz

  @override
  void initState() {
    super.initState();
    _distilleryController = TextEditingController(text: widget.whisky.distillery);
    _ageController = TextEditingController(text: widget.whisky.age.toString());
    _priceController = TextEditingController(text: widget.whisky.price.toString());
    _typeController = TextEditingController(text: widget.whisky.type ?? '');
    _aromaController = TextEditingController(text: widget.whisky.aroma ?? '');
    _tasteController = TextEditingController(text: widget.whisky.taste ?? '');
    _finishController = TextEditingController(text: widget.whisky.finish ?? '');
    _alcoholContentController = TextEditingController(text: widget.whisky.alcoholContent?.toString() ?? '');
    _regionController = TextEditingController(text: widget.whisky.region ?? '');
    _image = widget.whisky.imagePath != null ? File(widget.whisky.imagePath!) : null;
  }

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whisky bearbeiten'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _distilleryController,
                decoration: const InputDecoration(
                  labelText: 'Distille',
                ),
              ),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Alter (Jahre)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Preis',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: 'Typ',
                ),
              ),
              TextField(
                controller: _aromaController,
                decoration: const InputDecoration(
                  labelText: 'Aroma',
                ),
              ),
              TextField(
                controller: _tasteController,
                decoration: const InputDecoration(
                  labelText: 'Geschmack',
                ),
              ),
              TextField(
                controller: _finishController,
                decoration: const InputDecoration(
                  labelText: 'Finish',
                ),
              ),
              TextField(
                controller: _alcoholContentController,
                decoration: const InputDecoration(
                  labelText: 'Alkoholgehalt (%)',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _regionController,
                decoration: const InputDecoration(
                  labelText: 'Region',
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String? imagePath;
                  if (_image != null) {
                    imagePath = await widget.saveImage(_image!); // Bild speichern
                  }

                  // Whisky-Objekt mit neuen Daten aktualisieren
                  final updatedWhisky = Whisky(
                    distillery: _distilleryController.text,
                    age: int.parse(_ageController.text),
                    price: double.parse(_priceController.text),
                    imagePath: imagePath ?? widget.whisky.imagePath,
                    type: _typeController.text,
                    aroma: _aromaController.text,
                    taste: _tasteController.text,
                    finish: _finishController.text,
                    flavorProfiles: widget.whisky.flavorProfiles, // Flavor Profiles bleiben unverändert
                    alcoholContent: double.tryParse(_alcoholContentController.text),
                    region: _regionController.text,
                    rating: widget.whisky.rating, // Rating bleibt unverändert
                    notes: widget.whisky.notes, // Notes bleiben unverändert
                  );

                  // Aktualisiere den Whisky und navigiere zurück
                  widget.updateWhisky(updatedWhisky);
                  Navigator.of(context).pop();
                },
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
