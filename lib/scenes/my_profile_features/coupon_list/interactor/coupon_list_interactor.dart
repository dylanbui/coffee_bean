import 'package:coffee_bean/data/model/response/promotion/coupon_model.dart';
import 'package:coffee_bean/data/repository/promotion_repository.dart';
import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_router.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// --- Listener ---

abstract interface class CouponListListener {
  void onCouponSelected(CouponModel coupon);
  void onNoCouponSelected();
}

// --- States ---

abstract class CouponListState extends BaseBlocState {
  final List<CouponModel> coupons;
  final bool isNoCouponSelected;

  CouponListState({required this.coupons, this.isNoCouponSelected = false});

  @override
  List<Object?> get props => [coupons, isNoCouponSelected];
}

class CouponListInitial extends CouponListState {
  CouponListInitial() : super(coupons: []);
}

class CouponListLoading extends CouponListState {
  CouponListLoading() : super(coupons: []);
}

class CouponListLoaded extends CouponListState {
  CouponListLoaded({required super.coupons, super.isNoCouponSelected});
}

class CouponListError extends CouponListState {
  final String message;
  CouponListError(this.message, {required super.coupons});

  @override
  List<Object?> get props => [...super.props, message];
}

// --- Interactor ---

class CouponListInteractor extends CubitInteractor<CouponListRoutable, CouponListState> {
  final CouponListListener? listener;
  final _repository = PromotionRepository();

  CouponListInteractor(CouponListRoutable router, {this.listener}) : super(CouponListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    emit(CouponListLoading());
    final result = await _repository.getCouponPage();
    
    result.when(
      success: (coupons) {
        emit(CouponListLoaded(coupons: coupons));
      },
      failure: (error) {
        emit(CouponListError(error.message, coupons: []));
      },
    );
  }

  void toggleExpand(int index) {
    if (state is! CouponListLoaded) return;
    final updatedCoupons = List<CouponModel>.from(state.coupons);
    updatedCoupons[index] = updatedCoupons[index].copyWith(isExpanded: !updatedCoupons[index].isExpanded);
    emit(CouponListLoaded(coupons: updatedCoupons, isNoCouponSelected: state.isNoCouponSelected));
  }

  void selectCoupon(int index) {
    if (state is! CouponListLoaded) return;
    final updatedCoupons = state.coupons.asMap().entries.map((entry) {
      return entry.value.copyWith(isSelected: entry.key == index);
    }).toList();
    emit(CouponListLoaded(coupons: updatedCoupons, isNoCouponSelected: false));
  }

  void selectNoCoupon() {
    if (state is! CouponListLoaded) return;
    listener?.onNoCouponSelected();
    router?.pop();
  }

  void confirmSelection() {
    if (state is! CouponListLoaded) return;

    if (state.isNoCouponSelected) {
      listener?.onNoCouponSelected();
    } else {
      final selectedCoupon = state.coupons.cast<CouponModel?>().firstWhere((c) => c?.isSelected ?? false, orElse: () => null);
      if (selectedCoupon != null) {
        listener?.onCouponSelected(selectedCoupon);
      }
    }
    router?.pop();
  }
}
