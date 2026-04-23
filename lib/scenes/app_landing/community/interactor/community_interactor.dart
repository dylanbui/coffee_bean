import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_router.dart';

// Events
abstract class CommunityEvent {}

// States
abstract class CommunityState {}
class CommunityInitial extends CommunityState {}

class CommunityInteractor extends Cubit<CommunityState> {
  final CommunityRoutable router;

  CommunityInteractor(this.router) : super(CommunityInitial());
}
