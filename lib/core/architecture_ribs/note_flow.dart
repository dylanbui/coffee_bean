import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:coffee_bean/core/architecture_ribs/note_router.dart';
import 'package:coffee_bean/core/architecture_ribs/note_interactor.dart';

/// DbNoteFlow: A unified Builder + Router for multi-screen business flows.
/// [L]: The Listener interface type used to communicate results back to the parent.
///
/// It encapsulates an entire sequence of screens (e.g., Auth, Checkout, Onboarding) 
/// into a single entity, providing auto-cleanup of the navigation stack.
///
/// ### Usage Example:
///
/// ```dart
/// // 1. Define a Listener for the parent to receive results
/// abstract interface class CheckoutFlowListener {
///   void onCheckoutSuccess(String orderId);
///   void onCheckoutCancelled();
/// }
///
/// // 2. Implement the Flow (Combines Builder & Router roles)
/// class CheckoutFlow extends DbNoteFlow<CheckoutFlowListener> {
///   @override
///   void onStart() {
///     // Build the first module
///     final cartRouter = CartBuilder().build();
///     cartRouter.parentRouter = this;
///
///     // Execute flow with the initial page (e.g., as a Modal)
///     runFlow(cartRouter.interactor, cartRouter.viewController, 
///             transitionType: PageTransitionType.bottomToTop);
///   }
///
///   @override
///   void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, ...}) {
///     if (toRoute is GoToPaymentRoute) {
///       final paymentRouter = PaymentBuilder().build();
///       paymentRouter.parentRouter = this;
///       navigator.push(paymentRouter.viewController);
///     }
///   }
///
///   @override
///   void onCancel() => listener?.onCheckoutCancelled();
///
///   void completeCheckout(String id) {
///     listener?.onCheckoutSuccess(id);
///     finish(); // Automatically pops all pages in this flow
///   }
/// }
///
/// // 3. Usage from a Parent Router
/// void startCheckout(CheckoutFlowListener listener) {
///   CheckoutFlow().start(this, listener);
/// }
/// ```
abstract class DbNoteFlow<L> extends DbNoteRouter {
  L? listener;
  bool _isFinishing = false;

  /// Unique ID to anchor the flow in the Navigator stack for auto-cleanup.
  String get flowId => "Flow_${runtimeType}_$hashCode";

  /// Entry point: Initializes the flow and sets the listener.
  void start(DbNoteRouter parentRouter, L listener) {
    this.parentRouter = parentRouter;
    this.listener = listener;
    onStart();
  }

  /// Subclasses implement this to define the flow's starting logic.
  @protected
  void onStart();

  /// Helper to initialize RIB components and push the first screen.
  /// [transitionType]: Use bottomToTop for Modal or rightToLeft for Normal.
  @protected
  void runFlow(DbNoteInteractor interactor, ViewController initialPage, {PageTransitionType transitionType = PageTransitionType.rightToLeft}) {
    // 1. RIBs Wiring (Builder role)
    attach(interactor, initialPage);

    // 2. Lifecycle Protection: Handle hardware back button or manual swipe-to-close
    final safePage = PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // If user pops the first page manually, trigger onCancel
        if (didPop && !_isFinishing) {
          onCancel();
        }
      },
      child: initialPage,
    );

    // 3. Navigate with unique name for auto-cleanup and custom transition
    navigator.push(safePage, routeName: flowId, transitionType: transitionType);
  }

  /// Hook for subclasses to notify the listener about flow cancellation.
  @protected
  void onCancel();

  /// Successfully finishes the flow and cleans up the UI stack.
  void finish() {
    _isFinishing = true;
    // Auto-cleanup: Clear all pages belonging to this flow stack
    navigator.popUntilBefore(flowId);
    // Cleanup reference to prevent memory leaks
    listener = null;
  }
}
