import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:coffee_bean/commons/base_stateless_widget.dart';
import 'package:coffee_bean/scenes/splash_start/splash_start_builder.dart';
import 'package:coffee_bean/scenes/splash_start/splash_start_provider.dart';


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
class SplashStartPage extends BaseStateLessWidget<SplashStartProvider> {

  // const SplashStartPage({Key? key, DbNoteRouter? router}) : super(key: key, router: router);
  SplashStartPage({super.key, super.router});

  // class _SplashStartPage extends BaseState<SplashStartPage, SplashStartProvider> {

  @override
  Widget getLayout(BuildContext context) {

    // Gia lap chay lay du lieu tu server
    pageProvider.fetchSomething().then((value) {
      // final router = MaterialPageRoute(builder: (context) => const SplashPage(),);
      // Navigator.pushReplacement(context, router);

      log("Gia tri tra ve tu fetchSomething : $value");
      router?.navigate(SplashPageCompleteRoute(message: value), fromContext: context);

      // Navigator.pushReplacement(context, PageTransition(
      //     child: const SplashPage(),
      //     type: PageTransitionType.fade),);

      // Navigator.push(context, PageTransition(
      //     child: ChangeNotifierProvider<LoginProvider>.value(value: LoginProvider(), child: const LoginPage(),),
      //     type: PageTransitionType.rightToLeft),);

    });

    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.1, 0.9],
          colors: [
            Color(0xFFFC5C7D),
            Color(0xFF6A82FB),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 90.0),
      child: Image.asset(
        "assets/images/logo_splash.png",
        fit: BoxFit.scaleDown,
      ),
    );
  }

}