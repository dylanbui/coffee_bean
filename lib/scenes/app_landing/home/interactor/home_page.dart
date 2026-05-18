import 'package:coffee_bean/core/state_management/lib_bloc/cubit_statefull_widget.dart';
import 'package:coffee_bean/shared/ui/app_assets.dart';
import 'package:coffee_bean/shared/ui/app_strings.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/widget/cached_image_widget.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:coffee_bean/shared/widget/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/top_image_panel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

//ignore: must_be_immutable
class HomePage extends CubitStateFulWidget<HomeInteractor, HomeState> {
  HomePage({super.key, required super.interactor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends CubitState<HomePage, HomeInteractor, HomeState> {
  @override
  dynamic getAppBar(BuildContext context) => null;

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    return BlocProvider.value(
      value: interactor,
      child: BlocBuilder<HomeInteractor, HomeState>(
        buildWhen: (previous, current) => previous.isInitialLoading != current.isInitialLoading,
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const Scaffold(body: Center(child: LoadingView(width: 150, height: 150)));
          }

          return Scaffold(backgroundColor: Colors.white, body: getBody(context));
        },
      ),
    );
  }

  @override
  Widget getBody(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopImagePanel(),
              _QuickActionsRow(),
              _AnnouncementBar(data: state.announcementData),
              _PromoBanner(data: state.promoData),
              _FeaturedCourses(data: state.featuredCoursesData),
              _CourseSellers(data: state.courseSellersData),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}

// --- Phần 2: Hàng nút chức năng ---
//ignore: must_be_immutable
class _QuickActionsRow extends StatelessWidget {
  late HomeInteractor _interactor;
  _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    // Access interactor from context
    _interactor = context.read<HomeInteractor>();

    final List<Map<String, dynamic>> items = [
      {'icon': AppAssets.icons.icDatCho, 'label': AppStrings.booking, 'onTap': () => _interactor.quickActions(0)},
      {'icon': AppAssets.icons.icDoiDiem, 'label': AppStrings.redeemPoints, 'onTap': () => _interactor.quickActions(1)},
      {'icon': AppAssets.icons.icKhoaHoc, 'label': AppStrings.allCourses, 'onTap': () => _interactor.quickActions(2)},
      {
        'icon': AppAssets.icons.icTrungTam,
        'label': AppStrings.healthCenter,
        'onTap': () => _interactor.quickActions(3),
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.map((item) {
          return InkWell(
            onTap: item['onTap'],
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Colors.transparent, shape: BoxShape.circle),
                    child: AppIcon(item['icon'], size: 60),
                  ),
                  Text(item['label'], style: const TextStyle(fontSize: 9)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// --- Phần 3: Announcement Bar ---
class _AnnouncementBar extends StatelessWidget {
  final AnnouncementData? data;
  const _AnnouncementBar({this.data});

  @override
  Widget build(BuildContext context) {
    final message = data?.message ?? "";
    if (message.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      height: 44,
      decoration: BoxDecoration(color: const Color(0xFF0D1B3E), borderRadius: BorderRadius.circular(22)),
      child: Row(
        children: [
          const Icon(Icons.volume_up, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Marquee(
              text: message,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              blankSpace: 20.0,
              velocity: 30.0,
              pauseAfterRound: const Duration(seconds: 1),
              accelerationDuration: const Duration(seconds: 1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
        ],
      ),
    );
  }
}

// --- Phần 4: Banner quảng cáo ---
class _PromoBanner extends StatelessWidget {
  final PromoData? data;
  const _PromoBanner({this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data!.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(data!.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B3E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(AppStrings.seeMore, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// --- Phần 5: Khóa học nổi bật (Scroll ngang) ---
class _FeaturedCourses extends StatelessWidget {
  final FeaturedCoursesData? data;
  const _FeaturedCourses({this.data});

  @override
  Widget build(BuildContext context) {
    final items = data?.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppStrings.featuredCourses,
                style: TMLabsStyle.semibold.copyWith(fontSize: 24, color: TMLabsColor.primary),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.seeMore,
                      style: TMLabsStyle.semibold.copyWith(fontSize: 14, color: TMLabsColor.primary),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward, size: 18, color: TMLabsColor.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedImageWidget(imageUrl: item.imageUrl, fit: BoxFit.cover),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 240 * 0.4,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [TMLabsColor.primary.withOpacity(0), TMLabsColor.primary],
                            ),
                          ),
                          padding: const EdgeInsets.all(12),
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            item.title,
                            style: TMLabsStyle.semibold.copyWith(color: Colors.white, fontSize: 16),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// --- Phần 6: Người bán khóa học (Scroll ngang) ---
class _CourseSellers extends StatelessWidget {
  final CourseSellersData? data;
  const _CourseSellers({this.data});

  @override
  Widget build(BuildContext context) {
    final items = data?.items ?? [];
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            AppStrings.courseSellers,
            style: TMLabsStyle.semibold.copyWith(fontSize: 24, color: TMLabsColor.primary),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 25),
            itemBuilder: (context, index) {
              final item = items[index];
              return SizedBox(
                width: 70,
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(color: TMLabsColor.primary, shape: BoxShape.circle),
                      child: ClipOval(
                        child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                            ? CachedImageWidget(imageUrl: item.imageUrl!, fit: BoxFit.cover)
                            : const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      style: TMLabsStyle.regular.copyWith(fontSize: 12, color: TMLabsColor.primary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
