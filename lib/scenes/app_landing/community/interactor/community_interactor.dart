import 'package:coffee_bean/core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:coffee_bean/scenes/app_landing/community/community_router.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';

// States
abstract class CommunityState extends BaseBlocState {}
class CommunityInitial extends CommunityState {}

class CommunityInteractor extends CubitInteractor<CommunityRoutable, CommunityState> {

  CommunityInteractor(CommunityRoutable router) : super(CommunityInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    // Load data if needed
  }
}
