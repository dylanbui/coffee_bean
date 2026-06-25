import 'package:equatable/equatable.dart';

class ActivityDetailState extends Equatable {
  final bool isLoading;
  final String title;
  final String description;
  final double price;
  final List<String> images;
  final int totalSlots;
  final int bookedSlots;
  final String address;
  final String startTime;
  final String endTime;
  final List<String> registeredAvatars;

  const ActivityDetailState({
    this.isLoading = false,
    this.title = "",
    this.description = "",
    this.price = 0,
    this.images = const [],
    this.totalSlots = 100,
    this.bookedSlots = 0,
    this.address = "84a Nguyễn Cửu Vân, phường Gia Định, tp.HCM",
    this.startTime = "06:00'",
    this.endTime = "23:00'",
    this.registeredAvatars = const [
      "https://i.pravatar.cc/150?u=1",
      "https://i.pravatar.cc/150?u=2",
      "https://i.pravatar.cc/150?u=3",
    ],
  });

  ActivityDetailState copyWith({
    bool? isLoading,
    String? title,
    String? description,
    double? price,
    List<String>? images,
    int? totalSlots,
    int? bookedSlots,
    String? address,
    String? startTime,
    String? endTime,
    List<String>? registeredAvatars,
  }) {
    return ActivityDetailState(
      isLoading: isLoading ?? this.isLoading,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      totalSlots: totalSlots ?? this.totalSlots,
      bookedSlots: bookedSlots ?? this.bookedSlots,
      address: address ?? this.address,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      registeredAvatars: registeredAvatars ?? this.registeredAvatars,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        title,
        description,
        price,
        images,
        totalSlots,
        bookedSlots,
        address,
        startTime,
        endTime,
        registeredAvatars,
      ];
}
