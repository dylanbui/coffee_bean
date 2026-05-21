import 'package:equatable/equatable.dart';

class Store {
  final String id;
  final String name;
  final String address;
  final String hours;
  final String distance;
  final bool isOpen;
  final String? imageUrl;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.hours,
    required this.distance,
    this.isOpen = true,
    this.imageUrl,
  });
}

abstract class StoreListState extends Equatable {
  final List<Store> stores;
  final String searchQuery;
  final bool isLocationAuthorized;
  final bool isManualSelection;
  final bool isLocating;

  const StoreListState({
    this.stores = const [],
    this.searchQuery = '',
    this.isLocationAuthorized = false,
    this.isManualSelection = false,
    this.isLocating = false,
  });

  @override
  List<Object?> get props => [stores, searchQuery, isLocationAuthorized, isManualSelection, isLocating];
}

class StoreListInitial extends StoreListState {
  const StoreListInitial() : super();
}

class StoreListLoading extends StoreListState {
  const StoreListLoading({
    super.stores,
    super.searchQuery,
    super.isLocationAuthorized,
    super.isManualSelection,
    super.isLocating,
  });
}

class StoreListLoaded extends StoreListState {
  const StoreListLoaded({
    required super.stores,
    super.searchQuery,
    super.isLocationAuthorized,
    super.isManualSelection,
    super.isLocating,
  });
}

class StoreListError extends StoreListState {
  final String message;
  const StoreListError(this.message, {
    super.stores,
    super.searchQuery,
    super.isLocationAuthorized,
    super.isManualSelection,
    super.isLocating,
  });

  @override
  List<Object?> get props => [message, ...super.props];
}
