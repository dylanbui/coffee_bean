/*
 * Created with IntelliJ IDEA
 * Package: 
 * User: dylanbui
 * Email: duc@propzy.com
 * Date: 07/07/2022 - 19:34
 * To change this template use File | Settings | File Templates.
 */


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loadmore/loadmore.dart';
// import 'package:simple_auth_1/commons/architecture_ribs/note_router.dart';
// import 'package:simple_auth_1/commons/architecture_ribs/note_view_controllable.dart';
// import 'package:simple_auth_1/commons/base_statefull_widget.dart';
// import 'package:simple_auth_1/commons/custom_app_bar.dart';
// import 'package:simple_auth_1/models/post.dart';
// import 'package:simple_auth_1/typi_code/posts/interactor/post_list_event_state.dart';
// import 'package:simple_auth_1/typi_code/todos/interactor/todo_list_state.dart';
// import 'package:simple_auth_1/utils/logger.dart';
// import 'package:simple_auth_1/widget/platform_progress.dart';
// import 'post_list_interactor.dart';

/*

class PostListPage extends StatefulWidget with DbNoteViewControllable {

  final String title = "UserList Page";

  PostListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PostListPageState();
  }

}

class _PostListPageState extends State<PostListPage> {

  late PostListInteractor pageInteractor;
  late PostListState currentState;


  @override
  void initState() {
    super.initState();
    // pageInteractor.router?.newPop();
  }


  @override
  Widget build(BuildContext context) {
    pageInteractor = BlocProvider.of<PostListInteractor>(context);
    currentState = pageInteractor.state;

    String getTitle() {
      return "Post List Page";
    }

    List<Widget> getAppBarAction() {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            eLog("click : Icons.notifications");
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            eLog("click : Icons.person");
          },
        ),
      ];
    }

    CustomAppBar getAppBar(BuildContext context, PostListState state) {
      return CustomAppBar(getTitle(), appBarActions: getAppBarAction(), hideBackButton: true,);
    }

    return BlocConsumer<PostListInteractor, PostListState>(listener: (context, state) {
      // Show toast event at here
      if (state is PostListGetDataError) {
        // showToast(state.error.messenger);
        // showErrorSnackbar(state.error.messenger, context);
        eLog("blocConsumerListener");
      }
    }, buildWhen: (previousState, currentState) {
      eLog("blocConsumerBuildWhen");
      if (currentState is PostListGetDataError) {
        // showToast(state.error.messenger);
        // showErrorSnackbar(state.error.messenger, context);
        return false;
      }
      return true;
    }, builder: (context, state) {
      return Scaffold(
        appBar: getAppBar(context, state),
        body: getBody(context, state),
      );
    });
  }



  Widget getBody(BuildContext context, PostListState state) {
    if (state is PostListInProgress) {
      return const Center(child: PlatformProgress());
    } else if (state is PostListGetDataError) {
      //var state = state as TodoListGetDataError;
      // show loi
      // showErrorSnackbar(state.error.messenger, context);
      // showToast(state.error.messenger);
      return const Text("PostListGetDataError");
    }

    return _listView(context, state);

    // return _buildTodosList(context, state);
  }

  Widget _listView(BuildContext context, PostListState state) {
    List<Post> items = [];
    if (state is PostListGetDataSuccess) {
      items = state.items;
    }

    return RefreshIndicator(
      onRefresh: () async {
        eLog("reload data");
        // await Future.delayed(const Duration(seconds: 2));
        await pageInteractor.onRefresh();
      },
      child: LoadMore(
        isFinish: false,
        onLoadMore: _loadMore,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Text(items[index].title.toString()),
              height: 80.0,
              alignment: Alignment.center,
            );
          },
          itemCount: items.length,
        ),
        whenEmptyLoad: true,
        delegate: const DefaultLoadMoreDelegate(),
        // textBuilder: DefaultLoadMoreTextBuilder.chinese,
      ),
      color: Colors.white,
      backgroundColor: Colors.purple,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
    );
  }

  Future<bool> _loadMore() async {
    eLog("onLoadMore");
    await Future.delayed(const Duration(seconds: 0, milliseconds: 2000));
    pageInteractor.loadMoreData();
    // load();
    return true;
  }

}

 */