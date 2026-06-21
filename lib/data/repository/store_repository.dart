import 'package:db_core/network/base_repository.dart';
import 'package:db_core/network/network_common.dart';
import 'package:db_core/network/network_utils.dart';
import 'package:coffee_bean/data/model/db_location.dart';
import 'package:coffee_bean/data/model/response/trade/store_model.dart';
import 'package:coffee_bean/data/network/network_response.dart';

class StoreRepository extends BaseRepository {
  StoreRepository({super.client});

  /// GET /app-api/trade/delivery/pick-up-store/list
  Future<ResultType<List<StoreModel>>> getPickUpStoreList({DbLocation? location}) async {
    final Map<String, dynamic> params = {};
    if (location != null) {
      params['latitude'] = location.latitude;
      params['longitude'] = location.longitude;
    }

    return await networkClient
        .request('/app-api/trade/delivery/pick-up-store/list', params: params)
        .mapResponseTo(StoreModel.fromJson)
        .toList();
  }

  /// GET /app-api/trade/delivery/pick-up-store/get
  Future<ResultType<StoreModel>> getPickUpStoreDetail(int id) async {
    return await networkClient
        .request('/app-api/trade/delivery/pick-up-store/get', params: {'id': id})
        .mapResponseTo(StoreModel.fromJson)
        .toObject();
  }

  /// Helper: Get default store (first one from list)
  Future<StoreModel?> getDefaultStore({DbLocation? location}) async {
    final result = (await getPickUpStoreList(location: location)).toResult();
    if (result case DbSuccess(data: final list)) {
      if (list.isNotEmpty) {
        return list.first;
      }
    }
    return null;
  }
}
