/*
 * Created with Android Studio
 * Package: coffee_bean
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 12/5/26 - 16:44
 * To change this template use File | Settings | File Templates.
 */

import 'package:db_core/state_management/lib_bloc/constants.dart';
import 'package:flutter/material.dart';

// --- Data Models ---

class TopImageData {
  final List<String> images;
  final String userName;
  TopImageData({this.images = const [], this.userName = ""});
}

class QuickActionItem {
  final String key;
  final dynamic icon;
  final String label;
  QuickActionItem({required this.key, required this.icon, required this.label});
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

class CourseVideoItem {
  final String title;
  final String imageUrl;
  final String videoUrl;
  final String authorName;
  final String? authorAvatar;

  CourseVideoItem({
    required this.title,
    required this.imageUrl,
    required this.videoUrl,
    required this.authorName,
    this.authorAvatar,
  });
}

class CourseVideosData {
  final List<CourseVideoItem> items;
  CourseVideosData({this.items = const []});
}

class FinancialCourseItem {
  final String title;
  final String imageUrl;
  final double price;

  FinancialCourseItem({
    required this.title,
    required this.imageUrl,
    required this.price,
  });
}

class FinancialCoursesData {
  final List<FinancialCourseItem> items;
  FinancialCoursesData({this.items = const []});
}

class SellerItem {
  final String name;
  final String? imageUrl;
  SellerItem({required this.name, this.imageUrl});
}

class CourseSellersData {
  final List<SellerItem> items;
  CourseSellersData({this.items = const []});
}

class PostItem {
  final String authorName;
  final String? authorAvatar;
  final String postDate;
  final String title;
  final String content;
  final List<String> images;
  final int shareCount;
  final int commentCount;
  final int likeCount;
  final bool isFollowing;
  final List<MarketData> marketData;

  PostItem({
    required this.authorName,
    this.authorAvatar,
    required this.postDate,
    required this.title,
    required this.content,
    this.images = const [],
    this.shareCount = 0,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isFollowing = false,
    this.marketData = const [],
  });
}

class MarketData {
  final String symbol;
  final String change;
  final bool isPositive;
  MarketData({required this.symbol, required this.change, required this.isPositive});
}

class PostsData {
  final List<PostItem> items;
  PostsData({this.items = const []});
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
  final CourseSellersData? courseSellersData;
  final CourseVideosData? courseVideosData;
  final FinancialCoursesData? financialCoursesData;
  final PostsData? postsData;

  HomeState({
    this.isInitialLoading = true,
    this.topImageData,
    this.quickActionsData,
    this.announcementData,
    this.promoData,
    this.featuredCoursesData,
    this.courseSellersData,
    this.courseVideosData,
    this.financialCoursesData,
    this.postsData,
  });

  HomeState copyWith({
    bool? isInitialLoading,
    TopImageData? topImageData,
    QuickActionsData? quickActionsData,
    AnnouncementData? announcementData,
    PromoData? promoData,
    FeaturedCoursesData? featuredCoursesData,
    CourseSellersData? courseSellersData,
    CourseVideosData? courseVideosData,
    FinancialCoursesData? financialCoursesData,
    PostsData? postsData,
  }) {
    return HomeState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      topImageData: topImageData ?? this.topImageData,
      quickActionsData: quickActionsData ?? this.quickActionsData,
      announcementData: announcementData ?? this.announcementData,
      promoData: promoData ?? this.promoData,
      featuredCoursesData: featuredCoursesData ?? this.featuredCoursesData,
      courseSellersData: courseSellersData ?? this.courseSellersData,
      courseVideosData: courseVideosData ?? this.courseVideosData,
      financialCoursesData: financialCoursesData ?? this.financialCoursesData,
      postsData: postsData ?? this.postsData,
    );
  }
}

class HomeInitial extends HomeState {
  HomeInitial() : super(isInitialLoading: true);
}
