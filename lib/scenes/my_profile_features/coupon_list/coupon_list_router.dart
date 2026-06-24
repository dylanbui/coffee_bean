import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

abstract class CouponListRoutable implements DbNoteRoutable {

}

class CouponListRouter extends DbNoteRouter implements CouponListRoutable {
  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    // Handle specific navigation for CouponList
  }


}
