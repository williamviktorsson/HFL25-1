part of 'items_bloc.dart';

sealed class ItemsState extends Equatable {}

class ItemsInitial extends ItemsState {
  @override
  List<Object?> get props => [];
}

class ItemsLoading extends ItemsState {
  @override
  List<Object?> get props => [];
}

class ItemsLoaded extends ItemsState {
  final List<Item> items;

  final Item? pending;

  ItemsLoaded({required this.items, this.pending});

  @override
  List<Object?> get props => [items,pending];
}

class ItemsError extends ItemsState {
  final String message;

  ItemsError({required this.message});

  @override
  List<Object?> get props => [message];
}
