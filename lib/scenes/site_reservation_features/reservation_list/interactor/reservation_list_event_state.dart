import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:equatable/equatable.dart';

abstract class ReservationListState extends Equatable {
  final List<TblReservation> reservations;
  final List<TblCategory> categories;
  final TblCategory? selectedCategory;
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
