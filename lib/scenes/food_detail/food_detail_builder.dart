import 'package:db_core/architecture_ribs/note_builder.dart';
import 'package:coffee_bean/scenes/food_detail/food_detail_router.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_interactor.dart';
import 'package:coffee_bean/scenes/food_detail/interactor/food_detail_page.dart';
import 'package:coffee_bean_db/coffee_bean_db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodDetailBuilder extends DbNoteBuilder<FoodDetailRouter> {
  final int foodId;

  FoodDetailBuilder(this.foodId);

  @override
  FoodDetailRouter build() {
    final router = FoodDetailRouter();
    final interactor = FoodDetailInteractor(router, foodId);
    final page = FoodDetailPage(interactor: interactor);
    router.attach(interactor, page);

    return router;
  }
}
