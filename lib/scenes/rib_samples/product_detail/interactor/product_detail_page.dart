import 'package:db_core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:db_core/utils/logger.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/shared/widget/error_view.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//ignore: must_be_immutable
class ProductDetailPage extends CubitStateFulWidget<ProductDetailInteractor, ProductDetailState> {
  ProductDetailPage({super.key, required super.interactor});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends CubitState<ProductDetailPage, ProductDetailInteractor, ProductDetailState> {

  @override
  dynamic getAppBar(BuildContext context) => "Product Detail";

  @override
  Widget getBody(BuildContext context) {
    return BlocConsumer<ProductDetailInteractor, ProductDetailState>(
      listener: (context, state) {
        if (state is ProductDetailGetDataError) {
          eLog("Error: ${state.error.message}");
        }
      },
      builder: (context, state) {
        if (state is ProductDetailInitial || state is ProductDetailInProgress) {
          return const Center(child: LoadingView(width: 150, height: 150));
        }

        if (state is ProductDetailGetDataSuccess) {
          final product = state.item;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CachedImageWidget(
                    imageUrl: product.images?.firstOrNull,
                    width: double.infinity,
                    height: 300,
                    borderRadius: 12,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  product.title ?? '',
                  style: DefaultStyle.textLarge.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'ID: ${product.id}',
                  style: DefaultStyle.textSmall.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: DefaultStyle.textNormal.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  product.description ?? 'No description available.',
                  style: DefaultStyle.textNormal,
                ),
              ],
            ),
          );
        }

        if (state is ProductDetailGetDataError) {
          return ErrorView(message: state.error.message, onRetry: () => interactor.loadData());
        }

        return const SizedBox.shrink();
      },
    );
  }
}
