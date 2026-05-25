import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_event_state.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_interactor.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_comments_section.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_content.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_footer.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_header.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/widget/food_detail_suggested_section.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class FoodDetailPage extends CubitStateFulWidget<FoodDetailInteractor, FoodDetailState> {
  FoodDetailPage({super.key, required super.interactor}) {
    showAppBar = false;
  }

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends CubitState<FoodDetailPage, FoodDetailInteractor, FoodDetailState> {
  @override
  Widget getBody(BuildContext context) {
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
              const FoodDetailCommentsSection(),
            ],
          ),
        ),
        FoodDetailFooter(interactor: interactor),
      ],
    );
  }
}
