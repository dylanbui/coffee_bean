import 'package:coffee_bean/commons/architecture_ribs/note_viewer.dart';
import 'package:coffee_bean/commons/custom_app_bar.dart';
import 'package:coffee_bean/commons/utils/logger.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_event_state.dart';
import 'package:coffee_bean/scenes/rib_samples/product_detail/interactor/product_detail_interactor.dart';
import 'package:coffee_bean/utils/app_style.dart';
import 'package:coffee_bean/widget/cached_image_widget.dart';
import 'package:coffee_bean/widget/error_view.dart';
import 'package:coffee_bean/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailPage extends StatefulWidget with ViewControllable {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductDetailInteractor pageInteractor;

  String getTitle() {
    return "Product Detail";
  }

  @override
  Widget build(BuildContext context) {
    pageInteractor = BlocProvider.of<ProductDetailInteractor>(context);
    return Scaffold(
      appBar: CustomAppBar(getTitle()),
      body: BlocConsumer<ProductDetailInteractor, ProductDetailState>(
        listener: (context, state) {
          if (state is ProductDetailGetDataError) {
            eLog("Error: ${state.error.message}");
          }
        },
        builder: (context, state) {
          return getBody(context, state);
        },
      ),
    );
  }

  Widget getBody(BuildContext context, ProductDetailState state) {
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
      return ErrorView(message: state.error.message, onRetry: () => pageInteractor.loadData());
    }

    return const SizedBox.shrink();
  }
}
