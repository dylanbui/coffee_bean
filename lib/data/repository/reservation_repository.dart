import 'package:coffee_bean/data/model/response/hub/venue_detail_response.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/hub/venue_schedule_response.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/db_core.dart';

class ReservationRepository extends BaseRepository {
  ReservationRepository({super.client});

  /// Get venue type dictionary
  /// API: GET /app-api/system/dict-data/type?type=venue_type
  Future<DbResult<List<DictionaryData>>> getVenueTypes() async {
    return await networkClient
        .doGet(
          '/app-api/system/dict-data/type',
          queryParameters: {'type': 'hub_venue_type'},
        )
        .mapResponseTo(DictionaryData.fromJson)
        .toList();
  }

  /// Get venue list (Paginated)
  /// API: GET /app-api/hub/venue-info/page
  Future<ResultPageType<VenueInfo>> getVenues({
    String? keyword,
    int? venueTypeId,
    int pageNo = 1,
    int pageSize = 10,
  }) async {
    final params = {
      'pageNo': pageNo,
      'pageSize': pageSize,
      if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      if (venueTypeId != null) 'venueTypeId': venueTypeId,
    };

    return await networkClient
        .doGet(
          '/app-api/hub/venue-info/page',
          queryParameters: params,
        )
        .mapResponseToPage(VenueInfo.fromJson)
        .toObject();
  }

  /// Get venue detail
  /// API: GET /app-api/hub/venue-info/get
  Future<DbResult<VenueDetailResponse>> getVenueDetail(int id) async {
    return await networkClient
        .doGet(
          '/app-api/hub/venue-info/get',
          queryParameters: {'id': id},
        )
        .mapResponseTo(VenueDetailResponse.fromJson)
        .toObject();
  }

  /// Get 7-day week schedule
  /// API: GET /app-api/hub/venue-schedule/week
  Future<DbResult<List<VenueWeekResponse>>> getVenueWeekSchedule(int venueId, int venueTypeId) async {
    return await networkClient
        .doGet(
          '/app-api/hub/venue-schedule/week',
          queryParameters: {
            'venueId': venueId,
            'venueTypeId': venueTypeId,
          },
        )
        .mapResponseTo(VenueWeekResponse.fromJson)
        .toList();
  }

  /// Get available spaces with time slots for a venue
  /// API: GET /app-api/hub/venue-slot/available-spaces
  Future<DbResult<List<VenueSpaceSlotResponse>>> getVenueAvailableSpaces(int venueId, int venueTypeId, String date) async {
    return await networkClient
        .doGet(
          '/app-api/hub/venue-slot/available-spaces',
          queryParameters: {
            'venueId': venueId,
            'venueTypeId': venueTypeId,
            'date': date,
          },
        )
        .mapResponseTo(VenueSpaceSlotResponse.fromJson)
        .toList();
  }
}
