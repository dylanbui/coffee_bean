
import 'package:coffee_bean/commons/commons_constants.dart';
import 'package:dialog_loader/dialog_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:coffee_bean/commons/architecture_ribs/note_router.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';

// https://github.com/FlorinMihalache/flutter_progress_hud

//ignore: must_be_immutable
abstract class BaseCubitStateFulWidget extends StatefulWidget {

  DbNoteRouter? router;
  bool showAppBar = true;

  BaseCubitStateFulWidget({super.key, this.router});
}

// abstract class BaseBlocState<B extends BaseBlocStateFulWidget, P extends BaseProvider> extends State<B> {
// abstract class BaseCubitStateLessWidget<P extends Cubit<S>, S> extends StatelessWidget {

abstract class BaseCubitState<B extends BaseCubitStateFulWidget, P extends Cubit<State>> extends State<B> {

  /// should be overridden in extended widget
  Widget? getLayout(BuildContext context) => null;

  // void startBuild(BuildContext context) { }
  dynamic getAppBar(BuildContext context) => "";
  Widget getBody(BuildContext context) => const Text("implement getBody() function");
  List<Widget> getAppBarAction() => [];


  late BuildContext buildContext;
  DialogLoader? dialogLoader;

  late P pageProvider;

  // P createProvider(BuildContext context);

  // @override
  // Widget build(BuildContext context) {
  //   buildContext = context;
  //   return getLayout();
  // }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    pageProvider = Provider.of<P>(context);
    dialogLoader = DialogLoader(context: buildContext);

    // Muon control thang nao thi phai dung context thang do
    var layout = getLayout(context);
    if (layout != null) {
      return layout;
    }

    var appBar = getAppBar(context);
    if (appBar is String) {
      // tao 1 custom use for common theme
      appBar = CustomAppBar(appBar, appBarActions: getAppBarAction(),);
    }

    // if (appBar is! AppBar) {
    //   throw Exception("Need to AppBar Widget or String !");
    // }

    if (widget.showAppBar == false) {
      appBar = null;
    }

    return Scaffold(
      appBar: appBar,
      body: getBody(context),
    );
  }
  //region Private Support Methods

  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  // TODO: Cai nay co the chay sai, chua dc kiem chung
  void showErrorSnackbar(String message) {
    var snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.yellowAccent,
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // Scaffold.of(context).showSnackBar(snackBar); // Da bi deprecated
  }

  void showProgressLoading({String? text = "Đang xử lý ..."}) {
    // LoadingIndicatorDialog().show(context, text: text ?? "Đang xử lý");
    dialogLoader?.show(
      theme: LoaderTheme.dialogDefault,
      title: Container(
        padding: const EdgeInsets.all(10),
        child: Text(text ?? "Đang xử lý ...", style: AppTheme.textStyle_2,),
      ),
      leftIcon: const SizedBox(
        child: CircularProgressIndicator(),
        height: 30.0,
        width: 30.0,
      ),
    );

    // Xai khong tot
    // final progress = ProgressHUD.of(_contextLoading);
    // if (text == null) {
    //   progress?.show();
    // } else {
    //   progress?.showWithText(text);
    // }
  }

  void hideProgressLoading() {
    // LoadingIndicatorDialog().dismiss();
    dialogLoader?.close();

    // Xai khong tot
    // final progress = ProgressHUD.of(_contextLoading);
    // progress?.dismiss();
  }

  //endregion

}



