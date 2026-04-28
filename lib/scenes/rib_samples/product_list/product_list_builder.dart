/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 04/07/2022 - 15:49
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/commons/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/product_list/interactor/product_list_interactor.dart';
import 'package:coffee_bean/scenes/product_list/interactor/product_list_page.dart';
import 'package:coffee_bean/scenes/product_list/product_list_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Listener


// Buildable

abstract class ProductListBuildable implements DbNoteBuildable {

  @override
  Widget build({bool showAppBarOnRootPage = true});
  // DbNoteViewControllable buildNote({bool showAppBarOnRootPage = true});

}


// Builder

class ProductListBuilder extends DbNoteBuilder implements ProductListBuildable {

  // PostBuilder({bool showAppBarOnRootPage = true}) : super() {
  //   var postListPage = PostListPage(router: this,);
  //   postListPage.showAppBar = showAppBarOnRootPage;
  //   rootPage = ChangeNotifierProvider<PostListProvider>.value(value: PostListProvider(), child: postListPage,);
  // }

  // @override
  // void start(BuildContext fromContext) {
  //   Navigator.push(fromContext, PageTransition(child: rootPage, type: PageTransitionType.rightToLeft),);
  // }
  //
  // @override
  // void startSameRootPage(BuildContext fromContext) {
  //   // TODO: implement startSameRootController
  //   // Navigator.pushAndRemoveUntil(buildContext, PageTransition(child: rootPage, type: PageTransitionType.rightToLeft),
  //   //         (route) => route.isFirst == true);
  //
  //   Navigator.pushAndRemoveUntil(fromContext,
  //     PageTransition(child: rootPage,
  //         type: PageTransitionType.rightToLeft,
  //         settings: const RouteSettings(name: "ten")), (route) => false,);
  // }
  //
  // @override
  // void navigate(DbNoteRoute toRoute, BuildContext nextContext, {Map<String, Object>? parameters}) {
  //
  //   if (toRoute is PostDetailRoute) {
  //     final postDetailBuilder = PostDetailBuilder(toRoute.postId);
  //     postDetailBuilder.start(nextContext);
  //   }
  //
  //
  // }

  @override
  Widget build({bool showAppBarOnRootPage = true}) {
    final router = ProductListRouter();
    final productListInteractor = ProductListInteractor(router);
    // productListInteractor.router = router;
    final page = ProductListPage();
    rootPage = BlocProvider(create: (_) =>  productListInteractor, child: page,);
    return rootPage;
  }

  // @override
  // DbNoteViewControllable buildNote({bool showAppBarOnRootPage = true}) {
  //   final router = PostRouter();
  //   final postListInteractor = PostListInteractor(router);
  //   final page = PostListPage();
  //   viewControllable = BlocProvider(create: (_) =>  postListInteractor, child: page,) as DbNoteViewControllable;
  //   return viewControllable;
  // }




}