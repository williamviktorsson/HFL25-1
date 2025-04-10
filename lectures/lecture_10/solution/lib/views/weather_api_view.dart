import 'dart:convert';

import 'package:bloc_examples/blocs/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              context.read<WeatherBloc>().add(WeatherSearch(city: value));
            },
            onSubmitted: (value) {},
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

    WeatherState state = context.watch<WeatherBloc>().state;

    return switch (state) {
      // TODO: Handle this case.
      WeatherInitial() => Center(
          child: Text("Search for a city..."),
        ),
      // TODO: Handle this case.
      WeatherSearching() => Center(
          child: CircularProgressIndicator(),
        ),
      // TODO: Handle this case.
      WeatherFound() => Center(
          child: Column(
            children: [
              Text("Weather for: ${state.city}"),
              Divider(),
              Text(const JsonEncoder.withIndent(' ').convert(state.json)),
            ],
          ),
        ),
      // TODO: Handle this case.
      WeatherNotFound() => Center(
          child: Column(
            children: [
              Text("No results found for: ${state.city}"),
              Divider(),
              Text(state.error),
            ],
          ),
        ),
    };
  }
}
