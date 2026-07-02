import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:db_core/db_core.dart';

class ReservationRepository extends BaseRepository {
  ReservationRepository({super.client});

  /// Get venue type dictionary
  /// API: GET /app-api/system/dict-data/type?type=venue_type
  Future<DbResult<List<DictionaryData>>> getVenueTypes() async {
    return await networkClient
        .doGet(
          '/app-api/system/dict-data/type',
          queryParameters: {'type': 'venue_type'},
        )
        .mapResponseTo(DictionaryData.fromJson)
        .toList();
  }

  /// Get venue list
  /// API: GET /app-api/hub/venue-info/list
  Future<DbResult<List<VenueInfo>>> getVenues({String? keyword, int? venueTypeId}) async {
    final params = {
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (venueTypeId != null) 'venueTypeId': venueTypeId,
    };

    return await networkClient
        .doGet(
          '/app-api/hub/venue-info/list',
          queryParameters: params,
        )
        .mapResponseTo(VenueInfo.fromJson)
        .toList();
  }
}
