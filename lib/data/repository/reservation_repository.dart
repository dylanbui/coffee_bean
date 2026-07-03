import 'package:coffee_bean/data/model/response/hub/venue_info_detail.dart';
import 'package:coffee_bean/data/model/response/hub/venue_info.dart';
import 'package:coffee_bean/data/model/response/hub/venue_schedule.dart';
import 'package:coffee_bean/data/model/response/system/dictionary_data.dart';
import 'package:coffee_bean/data/network/network_response.dart';
import 'package:coffee_bean/data/network/page_result.dart';
import 'package:db_core/db_core.dart';

class ReservationRepository extends BaseRepository {
  ReservationRepository({super.client});

  DbCacheProvider get _cache => locator<DbCacheProvider>();

  /// Get venue type dictionary
  /// API: GET /app-api/system/dict-data/type?type=venue_type
  Future<DbResult<List<DictionaryData>>> getVenueTypes({bool forceRefresh = false}) async {
    const cacheKey = 'venue_types';
    
    // 1. Thử lấy từ Cache
    if (!forceRefresh) {
      final cached = await _cache.get<List>(cacheKey);
      if (cached != null) {
        return DbSuccess(cached.map((e) => DictionaryData.fromJson(e as Dictionary)).toList());
      }
    }

    // 2. Gọi API nếu không có cache hoặc forceRefresh
    final result = await networkClient
        .doGet(
          '/app-api/system/dict-data/type',
          queryParameters: {'type': 'hub_venue_type'},
        )
        .mapResponseTo(DictionaryData.fromJson)
        .toList();

    // 3. Lưu cache nếu thành công
    if (result case DbSuccess(data: final data)) {
      await _cache.set(
        cacheKey,
        data.map((e) => e.toJson()).toList(),
        ttl: const Duration(hours: 1),
        group: 'reservation',
      );
    }
    return result;
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
  Future<DbResult<VenueInfoDetail>> getVenueDetail(int id, {bool forceRefresh = false}) async {
    final cacheKey = 'venue_detail_$id';

    // 1. Thử lấy từ Cache
    if (!forceRefresh) {
      final cached = await _cache.get<Dictionary>(cacheKey);
      if (cached != null) {
        return DbSuccess(VenueInfoDetail.fromJson(cached));
      }
    }

    // 2. Gọi API
    final result = await networkClient
        .doGet(
          '/app-api/hub/venue-info/get',
          queryParameters: {'id': id},
        )
        .mapResponseTo(VenueInfoDetail.fromJson)
        .toObject();

    // 3. Lưu cache
    if (result case DbSuccess(data: final data)) {
      await _cache.set(
        cacheKey,
        data.toJson(),
        ttl: const Duration(hours: 1),
        group: 'reservation',
      );
    }
    return result;
  }

  /// Get 7-day week schedule
  /// API: GET /app-api/hub/venue-schedule/week
  Future<DbResult<List<VenueWeek>>> getVenueWeekSchedule(int venueId, int venueTypeId) async {
    return await networkClient
        .doGet(
          '/app-api/hub/venue-schedule/week',
          queryParameters: {
            'venueId': venueId,
            'venueTypeId': venueTypeId,
          },
        )
        .mapResponseTo(VenueWeek.fromJson)
        .toList();
  }

  /// Get available spaces with time slots for a venue
  /// API: GET /app-api/hub/venue-slot/available-spaces
  Future<DbResult<List<VenueSpaceSlot>>> getVenueAvailableSpaces(int venueId, int venueTypeId, String date) async {
    return await networkClient
        .doGet(
          '/app-api/hub/venue-slot/available-spaces',
          queryParameters: {
            'venueId': venueId,
            'venueTypeId': venueTypeId,
            'date': date,
          },
        )
        .mapResponseTo(VenueSpaceSlot.fromJson)
        .toList();
  }
}
