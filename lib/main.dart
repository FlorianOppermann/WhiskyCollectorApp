import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Für den Dateipfad
import 'package:whisky_collector/lib/widgets/add_whisky_popup.dart';
import 'package:whisky_collector/lib/widgets/custom_bottom_navigation.dart';
import 'package:whisky_collector/data/whisky.dart'
    as whisky_data; // Whisky-Modell importieren mit Alias
import 'package:whisky_collector/lib/widgets/whisky_card.dart';
import 'package:whisky_collector/profile_screen.dart';
import 'package:whisky_collector/search_screen.dart';
import 'package:whisky_collector/splash_screen.dart';
import 'package:permission_handler/permission_handler.dart'; // Für Berechtigungen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisky-Collector',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<whisky_data.Whisky> whiskies = [];

  // TextEditingController für jedes Eingabefeld
  final TextEditingController _destilleController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Berechtigungen zur Laufzeit abfragen
  Future<void> _requestPermissions() async {
    // Berechtigungen für Kamera und Speicher abfragen
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }

  // Holen des Datei-Pfades
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Holen der Datei
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/whiskies.json');
  }

  // Speichern der Whiskys in einer Datei
  Future<void> _saveWhiskies() async {
    final file = await _localFile;

    // Konvertieren der Whisky-Liste in JSON
    List<Map<String, dynamic>> whiskyJson =
        whiskies.map((w) => w.toJson()).toList();
    String jsonString = jsonEncode(whiskyJson);

    // Schreiben in die Datei
    file.writeAsString(jsonString);
  }

  // Laden der Whiskys aus der Datei
  Future<void> _loadWhiskies() async {
    try {
      final file = await _localFile;

      // Lesen der Datei
      String contents = await file.readAsString();

      // Dekodieren des JSON und Erstellung der Whisky-Objekte
      List<dynamic> jsonData = jsonDecode(contents);
      setState(() {
        whiskies =
            jsonData.map((json) => whisky_data.Whisky.fromJson(json)).toList();
      });
    } catch (e) {
      // Wenn die Datei nicht existiert oder ein Fehler auftritt
      debugPrint("Fehler beim Laden der Whiskies: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermissions(); // Berechtigungen anfragen
    _loadWhiskies(); // Whiskys beim Starten der App laden
  }

  void _openAddWhiskyPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddWhiskyPopup(
          destilleController: _destilleController,
          ageController: _ageController,
          priceController: _priceController,
          saveImage: _saveImage, // Bildspeicher-Funktion übergeben
          addWhisky: _addWhisky, // Whisky-Hinzufüge-Funktion übergeben
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Speichern des Bildes im lokalen Dateisystem und Rückgabe des Pfades
  Future<String?> _saveImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      final File localImage = await imageFile.copy(imagePath);
      return localImage.path;
    } catch (e) {
      debugPrint("Fehler beim Speichern des Bildes: $e");
      return null;
    }
  }

  void _addWhisky(String? imagePath) {
    String distillery = _destilleController.text;
    int age = int.parse(_ageController.text);
    double price = double.parse(_priceController.text);

    // Erstellen des Whisky-Objekts
    whisky_data.Whisky newWhisky = whisky_data.Whisky(
      distillery: distillery,
      age: age,
      price: price,
      imagePath: imagePath,
    );
    setState(() {
      whiskies.add(newWhisky);
    });

    // Speichern der aktualisierten Liste
    _saveWhiskies();

    // Leeren der Eingabefelder
    _destilleController.clear();
    _ageController.clear();
    _priceController.clear();
  }

  // Funktion zum Aktualisieren eines Whiskys
  void _updateWhisky(whisky_data.Whisky updatedWhisky) {
    setState(() {
      final index = whiskies.indexWhere(
          (whisky) => whisky.distillery == updatedWhisky.distillery);
      if (index != -1) {
        whiskies[index] = updatedWhisky;
      }
    });

    // Speichern der aktualisierten Liste
    _saveWhiskies();
  }

  void _deleteWhisky(whisky_data.Whisky whisky) {
    setState(() {
      whiskies.remove(whisky);
    });

    // Speichern der aktualisierten Liste
    _saveWhiskies();
  }

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      // Startseite
      return ListView.builder(
        itemCount: whiskies.length,
        itemBuilder: (context, index) {
          return WhiskyCard(
            whisky: whiskies[index],
            updateWhisky: _updateWhisky,
            deleteWhisky: _deleteWhisky,
          );
        },
      );
    } else if (_selectedIndex == 1) {
      // Suchseite
      return SearchPage(
        whiskies: whiskies,
        updateWhisky: _updateWhisky,
        deleteWhisky: _deleteWhisky,
      );
    } else if (_selectedIndex == 2) {
      // Profilseite
      return ProfileScreen(
        whiskies: whiskies, // Übergeben der Whiskyliste an die Profilseite
      );
    } else {
      // Weitere Seiten können hier hinzugefügt werden
      return Center(
        child: Text("Seite nicht gefunden"),
      );
    }
  }

  String _getTitle() {
    if (_selectedIndex == 0) {
      return 'Whisky-Collector';
    } else if (_selectedIndex == 1) {
      return 'Whisky Suche';
    } else {
      return 'Profil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          if (_selectedIndex == 0) // Nur auf der Startseite anzeigen
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _openAddWhiskyPopup,
              tooltip: 'Whisky Hinzufügen',
            ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      floatingActionButton: _selectedIndex == 0 && whiskies.length <= 4
          ? FloatingActionButton(
              onPressed: _openAddWhiskyPopup,
              tooltip: 'Whisky Hinzufügen',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
