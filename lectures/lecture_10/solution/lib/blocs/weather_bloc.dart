import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

sealed class WeatherEvent {}

class WeatherSearch extends WeatherEvent {
  final String city;

  WeatherSearch({required this.city});
}

sealed class WeatherState {}

final class WeatherInitial extends WeatherState {
  WeatherInitial();
}

final class WeatherSearching extends WeatherState {
  final String city;

  WeatherSearching({required this.city});
}

final class WeatherFound extends WeatherState {
  final String city;
  final Map<String, dynamic> json;

  WeatherFound({required this.city, required this.json});
}

final class WeatherNotFound extends WeatherState {
  final String city;
  final String error;

  WeatherNotFound({required this.city, required this.error});
}

// TODO 15: Create additional weather search states

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    const String apiUrl = 'https://goweather.herokuapp.com/weather/';

    on<WeatherEvent>((event, emit) async {
      switch (event) {
        case WeatherSearch(:var city):
          emit(WeatherSearching(city: city));
          Response response = await http.get(Uri.parse(apiUrl + city));
          if (response.statusCode == 200) {
            emit(WeatherFound(city: city, json: json.decode(response.body)));
          } else {
            emit(WeatherNotFound(city: city, error: response.body));
          }
      }
    }
    , transformer: (events,mapper)=>events.debounceTime(Duration(milliseconds: 1000)).switchMap(mapper));

    // TODO 16: handle all events and emit states

    // TODO 21: handle debouncing of events using rxdart
    // https://pub.dev/documentation/bloc_event_transformers/latest/bloc_event_transformers/debounce.html
    // https://stackoverflow.com/a/71054792
  }
}
