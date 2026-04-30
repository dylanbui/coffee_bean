import 'package:coffee_bean/commons/state_management/lib_bloc/base_cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/splash_page/splash_page_interactor.dart';
import 'package:coffee_bean/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//ignore: must_be_immutable
class SplashPagePage extends BaseCubitStateFulWidget {
  SplashPagePage({super.key}) {
    // Hide the default AppBar for this splash screen.
    showAppBar = false;
  }

  @override
  State<SplashPagePage> createState() => _SplashPagePageState();
}

class _SplashPagePageState extends BaseCubitState<SplashPagePage, SplashPageInteractor, dynamic> {
  @override
  void initState() {
    super.initState();
    // When the page is initialized, trigger the data fetching logic in the Interactor.
    // We use the `interactor` that is readily available from BaseCubitState.
    interactor.fetchSomething();
  }

  @override
  Widget getBody(BuildContext context) {
    // This is the UI for the splash screen.
    // It doesn't need to listen for state changes because the UI is static.
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, stops: [0.1, 0.9], colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 90.0),
        child: Image.asset(AppAssets.images.logoTmLabs, fit: BoxFit.scaleDown),
      ),
    );
  }
}
