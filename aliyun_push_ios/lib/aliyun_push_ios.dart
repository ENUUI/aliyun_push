import 'package:aliyun_push_platform_interface/aliyun_push_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'src/messages.g.dart';

class AliyunPushIos extends AliyunPushInterface {
  AliyunPushIos({@visibleForTesting AliyunPushIosApi? api})
      : _hotsApi = api ?? AliyunPushIosApi();
  final AliyunPushIosApi _hotsApi;

  static void registerWith() {
    AliyunPushInterface.instance = AliyunPushIos();
  }

  @override
  Future<Map> initPush({String? appKey, String? appSecret}) {
    return _hotsApi.initPush(appKey: appKey, appSecret: appSecret);
  }

  /// Alias
  ///
  @override
  Future<Map> addAlias(String alias) {
    return _hotsApi.addAlias(alias);
  }

  @override
  Future<Map> listAlias() {
    return _hotsApi.listAlias();
  }

  @override
  Future<Map> removeAlias(String alias) {
    return _hotsApi.removeAlias(alias);
  }

  @override
  Future<Map> bindAccount(String account) {
    return _hotsApi.bindAccount(account);
  }

  @override
  Future<Map> unbindAccount() {
    return _hotsApi.unbindAccount();
  }

  @override
  Future<Map> bindPhoneNumber(String phone) {
    return _hotsApi.bindPhoneNumber(phone);
  }

  @override
  Future<Map> unbindPhoneNumber() {
    return _hotsApi.unbindPhoneNumber();
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<Map> bindTag(List<String> tags, {int target = 1, String? alias}) {
    return _hotsApi.bindTag(tags, target: target, alias: alias);
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<Map> unbindTag(List<String> tags, {int target = 1, String? alias}) {
    return _hotsApi.unbindTag(tags, target: target, alias: alias);
  }

  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  @override
  Future<Map> listTags({int target = 1}) {
    return _hotsApi.listTags(target: target);
  }

  @override
  Future<Map> clearNotifications() {
    return _hotsApi.clearNotifications();
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
  Future<Map> setIOSBadgeNum(int num) {
    return _hotsApi.setIOSBadgeNum(num);
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    _hotsApi.setPluginLogEnabled(enabled);
  }

  @override
  Future<Map> showIOSNoticeWhenForeground(bool enable) {
    return _hotsApi.showIOSNoticeWhenForeground(enable);
  }

  @override
  Future<Map> syncIOSBadgeNum(int num) {
    return _hotsApi.syncIOSBadgeNum(num);
  }

  @override
  Future<Map> turnOnIOSDebug() {
    return _hotsApi.turnOnIOSDebug();
  }

  @override
  Future<Map> createAndroidChannel(
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
  Future<Map> createAndroidChannelGroup(String id, String name, String desc) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) {
    throw PlatformException(code: '1004', message: 'Android only');
  }

  @override
  Future<Map> setNotificationInGroup(bool inGroup) {
    throw PlatformException(code: '1004', message: 'Android only');
  }
}
