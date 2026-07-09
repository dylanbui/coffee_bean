import 'package:coffee_bean/data/map_provider/native_map_widget.dart';
import 'package:coffee_bean/shared/base/app_cubit_stateful_widget.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/features/app_map/interactor/app_map_interactor.dart';
import 'package:coffee_bean/features/app_map/interactor/app_map_event_state.dart';

class AppMapPage extends AppCubitStateFulWidget<AppMapInteractor, AppMapState> {
  AppMapPage({super.key, required super.interactor});

  @override
  State<AppMapPage> createState() => _AppMapPageState();
}

class _AppMapPageState extends AppCubitState<AppMapPage, AppMapInteractor, AppMapState> {
  @override
  String? getTitle() => null; // Bắt buộc null để ẩn AppBar của AppCubitState

  @override
  Widget getBody(BuildContext context) {
    return Stack(
      children: [
        // 1. Bản đồ hiển thị full màn hình
        BlocBuilder<AppMapInteractor, AppMapState>(
          builder: (context, state) {
            return NativeMapWidget(
              initialLocation: state.marker.location,
              markers: {state.marker},
              onMapCreated: interactor.onMapCreated,
            );
          },
        ),

        // 2. Nút Back tùy chỉnh (Nền tròn trắng, icon mũi tên)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          child: GestureDetector(
            onTap: () => interactor.router?.pop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: TMLabsColor.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
