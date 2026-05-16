import 'package:coffee_bean/core/architecture_ribs/note_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_statefull_widget.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/interactor/user_list_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/user_list/interactor/user_list_interactor.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class UserListPage extends BaseBlocStateFulWidget {
  UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends BaseBlocViewState<UserListPage, UserListInteractor, dynamic> {
  @override
  String getAppBar(BuildContext context) => "User List";

  @override
  void initState() {
    super.initState();
    // Trigger the data fetch event when the page is initialized.
    blocProvider.add(UserListFetchDataEvent());
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<UserListInteractor, BaseBlocState>(
      builder: (context, state) {
        if (state is UserListInProgress) {
          return const Center(child: LoadingView(width: 100, height: 100));
        }
        if (state is UserListGetDataError) {
          return Center(child: Text('Failed to load users: ${state.error.message}'));
        }
        if (state is UserListGetDataSuccess) {
          final users = state.users;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(user.avatar),
                ),
                title: Text(user.name),
                subtitle: Text(user.email),
              );
            },
          );
        }
        return const Center(child: Text('Welcome to User List!'));
      },
    );
  }
}