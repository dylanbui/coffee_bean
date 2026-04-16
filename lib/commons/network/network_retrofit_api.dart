/*
 * Created with IntelliJ IDEA
 * Package: widget
 * User: admin
 * Email: duc@propzy.com
 * Date: 6/24/22 - 12:44 AM
 * To change this template use File | Settings | File Templates.
 */

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'network_response.dart';

part 'network_retrofit_api.g.dart';

// DUCBUI: co ve khong can su dung, gia tri no mang lai khong lon, dung dio la du
// Retrofit chi la 1 wrapper class cua dio

@RestApi()
abstract class NetworkRetrofitApi {

  factory NetworkRetrofitApi(Dio dio, {String baseUrl}) = _NetworkRetrofitApi;

  @GET("")
  Future<NetworkResponse> makeGetRequest();

  @POST("")
  Future<NetworkResponse> makePostRequest();

  // @Headers("Content-Type: application/json")
  // @GET
  // suspend fun makeGetRequest(@Url url: String?): Response<CloudResponse>
  //
  // @POST
  // suspend fun makePostRequest(@Url url: String?, @Body requestBody: RequestBody?): Response<CloudResponse>
  //
  // @PUT
  // suspend fun makePutRequest(@Url url: String?, @Body requestBody: RequestBody?): Response<CloudResponse>
  //
  // @DELETE
  // suspend fun makeDeleteRequest(@Url url: String?): Response<CloudResponse>



}