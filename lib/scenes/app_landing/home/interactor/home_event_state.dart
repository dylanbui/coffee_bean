/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:44
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/core/state_management/lib_bloc/constants.dart';
import 'package:flutter/material.dart';

// --- Data Models ---

class TopImageData {
  final List<String> images;
  final String userName;
  TopImageData({this.images = const [], this.userName = ""});
}

class QuickActionItem {
  final IconData icon;
  final String label;
  QuickActionItem({required this.icon, required this.label});
}

class QuickActionsData {
  final List<QuickActionItem> items;
  QuickActionsData({this.items = const []});
}

class AnnouncementData {
  final String message;
  AnnouncementData({this.message = ""});
}

class PromoData {
  final String title;
  final String description;
  PromoData({this.title = "", this.description = ""});
}

class CourseItem {
  final String title;
  final String imageUrl;
  CourseItem({required this.title, required this.imageUrl});
}

class FeaturedCoursesData {
  final List<CourseItem> items;
  FeaturedCoursesData({this.items = const []});
}

// --- Events ---
abstract class HomeEvent extends BaseBlocEvent {}

// --- States ---
class HomeState extends BaseBlocState {
  final bool isInitialLoading;
  final TopImageData? topImageData;
  final QuickActionsData? quickActionsData;
  final AnnouncementData? announcementData;
  final PromoData? promoData;
  final FeaturedCoursesData? featuredCoursesData;

  HomeState({
    this.isInitialLoading = true,
    this.topImageData,
    this.quickActionsData,
    this.announcementData,
    this.promoData,
    this.featuredCoursesData,
  });

  HomeState copyWith({
    bool? isInitialLoading,
    TopImageData? topImageData,
    QuickActionsData? quickActionsData,
    AnnouncementData? announcementData,
    PromoData? promoData,
    FeaturedCoursesData? featuredCoursesData,
  }) {
    return HomeState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      topImageData: topImageData ?? this.topImageData,
      quickActionsData: quickActionsData ?? this.quickActionsData,
      announcementData: announcementData ?? this.announcementData,
      promoData: promoData ?? this.promoData,
      featuredCoursesData: featuredCoursesData ?? this.featuredCoursesData,
    );
  }
}

class HomeInitial extends HomeState {
  HomeInitial() : super(isInitialLoading: true);
}
