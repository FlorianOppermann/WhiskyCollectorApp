import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whisky_collector/data/whisky.dart';

class EditWhiskyPage extends StatefulWidget {
  final Whisky whisky;
  final Future<String?> Function(File) saveImage;
  final Function(Whisky) updateWhisky;

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

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _distilleryController =
        TextEditingController(text: widget.whisky.distillery);
    _ageController = TextEditingController(text: widget.whisky.age.toString());
    _priceController =
        TextEditingController(text: widget.whisky.price.toString());
    _typeController = TextEditingController(text: widget.whisky.type ?? '');
    _aromaController = TextEditingController(text: widget.whisky.aroma ?? '');
    _tasteController = TextEditingController(text: widget.whisky.taste ?? '');
    _finishController = TextEditingController(text: widget.whisky.finish ?? '');
    _alcoholContentController = TextEditingController(
        text: widget.whisky.alcoholContent?.toString() ?? '');
    _regionController = TextEditingController(text: widget.whisky.region ?? '');
    _image =
        widget.whisky.imagePath != null ? File(widget.whisky.imagePath!) : null;
  }

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
    if (_distilleryController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Bitte eine Destille eingeben.');
      return;
    }
    if (_ageController.text.isEmpty ||
        int.tryParse(_ageController.text) == null) {
      Fluttertoast.showToast(msg: 'Bitte ein gültiges Alter eingeben.');
      return;
    }
    if (_priceController.text.isEmpty ||
        double.tryParse(_priceController.text) == null) {
      Fluttertoast.showToast(msg: 'Bitte einen gültigen Preis eingeben.');
      return;
    }
    if (_alcoholContentController.text.isNotEmpty &&
        double.tryParse(_alcoholContentController.text) == null) {
      Fluttertoast.showToast(
          msg: 'Bitte einen gültigen Alkoholgehalt eingeben.');
      return;
    }

    String? imagePath;
    if (_image != null) {
      imagePath = await widget.saveImage(_image!);
    }

    final updatedWhisky = Whisky(
      distillery: _distilleryController.text,
      age: int.parse(_ageController.text),
      price: double.parse(_priceController.text),
      imagePath: imagePath ?? widget.whisky.imagePath,
      type: _typeController.text,
      aroma: _aromaController.text,
      taste: _tasteController.text,
      finish: _finishController.text,
      flavorProfiles: widget.whisky.flavorProfiles,
      alcoholContent: double.tryParse(_alcoholContentController.text),
      region: _regionController.text,
      rating: widget.whisky.rating,
      notes: widget.whisky.notes,
    );

    widget.updateWhisky(updatedWhisky);
    Navigator.of(context).pop();
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
                onPressed: _validateAndSave,
                child: const Text('Speichern'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
