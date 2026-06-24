import 'package:coffee_bean/scenes/comment_list/comment_list_builder.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_content.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_footer.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_header.dart';
import 'package:coffee_bean/scenes/shopping_features/product_detail/interactor/widget/product_detail_suggested_section.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:db_core/utils/fade_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProductDetailPage extends AppCubitStateFulWidget<ProductDetailInteractor, ProductDetailState> {
  ProductDetailPage({super.key, required super.interactor});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends AppCubitState<ProductDetailPage, ProductDetailInteractor, ProductDetailState> {
  Widget? _commentPlugin;

  @override
  String? getTitle() => null;

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<ProductDetailInteractor, ProductDetailState>(
      builder: (context, state) {
        return FadeSwitcher.binary(
          duration: const Duration(milliseconds: 300),
          showFirst: state.isLoading,
          first: const Center(child: LoadingView(width: 150, height: 150)),
          second: _buildMainContent(state),
        );
      },
    );
  }

  Widget _buildMainContent(ProductDetailState state) {
    if (state.product == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Không tìm thấy thông tin sản phẩm", style: TMLabsTextStyle.h2),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => interactor.goBack(),
              child: const Text("Quay lại"),
            ),
          ],
        ),
      );
    }

    _commentPlugin ??= CommentListBuilder(
      productId: state.product!.id,
      type: 0,
    ).buildPlugin(2, interactor.commentController);

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 140),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductDetailHeader(interactor: interactor),
              ProductDetailContent(interactor: interactor),
              ProductDetailSuggestedSection(interactor: interactor),
              _commentPlugin!,
            ],
          ),
        ),
        ProductDetailFooter(interactor: interactor),
      ],
    );
  }
}
