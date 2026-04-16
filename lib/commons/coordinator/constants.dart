

import 'package:flutter/material.dart';

abstract class DbDefineRoute {

}

// Ban chat cua implements khhong the co default function, toan bo phai overwrite lai
abstract class DbNavigation {

  void navigate(DbDefineRoute toRoute, BuildContext nextContext, {Map<String, Object>? parameters});

  void pop(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.pop(context);
    }
  }

}

abstract class DbCoordinator {

  // Dung buildContext khong co y nghia o day, moi context co the nghi no la 1 note trong cay
  // BuildContext buildContext;
  late Widget rootPage;

  DbCoordinator();

  void start(BuildContext fromContext);
  void startSameRootPage(BuildContext fromContext) {}



}

/* *

interface DbEnumRoute {}

interface DbNavigation {
    fun navigate(toRoute: DbEnumRoute, context: Context? = null, parameters: Any? = null)

    fun popCurrentController(router: Router) {
        if (router.backstackSize > 1) router.popCurrentController()
    }

    fun getParentRouter(): Router? = null
}

abstract class DbCoordinator(val router: Router) {

    // abstract var router: Router

    // abstract var rootController: Controller

    abstract var rootController: Controller

    // constructor(router: Router)

    abstract fun start(isModal: Boolean = false, option: Any? = null)

    abstract fun startSameRootController(option: Any? = null)
}


abstract class DbBaseCoordinator(router: Router) : DbCoordinator(router) {

    // override var router = router

    override fun start(isModal: Boolean, option: Any?) {
        if (isModal) {
            router.defaultPushModalController(rootController)
        } else {
            router.defaultPushController(rootController)
        }
    }

    override fun startSameRootController(option: Any?) {
        router.defaultSetRootController(rootController)
    }

}





* */