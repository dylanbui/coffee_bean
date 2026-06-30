import 'dart:async';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_event_state.dart';
import 'package:coffee_bean/scenes/app_landing/home/interactor/home_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coffee_bean/shared/ui/app_style.dart';
import 'package:coffee_bean/shared/ui/app_colors.dart';

class AnnouncementBarPanel extends StatefulWidget {
  final HomeInteractor interactor;
  const AnnouncementBarPanel({super.key, required this.interactor});

  @override
  State<AnnouncementBarPanel> createState() => _AnnouncementBarPanelState();
}

class _AnnouncementBarPanelState extends State<AnnouncementBarPanel> {
  PageController? _pageController;
  Timer? _timer;
  int _currentPage = 0;
  int _actualCount = 0;
  static const int _loopFactor = 1000;

  void _startTimer(int count) {
    if (_timer != null && _actualCount == count) return;
    
    _timer?.cancel();
    _actualCount = count;
    if (count <= 1) return;

    _currentPage = count * (_loopFactor ~/ 2);
    
    if (_pageController != null && _pageController!.hasClients) {
      _pageController!.jumpToPage(_currentPage);
    }

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _currentPage++;
      if (_pageController != null && _pageController!.hasClients) {
        _pageController!.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeInteractor, HomeState>(
      buildWhen: (previous, current) => previous.announcements != current.announcements,
      builder: (context, state) {
        final announcements = state.announcements;
        if (announcements.isEmpty) return const SizedBox.shrink();

        if (_pageController == null) {
          _currentPage = announcements.length * (_loopFactor ~/ 2);
          _pageController = PageController(initialPage: _currentPage);
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _startTimer(announcements.length);
        });

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  if (announcements.isNotEmpty) {
                    final index = _currentPage % announcements.length;
                    widget.interactor.onAnnouncementTap(announcements[index]);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: 36,
                  decoration: BoxDecoration(
                    color: TMLabsColor.deepNavy.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.volume_up, color: TMLabsColor.white, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: announcements.length * _loopFactor,
                          onPageChanged: (index) {
                            _currentPage = index;
                          },
                          itemBuilder: (context, index) {
                            final itemIndex = index % announcements.length;
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                announcements[itemIndex].title,
                                style: TMLabsTextStyle.caption.copyWith(color: TMLabsColor.white),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          },
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: TMLabsColor.white, size: 12),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
