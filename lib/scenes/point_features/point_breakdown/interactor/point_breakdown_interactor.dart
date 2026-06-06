import 'package:coffee_bean/data/model/response/point_breakdown.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_event_state.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/point_breakdown_builder.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// INTERACTOR
class PointBreakdownInteractor extends CubitInteractor<PointBreakdownRoutable, PointBreakdownState> {
  final UserRepository _userRepository = UserRepository();

  PointBreakdownInteractor(PointBreakdownRoutable router) : super(PointBreakdownInitial(), router: router);

  int _currentOffset = 0;
  final int _limit = 20;
  bool _isBusy = false;

  @override
  void onDidBecomeActive() async {
    super.onDidBecomeActive();
    // Bao trang thai bat dau load
    emit(PointBreakdownStartLoading());
    // Khởi tạo load dữ liệu lần đầu
    loadData(isRefresh: true);
  }

  Future<void> loadData({bool isRefresh = true}) async {
    // 1. Kiểm tra điều kiện chặn: đang bận hoặc load more khi đã hết dữ liệu
    if (_isBusy || (!isRefresh && !state.hasMore)) return;

    _isBusy = true;

    try {
      // 2. Cập nhật trạng thái loading
      if (isRefresh) {
        _currentOffset = 0;
      }

      // 3. Gọi Repository lấy dữ liệu
      final (items, error) = await _userRepository.fetchPointBreakdown(
        offset: _currentOffset,
        limit: _limit,
      );

      if (items != null) {
        // Lấy danh sách hiện tại: nếu refresh thì bắt đầu từ rỗng, nếu load more thì lấy list cũ
        final List<PointBreakdownItem> currentList = isRefresh ? [] : List.from(state.items);
        final newList = [...currentList, ...items];
        _currentOffset = newList.length; // Cập nhật offset mới dựa trên tổng số item đã có
        emit(PointBreakdownDone(
          items: newList,
          hasMore: items.length == _limit, // Nếu server trả về đủ limit thì giả định còn dữ liệu
          isLoadingMore: false,
        ));
      } else {
        // Xử lý lỗi: Duoc xem nhu khong tim thay du lieu
        emit(PointBreakdownDone(
          items: state.items,
          hasMore: state.hasMore,
          isLoadingMore: false,
        ));
      }
    } catch (e) {
      emit(PointBreakdownDone(
        items: state.items,
        hasMore: state.hasMore,
        isLoadingMore: false,
      ));
    } finally {
      _isBusy = false;
    }
  }

}
