
import 'dart:core';

import 'package:equatable/equatable.dart';

/// Base state class for all Blocs. Ensures states are equatable for proper UI rebuilds.
abstract class BaseBlocState extends Equatable {

  @override
  List<Object?> get props => [];

}

/// Định nghĩa các trạng thái vòng đời để quản lý chính xác
enum InteractorLifecycle { initialized, active, resigned }

/// Base event class for all Blocs.
abstract class BaseBlocEvent extends Equatable {

  @override
  List<Object?> get props => [];

}
