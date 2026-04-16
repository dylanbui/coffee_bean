
import 'package:coffee_bean/commons/architecture_ribs/navigator.dart';
import 'package:flutter/material.dart';
// import 'package:coffee_bean/commons/architecture_ribs';
import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
// import 'package:simple_auth_1/login_scene/flexhome/flex_home_builder.dart';
// import 'package:simple_auth_1/login_scene/google_map/google_map_builder.dart';
// import 'package:simple_auth_1/login_scene/open_web_view/open_web_view_builder.dart';
import 'package:coffee_bean/scenes/splash_start/splash_start_builder.dart';
// import 'package:simple_auth_1/session_user.dart';
// import 'package:simple_auth_1/typi_code/main_tab/main_tab_builder.dart';
// import 'package:simple_auth_1/typi_code/todos/todo_list_builder.dart';
import 'package:coffee_bean/commons/utils/logger.dart';

// import 'app.dart';
// import 'login_scene/text_editor/text_editor_builder.dart';

// Buildable
abstract class AppBuildable implements DbNoteBuildable { }


class AppBuilder extends DbNoteBuilder with DbNavigator implements DbNoteRoutable, AppBuildable, SplashStartListener {

  @override
  Widget build() {
    final SplashStartBuildable splashStartBuilder = SplashStartBuilder();
    rootPage = splashStartBuilder.buildWithListener(this);
    return rootPage;
  }

  @override
  void splashPageComplete(String? message) {
    // Lay thong tin current user, kiem tra da login chua
    // if (App().currentUser.isLogin()) {
    //   dLog("AppCoordinator -- DA LOGIN ROI");
    //   dLog(App().currentUser.toString());
    // } else {
    //   dLog("AppCoordinator -- CHUAAAA LOGIN");
    // }

    // Sau khi login xong thi chay thang nay
    // final MainTabBuildable mainTabBuilder = MainTabBuilder();
    // final widget = mainTabBuilder.build();

    // final TodoListBuildable todoListBuildable = TodoListBuilder();
    // final widget = todoListBuildable.build();

    // final GoogleMapBuildable googleMapBuildable = GoogleMapBuilder();
    // final widget = googleMapBuildable.build();

    // final FlexHomeBuildable flexHomeBuildable = FlexHomeBuilder();
    // final widget = flexHomeBuildable.build();

    // final OpenWebViewBuildable openWebViewBuildable = OpenWebViewBuilder();
    // final widget = openWebViewBuildable.build();

    // final TextEditorBuildable textEditorBuildable = TextEditorBuilder();
    // final widget = textEditorBuildable.build();

    // pushSameRootPage(widget);

  }

  @override
  void navigate(DbNoteRoute toRoute, {BuildContext? fromContext, String? routeName, Map<String, Object>? parameters}){

  }




}