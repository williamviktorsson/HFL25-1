import 'package:replay_bloc/replay_bloc.dart';
import 'package:shared/shared.dart';

class SelectedItemCubit extends ReplayCubit<Item?> {
  SelectedItemCubit() : super(null);

  select(Item item) {
    emit(item);
  }

  deselect() {
    emit(null);
  }
}