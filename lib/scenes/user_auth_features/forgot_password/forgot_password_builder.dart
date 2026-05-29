/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 5/5/26 - 15:00
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/forgot_password_router.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/interactor/forgot_password_interactor.dart';
import 'package:coffee_bean/scenes/user_auth_features/forgot_password/interactor/forgot_password_page.dart';

// --- BUILDER ---
// Responsible for initializing the Interactor, Page, and connecting them.
class ForgotPasswordBuilder extends DbNoteBuilder<ForgotPasswordRouter> {

  ForgotPasswordBuilder();

  @override
  ForgotPasswordRouter build() {
    final router = ForgotPasswordRouter();
    final interactor = ForgotPasswordInteractor(router);
    final page = ForgotPasswordPage(interactor: interactor);

    // Attach interactor and page to router as per RIBs standard
    router.attach(interactor, page);

    return router;
  }
}
