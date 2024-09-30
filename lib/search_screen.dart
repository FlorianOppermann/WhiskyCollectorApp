import 'package:flutter/material.dart';
import 'package:whisky_collector/data/whisky.dart' as whisky_data;
import 'package:whisky_collector/lib/widgets/whisky_card.dart';

class SearchPage extends StatefulWidget {
  final List<whisky_data.Whisky> whiskies;
  final Function(whisky_data.Whisky) updateWhisky;
  final Function(whisky_data.Whisky) deleteWhisky;

  SearchPage({
    required this.whiskies,
    required this.updateWhisky,
    required this.deleteWhisky,
  });

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<whisky_data.Whisky> filteredWhiskies = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Zu Beginn zeigen wir alle Whiskies an
    filteredWhiskies = widget.whiskies;
    // Überwachen der Suchfeldänderungen
    searchController.addListener(filterWhiskies);
  }

  void filterWhiskies() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredWhiskies = widget.whiskies.where((whisky) {
        return whisky.distillery.toLowerCase().contains(query) ||
            whisky.age.toString().contains(query) ||
            whisky.price.toString().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  labelText: 'Suche',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search)),
            )),
        Expanded(
          child: ListView.builder(
            itemCount: filteredWhiskies.length,
            itemBuilder: (context, index) {
              return WhiskyCard(
                whisky: filteredWhiskies[index],
                updateWhisky: (updatedWhisky) {
                  widget.updateWhisky(updatedWhisky);
                  filterWhiskies();
                },
                deleteWhisky: (whiskyToDelete) {
                  widget.deleteWhisky(whiskyToDelete);
                  filterWhiskies();
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
