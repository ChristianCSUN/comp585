import 'package:flutter/material.dart';
import 'package:stockappflutter/components/search_info.dart';

class SearchBarWidget extends StatelessWidget {
  final List<SearchInfo> entries;
  final Function(String symbol, String name) onEntrySelected;

  const SearchBarWidget({
    super.key,
    required this.entries,
    required this.onEntrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      viewHintText: 'Search markets...',
      builder: (BuildContext context, SearchController controller) => GestureDetector(
        onTap: () {
          controller.clear();
          controller.openView();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color(0xFFEAE5EE),
            border: Border.all(
              color: Color(0xFF56525C),
              width: 1,
            )
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF56525C)),
              const SizedBox(width: 8),
              Text(
                'Search markets...',
                style: TextStyle(color: Color(0xFF56525C)),
              ),
            ],
          ),
        ),
      ),
      suggestionsBuilder: (context, controller) {
        final query = controller.text.toLowerCase();
        
        if (query.isEmpty) {
          return const <Widget>[];
        }

        final matches = entries.where((entry) =>
          entry.name.toLowerCase().contains(query) || entry.symbol.toLowerCase().contains(query)).toList();
        
        if(matches.isEmpty) {
          return [
            const ListTile(
              title: Text("No results found", 
              style: TextStyle(color: Colors.grey)
              ),
            ),
          ];
        }

        return matches.map((entry){
          return ListTile(
            title: Text(entry.name),
            subtitle: Text(entry.symbol),
            onTap: () {
              controller.closeView(entry.name);
              onEntrySelected(entry.symbol, entry.name);
            },
          );
        }).toList();
      },
    );
  }
}