import 'package:equatable/equatable.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';

class StoreDisplayModel {
  final TblStore store;
  final String distance;
  final bool isOpen;

  const StoreDisplayModel({
    required this.store,
    required this.distance,
    required this.isOpen,
  });
}

abstract class StoreListState extends Equatable {
  final List<StoreDisplayModel> stores;
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
