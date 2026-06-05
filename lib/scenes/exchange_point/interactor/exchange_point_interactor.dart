// **************************************************************************
// Personal/Company: TMLabs
// Project: coffee_bean
// Author: dylanbui
// Create Date: 2026-06-05
// Description: [Add a brief description of the file's purpose]
//
// Copyright (c) 2026. All rights reserved.
// **************************************************************************
import 'package:coffee_bean/scenes/exchange_point/exchange_point_builder.dart';
import 'package:coffee_bean/scenes/exchange_point/interactor/exchange_point_event_state.dart';
import 'package:db_core/db_core.dart';
import 'package:db_core/state_management/lib_bloc/cubit_interactor.dart';

// INTERACTOR
class ExchangePointInteractor extends CubitInteractor<ExchangePointRoutable, ExchangePointState> {
  ExchangePointInteractor(ExchangePointRoutable router) : super(ExchangePointInitial(), router: router);

  @override
  void onDidBecomeActive() {
    super.onDidBecomeActive();
    loadData();
  }

  void loadData() {
    emit(ExchangePointLoading());


    final items = [
      ExchangePointItem(
        title: 'Hàng ngày điểm danh',
        caption: 'Hoàn thành điểm danh hàng ngày để nhận điểm',
        buttonText: 'Điểm danh',
        action: 'checkin',
      ),
      ExchangePointItem(
        title: 'Phần thưởng tiêu dùng',
        caption: 'Đặt đơn hàng tiêu dùng để nhận điểm thưởng tương ứng',
        buttonText: 'Đặt đơn',
        action: 'order',
      ),
      ExchangePointItem(
        title: 'Tương tác cộng đồng',
        caption: 'Đăng bài/ bình luận trong cộng đồng để nhận điểm',
        buttonText: 'Đi ngay',
        action: 'community',
      ),
      ExchangePointItem(
        title: 'Đặt chỗ',
        caption: 'Đặt chỗ sàn để nhận điểm thưởng',
        buttonText: 'Đặt ngay',
        action: 'reservation',
      ),
      ExchangePointItem(
        title: 'Đăng ký hoạt động',
        caption: 'Tham gia hoạt động để nhận điểm thưởng',
        buttonText: 'Đi xem',
        action: 'activity',
      ),
      ExchangePointItem(
        title: 'Phần thưởng đánh giá đơn hàng',
        caption: 'Đánh giá đơn hàng sản phẩm/khóa học để nhận điểm',
        buttonText: 'Đánh giá',
        action: 'review',
      ),
      ExchangePointItem(
        title: 'Phần thưởng mời bạn',
        caption: 'Mời bạn bè đăng ký / hoàn thành đơn đầu tiên để nhận thưởng',
        buttonText: 'Đi mời',
        action: 'referral',
      ),
      ExchangePointItem(
        title: 'Điểm thêm cho đơn đầu',
        caption: 'Hoàn thành đơn đầu tiên nhận điểm thưởng thêm',
        buttonText: 'Đặt đơn',
        action: 'first_order',
      ),

      // ----------------------------------

      ExchangePointItem(
        title: 'Đăng ký hoạt động',
        caption: 'Tham gia hoạt động để nhận điểm thưởng',
        buttonText: 'Đi xem',
        action: 'activity',
      ),
      ExchangePointItem(
        title: 'Phần thưởng đánh giá đơn hàng',
        caption: 'Đánh giá đơn hàng sản phẩm/khóa học để nhận điểm',
        buttonText: 'Đánh giá',
        action: 'review',
      ),
      ExchangePointItem(
        title: 'Phần thưởng mời bạn',
        caption: 'Mời bạn bè đăng ký / hoàn thành đơn đầu tiên để nhận thưởng',
        buttonText: 'Đi mời',
        action: 'referral',
      ),
      ExchangePointItem(
        title: 'Điểm thêm cho đơn đầu',
        caption: 'Hoàn thành đơn đầu tiên nhận điểm thưởng thêm',
        buttonText: 'Đặt đơn',
        action: 'first_order',
      ),
      ExchangePointItem(
        title: 'Đăng ký hoạt động',
        caption: 'Tham gia hoạt động để nhận điểm thưởng',
        buttonText: 'Đi xem',
        action: 'activity',
      ),
      ExchangePointItem(
        title: 'Phần thưởng đánh giá đơn hàng',
        caption: 'Đánh giá đơn hàng sản phẩm/khóa học để nhận điểm',
        buttonText: 'Đánh giá',
        action: 'review',
      ),
      ExchangePointItem(
        title: 'Phần thưởng mời bạn',
        caption: 'Mời bạn bè đăng ký / hoàn thành đơn đầu tiên để nhận thưởng',
        buttonText: 'Đi mời',
        action: 'referral',
      ),
      ExchangePointItem(
        title: 'Điểm thêm cho đơn đầu',
        caption: 'Hoàn thành đơn đầu tiên nhận điểm thưởng thêm',
        buttonText: 'Đặt đơn',
        action: 'first_order',
      ),
    ];

    emit(ExchangePointSuccess(items));
  }

  void chooseExchangePointItem(ExchangePointItem item) {
    iLog("title: ${item.title} - action: ${item.action}");
  }
}
