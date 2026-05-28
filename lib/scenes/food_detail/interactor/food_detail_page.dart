import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_event_state.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_interactor.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_content.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_footer.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_header.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_suggested_section.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class FoodDetailPage extends AppCubitStateFulWidget<FoodDetailInteractor, FoodDetailState> {
  FoodDetailPage({super.key, required super.interactor});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends AppCubitState<FoodDetailPage, FoodDetailInteractor, FoodDetailState> {
  Widget? _commentPlugin;

  @override
  String? getTitle() => null; // Hide AppBar

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<FoodDetailInteractor, FoodDetailState>(
      builder: (context, state) {
        return FadeSwitcher(
          duration: const Duration(milliseconds: 300),
          showFirst: state.isLoading,
          first: const Center(child: LoadingView(width: 150, height: 150)),
          second: _buildMainContent(state),
        );
      },
    );
  }

  Widget _buildMainContent(FoodDetailState state) {
    if (state.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Không tìm thấy thông tin món ăn", style: TMLabsTextStyle.h2),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => interactor.goBack(),
              child: const Text("Quay lại"),
            ),
          ],
        ),
      );
    }

    // Sử dụng instance bền vững từ interactor thay vì tạo mới mỗi lần build
    _commentPlugin ??= CommentListBuilder(
      productId: state.product!.serverId,
      type: "FOOD",
    ).buildPlugin(2, interactor.commentController);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FoodDetailHeader(interactor: interactor),
              FoodDetailContent(interactor: interactor),
              FoodDetailSuggestedSection(interactor: interactor),
              // Nhúng trực tiếp instance Plugin
              _commentPlugin!,
            ],
          ),
        ),
        FoodDetailFooter(interactor: interactor),
      ],
    );
  }
}
