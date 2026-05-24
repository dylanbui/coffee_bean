import 'package:db_core/architecture_ribs/note_router.dart';
import 'package:flutter/material.dart';

// --- Routes ---

class ProductDetailRoute implements DbNoteRoute {
  final int productId;
  ProductDetailRoute(this.productId);
}

// --- Routable ---

abstract class ProductDetailRoutable implements DbNoteRoutable {
  // Add specific navigation methods here if needed
}

// --- Router ---

class ProductDetailRouter extends DbNoteRouter implements ProductDetailRoutable {

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}) {
    if (toRoute is ProductDetailRoute) {
      // Implementation for navigating within Product Detail if any
    }
  }
}
