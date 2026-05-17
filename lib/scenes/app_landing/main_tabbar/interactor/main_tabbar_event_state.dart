import 'package:equatable/equatable.dart';

abstract class MainTabbarState extends Equatable {
  final int selectedIndex;
  
  const MainTabbarState({this.selectedIndex = 0});

  @override
  List<Object?> get props => [selectedIndex];

  MainTabbarState copyWith({int? selectedIndex});
}

class MainTabbarInitial extends MainTabbarState {
  const MainTabbarInitial({super.selectedIndex = 0});

  @override
  MainTabbarState copyWith({int? selectedIndex}) {
    return MainTabbarInitial(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class MainTabbarUpdate extends MainTabbarState {
  const MainTabbarUpdate({required super.selectedIndex});

  @override
  MainTabbarState copyWith({int? selectedIndex}) {
    return MainTabbarUpdate(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
