
import 'package:db_core/architecture_ribs/note_router.dart';

/// [DbPluginController] - Cầu nối giao tiếp 2 chiều.
/// Dung cho cac note co cung cap plugin
/// T: Kiểu Interactor của Con (để Cha gọi Con).
/// L: Kiểu Listener (để Con báo cho Cha).
abstract class DbPluginController<T, L> {
  T? _interactor;
  L? listener;

  void attach(T interactor, {L? listener}) {
    _interactor = interactor;
    // Chỉ ghi đè listener nếu có giá trị mới được truyền vào, nếu không có kiểm tra, mỗi khi gọi attach, this.listener = null
    if (listener != null) {
      this.listener = listener;
    }
  }

  void detach() {
    _interactor = null;
    // Không nên set listener = null ở đây vì listener thường do Cha quản lý 
    // và có thể dùng cho instance tiếp theo của Plugin.
    // listener = null;
  }

  T? get interactor => _interactor;
}

/// [DbPluginBuilder] - Ép buộc dùng Controller để đảm bảo giao tiếp.
abstract class DbPluginBuilder<R extends DbNoteRouter, C extends DbPluginController> {
  R build(C controller);
}