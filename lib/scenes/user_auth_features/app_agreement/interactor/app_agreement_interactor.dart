/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 */

import 'package:coffee_bean/data/repository/infra_repository.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/app_agreement_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/app_agreement/interactor/app_agreement_event_state.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';
import 'package:db_core/utils/locator.dart';
import 'package:db_core/network/network_common.dart';

class AppAgreementInteractor extends CubitInteractor<AppAgreementRoutable, AppAgreementState> {
  final int type;

  AppAgreementInteractor({AppAgreementRoutable? router, required this.type})
      : super(AppAgreementInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  Future<void> loadData() async {
    emit(AppAgreementInProgress());
    final result = await locator<InfraRepository>().getAgreementDictionary(type);
    if (result case DbSuccess(:final data)) {
      emit(AppAgreementSuccess(data: data));
    } else if (result case DbFailure(:final error)) {
      emit(AppAgreementError(message: error.message));
    }
  }
}
