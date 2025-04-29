import 'package:flutter/material.dart';
import 'package:stockappflutter/components/market_card.dart';
import 'package:stockappflutter/components/market_data.dart';

class SearchBarWidget extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final List<MarketData> markets;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.markets,
  });

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      viewHintText: 'Search markets...',
      builder: (BuildContext context, SearchController controller) {
        return GestureDetector(
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
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        final query = controller.text.toLowerCase();
        final matches = markets.where((m) {
          return m.name.toLowerCase().contains(query) || m.symbol.toLowerCase().contains(query);
        }).toList();

        if (matches.isEmpty) {
          return [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Center(
                  child: Text(
                    'No results found',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
          ];
        }

        return matches.map((market) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: MarketCard(market: market),
          );
        }).toList();
      },
    );
  }
}