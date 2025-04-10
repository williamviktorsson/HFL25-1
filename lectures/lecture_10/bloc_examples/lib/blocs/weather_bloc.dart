
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class WeatherEvent {}

// TODO 15: Create additional weather search events

sealed class WeatherState {}

final class WeatherInitial extends WeatherState {
  WeatherInitial();
}

// TODO 15: Create additional weather search states

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    const String apiUrl = 'https://goweather.herokuapp.com/weather/';

    // TODO 16: handle all events and emit states

    // TODO 21: handle debouncing of events using rxdart
    // https://pub.dev/documentation/bloc_event_transformers/latest/bloc_event_transformers/debounce.html
    // https://stackoverflow.com/a/71054792

  }
}
