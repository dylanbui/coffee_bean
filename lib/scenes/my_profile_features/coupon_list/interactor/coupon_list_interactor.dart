import 'package:coffee_bean/scenes/my_profile_features/coupon_list/coupon_list_router.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// --- Listener ---

abstract interface class CouponListListener {
  void onCouponSelected(CouponModel coupon);
  void onNoCouponSelected();
}

// --- Model ---

class CouponModel {
  final int id;
  final String title;
  final String expiryDate;
  final double discountValue;
  final String discountType;
  final String category;
  final String description;
  final String ruleDescription;
  final bool isSelected;
  final bool isExpanded;

  CouponModel({
    required this.id,
    required this.title,
    required this.expiryDate,
    required this.discountValue,
    required this.discountType,
    required this.category,
    this.description = '',
    this.ruleDescription = '',
    this.isSelected = false,
    this.isExpanded = false,
  });

  CouponModel copyWith({
    bool? isSelected,
    bool? isExpanded,
  }) {
    return CouponModel(
      id: id,
      title: title,
      expiryDate: expiryDate,
      discountValue: discountValue,
      discountType: discountType,
      category: category,
      description: description,
      ruleDescription: ruleDescription,
      isSelected: isSelected ?? this.isSelected,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
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

class CouponListLoaded extends CouponListState {
  CouponListLoaded({required super.coupons, super.isNoCouponSelected});
}

// --- Interactor ---

class CouponListInteractor extends CubitInteractor<CouponListRoutable, CouponListState> {
  final CouponListListener? listener;

  CouponListInteractor(CouponListRoutable router, {this.listener}) : super(CouponListInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    _loadCoupons();
  }

  void _loadCoupons() {
    // Mock data
    final mockCoupons = [
      CouponModel(
        id: 1,
        title: 'Product Voucher Name Long Product Voucher Name',
        expiryDate: '2026/03/12-2027/03/11',
        discountValue: 8,
        discountType: '%',
        category: 'Beverage',
        description: 'Applicable scope: Specific product AAA, Specific product BBB, Specific product CCC',
        ruleDescription: 'Rich Text Content',
      ),
      CouponModel(
        id: 2,
        title: 'Product Voucher Name Long Product Voucher Name',
        expiryDate: '2026/03/12-2027/03/11',
        discountValue: 9,
        discountType: '%',
        category: 'Beverage',
      ),
      CouponModel(
        id: 3,
        title: 'Product Voucher Name Long Product Voucher Name',
        expiryDate: '2026/03/12-2027/03/11',
        discountValue: 10,
        discountType: '%',
        category: 'Beverage',
      ),
    ];
    emit(CouponListLoaded(coupons: mockCoupons));
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
    // final updatedCoupons = state.coupons.map((c) => c.copyWith(isSelected: false)).toList();
    // emit(CouponListLoaded(coupons: updatedCoupons, isNoCouponSelected: true));
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
