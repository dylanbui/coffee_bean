import 'package:coffee_bean/data/map_provider/app_map_contract.dart';
import 'package:db_core/state_management/lib_bloc/constants.dart';

class AppMapState extends BaseBlocState {
  final MapMarker marker;

  AppMapState({required this.marker});

  @override
  List<Object?> get props => [marker];
}
