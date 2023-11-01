import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class Eraser {
  static const MethodChannel _channel = MethodChannel('eraser');

  /// Clears all push notifications that have been received by your Flutter app.
  ///
  /// On Android this causes the small icon(s) to be removed from the status bar,
  /// and the notifications to be removed from the notification drawer.
  /// On iOS, this causes the notification(s) to be removed from the notification center.
  /// This does not affect the notifications received by other apps running on the device.
  static Future<void> clearAllAppNotifications() async {
    try {
      await _channel.invokeMethod('clearAllAppNotifications');
    } on PlatformException catch (e) {
      log(
        'Failed to clear all app notifications for following reason: ${e.message}',
        name: 'Eraser',
      );
    }
  }

  /// Clears all push notifications that have been received by your Flutter app that have the specified [tag].
  ///
  /// The tag is specified in the payload of the notification.
  /// Android notification payloads have a 'tag' property where this should be specified.
  /// While on iOS, the tag should be placed in the apns-collapse-id header.
  static Future<void> clearAppNotificationsByTag(String tag) async {
    try {
      await _channel
          .invokeMethod('clearAppNotificationsByTag', <String, dynamic>{
        'tag': tag,
      });
    } on PlatformException catch (e) {
      log(
        'Failed to clear app notifications for tag ($tag) for following reason: ${e.message}',
        name: 'Eraser',
      );
    }
  }

  /// Clears all push notifications that have been received by your Flutter app
  /// with specific conditions. On iOS, all notifications that match the
  /// specified [dataKey] and [dataValue] will be cleared. On Android, all
  /// notifications that have the specified [channelId] will be cleared.
  static Future<void> clearSpecificAppNotifications({
    required String dataKey,
    required String dataValue,
    required String channelId,
  }) async {
    try {
      await _channel
          .invokeMethod('clearSpecificAppNotifications', <String, dynamic>{
        'dataKey': dataKey, // e.g: 'NotificationType'
        'dataValue': dataValue, // e.g: 'new_chat_message'
        'channelId': channelId, // e.g: '1001'
      });
    } on PlatformException catch (e) {
      log(
        'Failed to clear specific app notifications for following reason: ${e.message}',
        name: 'Eraser',
      );
    }
  }

  /// Sets the iOS applicationIconBadgeNumber to 0, thus removing the badge count from the app icon.
  /// Doing this also means that the notifications are removed from the iOS notifications center at the same time.
  ///
  /// This is iOS-specific, as Android clears the 'notification count' automatically when notifications are dismissed.
  static Future<void> resetBadgeCountAndRemoveNotificationsFromCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel
            .invokeMethod('resetBadgeCountAndRemoveNotificationsFromCenter');
      } on PlatformException catch (e) {
        log(
          'Failed to reset badge count for following reason: ${e.message}',
          name: 'Eraser',
        );
      }
    }
  }

  /// Sets the iOS applicationIconBadgeNumber to -1, which causes the badge count to be removed from the app icon.
  /// However, setting to -1 means that the notifications remain in the iOS notifications center.
  ///
  /// This is iOS-specific, as Android clears the 'notification count' automatically when notifications are dismissed.
  static Future<void> resetBadgeCountButKeepNotificationsInCenter() async {
    if (Platform.isIOS) {
      try {
        await _channel
            .invokeMethod('resetBadgeCountButKeepNotificationsInCenter');
      } on PlatformException catch (e) {
        log(
          'Failed to reset badge count for following reason: ${e.message}',
          name: 'Eraser',
        );
      }
    }
  }
}
