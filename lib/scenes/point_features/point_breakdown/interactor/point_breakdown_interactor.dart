import 'package:coffee_bean/data/model/response/promotion/point_breakdown.dart';
import 'package:coffee_bean/data/repository/user_repository.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/interactor/point_breakdown_event_state.dart';
import 'package:coffee_bean/scenes/point_features/point_breakdown/point_breakdown_builder.dart';
import 'package:db_core/db_core.dart';

// INTERACTOR
class PointBreakdownInteractor extends CubitInteractor<PointBreakdownRoutable, PointBreakdownState> {
  final UserRepository _userRepository = UserRepository();

  PointBreakdownInteractor(PointBreakdownRoutable router) : super(PointBreakdownInitial(), router: router);

  int _currentPage = 1;
  final int _pageSize = 20;
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
        _currentPage = 1;
      }

      // 3. Gọi Repository lấy dữ liệu
      final result = await _userRepository.fetchPointBreakdown(
        pageNo: _currentPage,
        pageSize: _pageSize,
      );

      if (result case DbSuccess(data: final pageData)) {
        // Lấy danh sách hiện tại: nếu refresh thì bắt đầu từ rỗng, nếu load more thì lấy list cũ
        final List<PointBreakdownItem> currentList = isRefresh ? [] : List.from(state.items);
        final newList = [...currentList, ...pageData.list];
        
        _currentPage++; // Tăng trang cho lần tiếp theo
        
        emit(PointBreakdownDone(
          items: newList,
          hasMore: newList.length < pageData.total, // hasMore chính xác dựa trên total từ server
          isLoadingMore: false,
        ));
      } else {
        // Xử lý lỗi: Giữ nguyên trạng thái cũ
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
