
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/home/home_router.dart';

// Events
abstract class HomeEvent {}

// States
abstract class HomeState {}
class HomeInitial extends HomeState {}

class HomeInteractor extends Cubit<HomeState> {
  final HomeRoutable router;

  HomeInteractor(this.router) : super(HomeInitial());
}
