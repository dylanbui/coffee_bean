import 'package:coffee_bean/data/model/response/system/announcement.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

abstract class AnnouncementDetailEvent extends BaseBlocEvent {}

class AnnouncementDetailState extends BaseBlocState {
  final Announcement? announcement;
  final bool isLoading;

  AnnouncementDetailState({this.announcement, this.isLoading = false});

  AnnouncementDetailState copyWith({Announcement? announcement, bool? isLoading}) {
    return AnnouncementDetailState(
      announcement: announcement ?? this.announcement,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [announcement?.id, announcement?.title, isLoading];
}
