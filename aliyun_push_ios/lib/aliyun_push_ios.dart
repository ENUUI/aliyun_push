import 'package:aliyun_push_platform_interface/aliyun_push_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/messages.g.dart';

class AliyunPushIos extends AliyunPushInterface
    implements AliyunPushFlutterApi {
  AliyunPushIos({@visibleForTesting AliyunPushIosApi? api})
      : _hotsApi = api ?? AliyunPushIosApi();
  final AliyunPushIosApi _hotsApi;

  static void registerWith() {
    AliyunPushInterface.instance = AliyunPushIos();
  }

  @override
  Future<void> initPush({String? appKey, String? appSecret}) async {
    try {
      await _hotsApi.initPush(appKey: appKey, appSecret: appSecret);
      AliyunPushFlutterApi.setUp(this);
    } catch (e) {
      rethrow;
    }
  }

  /// Alias
  @override
  Future<void> addAlias(String alias) {
    return _hotsApi.addAlias(alias);
  }

  @override
  Future<List<String>> listAlias() async {
    final l = await _hotsApi.listAlias();
    return l.where((e) => e != null).toList().cast();
  }

  @override
  Future<void> removeAlias(String alias) {
    return _hotsApi.removeAlias(alias);
  }

  @override
  Future<void> bindAccount(String account) {
    return _hotsApi.bindAccount(account);
  }

  @override
  Future<void> unbindAccount() {
    return _hotsApi.unbindAccount();
  }

  @override
  Future<void> bindPhoneNumber(String phone) {
    return _hotsApi.bindPhoneNumber(phone);
  }

  @override
  Future<void> unbindPhoneNumber() {
    return _hotsApi.unbindPhoneNumber();
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<void> bindTag(List<String> tags, {int target = 1, String? alias}) {
    return _hotsApi.bindTag(tags, target: target, alias: alias);
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<void> unbindTag(List<String> tags, {int target = 1, String? alias}) {
    return _hotsApi.unbindTag(tags, target: target, alias: alias);
  }

  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  @override
  Future<List<String>> listTags({int target = 1}) async {
    final l = await _hotsApi.listTags(target: target);
    return l.where((e) => e != null).toList().cast();
  }

  @override
  Future<String> getApnsDeviceToken() {
    return _hotsApi.getApnsDeviceToken();
  }

  @override
  Future<String> getDeviceId() {
    return _hotsApi.getDeviceId();
  }

  @override
  Future<bool> isIOSChannelOpened() {
    return _hotsApi.isIOSChannelOpened();
  }

  @override
  Future<void> setIOSBadgeNum(int num) {
    return _hotsApi.setIOSBadgeNum(num);
  }

  @override
  Future<void> showIOSNoticeWhenForeground(bool enable) {
    return _hotsApi.showIOSNoticeWhenForeground(enable);
  }

  @override
  Future<void> syncIOSBadgeNum(int num) {
    return _hotsApi.syncIOSBadgeNum(num);
  }

  @override
  Future<void> turnOnIOSDebug() {
    return _hotsApi.turnOnIOSDebug();
  }

  @override
  Future<void> createAndroidChannel(
      String id, String name, int importance, String description,
      {String? groupId,
      bool? allowBubbles,
      bool? light,
      int? lightColor,
      bool? showBadge,
      String? soundPath,
      int? soundUsage,
      int? soundContentType,
      int? soundFlag,
      bool? vibration,
      List<int>? vibrationPatterns}) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<void> createAndroidChannelGroup(String id, String name, String desc) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<void> setNotificationInGroup(bool inGroup) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<void> clearNotifications() {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  /// ######################################################
  /// ######################################################
  /// implements AliyunPushFlutterApi

  /// 推送通道打开回调
  @override
  void onChannelOpened() {
    channelOpened.add(true);
  }

  @override
  void onMessage(Map<Object?, Object?> map) {
    messageArrived.add(map);
  }

  @override
  void onNotification(Map<Object?, Object?> map) {
    notificationArrived.add(map);
  }

  @override
  void onNotificationOpened(Map<Object?, Object?> map) {
    notificationArrived.add(map);
  }

  @override
  void onNotificationRemoved(Map<Object?, Object?> map) {
    notificationRemoved.add(map);
  }

  @override
  void onRegisterDeviceTokenSuccess(String token) {
    registeredDeviceToken.add(token);
  }
}
