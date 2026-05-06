import 'dart:developer';

import 'package:coffee_bean/commons/state_management/lib_provider/base_provider_stateless_widget.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_builder.dart';
import 'package:coffee_bean/scenes/rib_samples/splash_start/splash_start_provider.dart';
import 'package:coffee_bean/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//ignore: must_be_immutable
// class SplashStartPage extends BaseStateFulWidget {
//   SplashStartPage({Key? key, DbNavigation? nav}) : super(key: key, nav: nav);
//
//   @override
//   State<StatefulWidget> createState() {
//     return _SplashStartPage();
//   }
// }

// Su dung StateLess hay StateFul cung deu khong Animation dc cho nay
//ignore: must_be_immutable
class SplashStartPage extends BaseProviderStateLessWidget<SplashStartProvider> {
  // const SplashStartPage({Key? key, DbNoteRouter? router}) : super(key: key, router: router);
  SplashStartPage({super.key});

  // class _SplashStartPage extends BaseState<SplashStartPage, SplashStartProvider> {

  @override
  Widget getLayout(BuildContext context) {
    // Goi từ lúc này dễ dàng, nếu muon truc tiep
    // pageProvider.router.navigate(SplashPageCompleteRoute());

    // Gia lap chay lay du lieu tu server
    // pageProvider.fetchSomething().then((value) {
    //   // final router = MaterialPageRoute(builder: (context) => const SplashPage(),);
    //   // Navigator.pushReplacement(context, router);
    //
    //   log("Gia tri tra ve tu fetchSomething : $value");
    //   // router?.navigate(SplashPageCompleteRoute(message: value), fromContext: context);
    //   pageProvider.router.navigate(SplashPageCompleteRoute());
    //
    //   // Navigator.pushReplacement(context, PageTransition(
    //   //     child: const SplashPage(),
    //   //     type: PageTransitionType.fade),);
    //
    //   // Navigator.push(context, PageTransition(
    //   //     child: ChangeNotifierProvider<LoginProvider>.value(value: LoginProvider(), child: const LoginPage(),),
    //   //     type: PageTransitionType.rightToLeft),);
    // });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: [0.1, 0.9],
              colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 90.0),
        child: Image.asset(AppAssets.images.logoTmLabs, fit: BoxFit.scaleDown),
      ),
    );
  }
}
