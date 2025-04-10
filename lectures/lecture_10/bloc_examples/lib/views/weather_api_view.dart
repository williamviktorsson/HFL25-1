import 'package:flutter/material.dart';

class WeatherAPIView extends StatelessWidget {
  const WeatherAPIView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Expanded(child: SearchResults()),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),
            onChanged: (value) {
              // TODO 20: dispatch search event to weatherbloc
            },
            onSubmitted: (value) {
              // TODO 17: dispatch search event to weatherbloc
            },
          ),
        ],
      ),
    );
  }
}

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO 18: watch the weatherbloc state and show appropriate widgets

    // TODO 19: show the obtained json from the api using `const JsonEncoder.withIndent(' ').convert(json)`

    return Text("TODO");
  }
}