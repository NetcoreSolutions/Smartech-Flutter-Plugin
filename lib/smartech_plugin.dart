import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:smartech_flutter_plugin/channel_builder.dart';
import 'package:smartech_flutter_plugin/customt_typedef.dart';
import 'package:smartech_flutter_plugin/smt_notification_options.dart';

class SmartechPlugin {
  static const MethodChannel _channel = const MethodChannel('smartech_plugin');
  static late CustomHTMLCallback _customHTMLCallback;
  static late OnhandleDeeplinkAction _onhandleDeeplinkAction;

  static final SmartechPlugin _smartechPlugin = new SmartechPlugin._internal();

  factory SmartechPlugin() => _smartechPlugin;

  SmartechPlugin._internal() {
    _channel.setMethodCallHandler(_didRecieveTranscript);
  }

  Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<void> openUrl(String url) async {
    await _channel.invokeMethod('openUrl', url);
  }

  Future<String?> setDevicePushToken(String token) async {
    final String? message =
        await _channel.invokeMethod('setDevicePushToken', token);
    return message;
  }

  Future<String?> get fetchAlreadyGeneratedTokenFromFCM async {
    final String? message =
        await _channel.invokeMethod('fetchAlreadyGeneratedTokenFromFCM');
    return message;
  }

  Future<void> setDebugLevel(int level) async {
    await _channel.invokeMethod('setDebugLevel', level);
  }

  Future<void> trackAppInstall() async {
    await _channel.invokeMethod('trackAppInstall');
  }

  Future<void> trackAppUpdate() async {
    await _channel.invokeMethod('trackAppUpdate');
  }

  Future<void> trackAppInstallUpdateBySmartech() async {
    await _channel.invokeMethod('trackAppInstallUpdateBySmartech');
  }

  Future<void> onhandleDeeplinkActionBackground() async {
    await _channel.invokeMethod("onhandleDeeplinkActionBackground");
  }

  Future<void> setInAppCustomHTMLListener(
      CustomHTMLCallback customHTMLCallback) async {
    _customHTMLCallback = customHTMLCallback;

    await _channel.invokeMethod('setInAppCustomHTMLListener');
  }

  Future<void> handleDeeplinkAction(
      OnhandleDeeplinkAction onhandleDeeplinkAction) async {
    _onhandleDeeplinkAction = onhandleDeeplinkAction;
    await _channel.invokeMethod("onhandleDeeplinkAction");
  }

  Future<void> _didRecieveTranscript(MethodCall call) async {
    switch (call.method) {
      case "customHTMLCallback":
        final Map<String, dynamic>? arguments = call.arguments;
        _customHTMLCallback(arguments);
        break;
      case "onhandleDeeplinkAction":
        Map<dynamic, dynamic>? map;
        bool? isAfterTerminated = false;
        if (call.arguments["customPayload"] is String) {
          try {
            map = json.decode(call.arguments["customPayload"]);
          } catch (e) {}
        } else {
          isAfterTerminated = call.arguments["isAfterTerminated"] as bool?;
          map = call.arguments["customPayload"] as Map<dynamic, dynamic>?;
        }
        _onhandleDeeplinkAction(
            call.arguments["deeplinkURL"] as dynamic, map, isAfterTerminated);
        break;
    }
  }

  Future<void> handlePushNotification(String notificationData) async {
    await _channel.invokeMethod("handlePushNotification", notificationData);
  }

  Future<void> createNotificationChannel(
      SMTNotifcationChannelBuilder builder) async {
    await _channel.invokeMethod("createNotificationChannel", builder.toJson());
  }

  Future<void> createNotificationChannelGroup(
      String groupId, String groupName) async {
    await _channel.invokeMethod("createNotificationChannelGroup",
        {"group_id": groupId, "group_name": groupName});
  }

  Future<void> deleteNotificationChannel(String channelId) async {
    await _channel.invokeMethod("deleteNotificationChannel", channelId);
  }

  Future<void> deleteNotificationChannelGroup(String groupId) async {
    await _channel.invokeMethod("deleteNotificationChannelGroup", groupId);
  }

  Future<void> updateUserProfile(Map<String, dynamic> map) async {
    await _channel.invokeMethod("updateUserProfile", map);
  }

  Future<void> setUserIdentity(String userIdentity) async {
    await _channel.invokeMethod("setUserIdentity", userIdentity);
  }

  Future<void> login(String userIdentity) async {
    await _channel.invokeMethod("login", userIdentity);
  }

  Future<void> clearUserIdentity() async {
    await _channel.invokeMethod("clearUserIdentity");
  }

  Future<void> logoutAndClearUserIdentity(bool clearUserIdentity) async {
    await _channel.invokeMethod(
        "logoutAndClearUserIdentity", clearUserIdentity);
  }

  Future<void> trackEvent(
      String eventName, Map<String, dynamic> eventData) async {
    await _channel.invokeMethod(
        "trackEvent", {"event_name": eventName, "event_data": eventData});
  }

  Future<void> setNotificationOptions(SMTNotificationOptions options) async {
    await _channel.invokeMethod("setNotificationOptions", options.toJson());
  }

  Future<String?> getDeviceUniqueId() async {
    return await _channel.invokeMethod("getDeviceUniqueId");
  }

  Future<void> setUserLocation(double latitude, double longitude) async {
    var map = {"latitude": latitude, "longitude": longitude};
    await _channel.invokeMethod("setUserLocation", map);
  }

  Future<void> initPlugin() async {
    await _channel.invokeMethod("initPlugin");
  }

  Future<void> optTracking(bool isOpted) async {
    await _channel.invokeMethod("optTracking", isOpted);
  }

  Future<bool?> hasOptedTracking() async {
    return await _channel.invokeMethod("hasOptedTracking");
  }

  Future<void> optPushNotification(bool isOpted) async {
    return await _channel.invokeMethod("optPushNotification", isOpted);
  }

  Future<bool?> hasOptedPushNotification() async {
    return await _channel.invokeMethod("hasOptedPushNotification");
  }

  Future<void> optInAppMessage(bool isOpted) async {
    await _channel.invokeMethod("optInAppMessage", isOpted);
  }

  Future<bool?> hasOptedInAppMessage() async {
    return await _channel.invokeMethod("hasOptedInAppMessage");
  }

  Future<String?> getUserIdentity() async {
    return _channel.invokeMethod("getUserIdentity");
  }

  Future<int?> getInboxMessageCount(int messageTyep) async {
    return _channel.invokeMethod("getInboxMessageCount", messageTyep);
  }

  Future<String?> getDevicePushToken() async {
    return _channel.invokeMethod("getDevicePushToken");
  }

  Future<void> openNativeWebView() async {
    return _channel.invokeMethod("openNativeWebView");
  }
}
