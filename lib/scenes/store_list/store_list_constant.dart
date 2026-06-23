import 'package:db_core/services/event_bus.dart';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';

class StoreChangedEvent extends DbBaseEvent {
  final StoreModel? store;
  StoreChangedEvent(this.store);
}