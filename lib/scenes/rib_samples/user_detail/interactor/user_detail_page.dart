import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/bloc_statefull_widget.dart';
import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:coffee_bean/data/model/user.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_interactor.dart';
import 'package:coffee_bean/scenes/rib_samples/user_detail/interactor/user_detail_event_state.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class UserDetailPage extends BaseBlocStateFulWidget {
  final int userId;
  UserDetailPage({super.key, required this.userId});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends BaseBlocViewState<UserDetailPage, UserDetailInteractor, dynamic> {
  @override
  String getAppBar(BuildContext context) => "User Detail";

  @override
  void initState() {
    super.initState();
    // Trigger the data fetch event with the user ID passed from the widget.
    blocProvider.add(UserDetailFetchEvent(widget.userId));
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<UserDetailInteractor, BaseBlocState>(
      builder: (context, state) {
        if (state is UserDetailInProgress) {
          return const Center(child: LoadingView(width: 100, height: 100));
        }
        if (state is UserDetailGetDataError) {
          return Center(child: Text('Failed to load user details: ${state.error.message}'));
        }
        if (state is UserDetailGetDataSuccess) {
          return _buildUserDetail(context, state.user);
        }
        return const SizedBox.shrink(); // Return an empty widget for the initial state.
      },
    );
  }

  Widget _buildUserDetail(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(user.avatar),
            ),
            const SizedBox(height: 20),
            Text(user.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(user.email, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Chip(label: Text(user.role), backgroundColor: Colors.blue.shade100),
          ],
        ),
      ),
    );
  }
}