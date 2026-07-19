import 'package:db_core/services/event_bus.dart';

enum MainTabType { home, shopping, community, profile }

class AppMainTabSelectedEvent extends DbBaseEvent {
  final MainTabType tabType;
  AppMainTabSelectedEvent(this.tabType);
}
