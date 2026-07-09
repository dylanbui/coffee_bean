/*
 * Created with Android Studio
 * Package: 
 * User: dylanbui
 * Email: buivantienduc@gmail.com
 * Date: 1/5/26 - 23:17
 * To change this template use File | Settings | File Templates.
 */

import 'package:coffee_bean/shared/widget/image_slider_widget.dart';
import 'package:coffee_bean/utils/flash_utils/flash_image_helper.dart';
import 'package:coffee_bean/shared/widget/media_gallery/app_media_gallery.dart';
import 'package:db_core/utils/flash_utils/flash_dialog_helper.dart';
import 'package:db_core/utils/flash_utils/flash_toast_helper.dart';

import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:coffee_bean/utils/flash_utils/flash_modal_helper.dart';

/// **************************************************************************
/// FLASH EXTENSION
/// Author: Gemini / Coffee Bean Project
/// Description: Provides syntactic sugar to easily show Modals, Dialogs, 
/// and Toasts from any BuildContext.
/// **************************************************************************

extension FlashExtension on BuildContext {

    // ===========================================================================
    // 1. QUICK TOASTS / SNACKBARS (Uses FlashToastHelper)
    // ===========================================================================

    /// Displays a success SnackBar at the top
    void showFlashSuccess(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)})
        => DbFlashToastHelper.success(this, message, title: title, position: position, duration: duration);

    /// Displays an error SnackBar at the top
    void showFlashError(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 3)}) 
        => DbFlashToastHelper.error(this, message, title: title, position: position, duration: duration);

    /// Displays an info SnackBar at the top
    void showFlashInfo(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)}) 
        => DbFlashToastHelper.info(this, message, title: title, position: position, duration: duration);

    /// Displays a warning SnackBar at the top
    void showFlashWarning(String message, {String? title, FlashPosition position = FlashPosition.top, Duration duration = const Duration(seconds: 2)})
        => DbFlashToastHelper.warning(this, message, title: title, position: position, duration: duration);

    // ===========================================================================
    // 2. QUICK DIALOGS (Uses FlashDialogHelper)
    // ===========================================================================

    /// Displays a confirmation dialog or a custom form
    /// Returns a result of type [T]
    /// 
    /// NOTE: [persistent] must be TRUE when showing from root context (e.g. within MaterialApp),
    /// otherwise it throws: 'overlay can't be the root overlay when persistent is false'.
    Future<T?> showFlashConfirm<T>({
        required String title,
        required String content,
        List<DbFlashDialogAction<T>>? actions,
        Widget? icon,
        Widget? body,
        bool persistent = true,
    }) {
        return DbFlashDialogHelper.show<T>(
            context: this,
            title: title,
            content: content,
            actions: actions,
            icon: icon,
            body: body,
            persistent: persistent,
        );
    }

    // ===========================================================================
    // 3. QUICK MODALS (Uses FlashModalHelper)
    // ===========================================================================

    /// Displays a Bottom or Top Modal (Custom Size)
    /// Returns a result of type [T]
    Future<T?> showFlashModal<T>({
        required String title,
        required FlashModalChildBuilder<T> childBuilder,
        List<Widget>? actions,
        FlashActionsBuilder<T>? actionsBuilder,
        FlashModalPosition position = FlashModalPosition.bottom,
        FlashFooterLayout footerLayout = FlashFooterLayout.row,
        double maxHeightThreshold = 0.7,
        bool isPersistent = true,
        bool useDeferredBuild = false,
    }) {
        return FlashModalHelper.showSmartModal<T>(
            context: this,
            title: title,
            childBuilder: childBuilder,
            actions: actions,
            actionsBuilder: actionsBuilder,
            position: position,
            footerLayout: footerLayout,
            maxHeightThreshold: maxHeightThreshold,
            isPersistent: isPersistent,
            useDeferredBuild: useDeferredBuild,
        );
    }

    /// Views product images in a gallery
    void showPhotoGallery({required List<String> imageUrls, int initialIndex = 0, String? heroPrefix}) {
        FlashImageHelper.showGallery(
            context: this,
            imageUrls: imageUrls,
            initialIndex: initialIndex,
            heroTagPrefix: heroPrefix,
        );
    }

    /// Views media (images & videos) in a gallery
    void showMediaGallery({required List<String> urls, int initialIndex = 0, String? heroPrefix}) {
        AppMediaGallery.show(
            this,
            urls: urls,
            initialIndex: initialIndex,
            heroTagPrefix: heroPrefix,
        );
    }

    /// Trả về một ImageSliderWidget đã được cấu hình sẵn để mở Media Gallery khi tap
    Widget imageSlider({
        required List<String> images,
        double height = 300,
        ImageSliderIndicatorType indicatorType = ImageSliderIndicatorType.fraction,
        double borderRadius = 0,
        String? heroPrefix,
    }) {
        return ImageSliderWidget(
            images: images,
            height: height,
            indicatorType: indicatorType,
            borderRadius: borderRadius,
            onImageTap: (index, allImages) =>
                showMediaGallery(urls: allImages, initialIndex: index, heroPrefix: heroPrefix),
        );
    }

}

/// **************************************************************************
/// USAGE EXAMPLES
/// **************************************************************************

/*
  // --- Toast / SnackBar Examples ---

  void _testToast(BuildContext context) {
    // 1. Show quick success notification at Top
    context.showFlashSuccess("Order updated successfully!");
    
    // 2. Show error notification with title
    context.showFlashError("Server is busy, please try again.", title: "Connection Error");
  }

  // --- Dialog Examples ---

  void _testConfirm(BuildContext context) {
    // 3. Show confirmation dialog and wait for result
    context.showFlashConfirm<bool>(
      title: "Confirmation",
      content: "Are you sure you want to delete this item?",
      actions: [
        DbFlashDialogAction(label: "Cancel", value: false, color: Colors.grey),
        DbFlashDialogAction(label: "Delete", value: true, color: Colors.red),
      ],
    ).then((isDelete) {
      if (isDelete == true) { 
        // Handle deletion logic
      }
    });
  }

  // --- Modal Examples ---

  void _testModal(BuildContext context) {
    // 4. Show a bottom selection modal
    context.showFlashModal<String>(
      title: "Select Coffee Bean Branch",
      position: FlashModalPosition.bottom,
      child: MyStoreListWidget(), // A ListView or any Widget
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, "Ho Chi Minh City"),
          child: Text("Select Default HCM"),
        ),
      ],
    ).then((city) {
      if (city != null) print("Selected: $city");
    });
  }

  // --- Photo Gallery Examples ---
  
  void _onViewFeedbackImages(BuildContext context, List<String> images, int clickedIndex) {
    // 5. Show image gallery with Hero animation support
    context.showPhotoGallery(
      imageUrls: images,
      initialIndex: clickedIndex,
      heroPrefix: "feedback_item", 
    );
  }

*/
