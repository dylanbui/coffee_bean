import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:equatable/equatable.dart';

abstract class ReservationListState extends Equatable {
  final List<VenueInfo> reservations;
  final List<DictionaryData> categories;
  final DictionaryData? selectedCategory;
  final String searchQuery;
  final bool isLoading;

  const ReservationListState({
    this.reservations = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = "",
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [reservations, categories, selectedCategory, searchQuery, isLoading];
}

class ReservationListInitial extends ReservationListState {
  const ReservationListInitial() : super();
}

class ReservationListLoading extends ReservationListState {
  const ReservationListLoading({
    super.reservations,
    super.categories,
    super.selectedCategory,
    super.searchQuery,
  }) : super(isLoading: true);
}

class ReservationListLoaded extends ReservationListState {
  const ReservationListLoaded({
    required super.reservations,
    required super.categories,
    super.selectedCategory,
    super.searchQuery,
  }) : super(isLoading: false);
}
