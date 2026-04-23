import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/app_landing/my_profile/my_profile_router.dart';

// Events
abstract class MyProfileEvent {}

// States
abstract class MyProfileState {}
class MyProfileInitial extends MyProfileState {}

class MyProfileInteractor extends Cubit<MyProfileState> {
  final MyProfileRoutable router;

  MyProfileInteractor(this.router) : super(MyProfileInitial());
}
