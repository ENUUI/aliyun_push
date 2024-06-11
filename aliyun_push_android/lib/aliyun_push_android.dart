import 'package:aliyun_push_android/src/messages.g.dart';
import 'package:aliyun_push_platform_interface/aliyun_push_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AliyunPushAndroid extends AliyunPushInterface
    implements AliyunPushFlutterApi {
  AliyunPushAndroid({@visibleForTesting AliyunPushAndroidApi? api})
      : _hotsApi = api ?? AliyunPushAndroidApi();
  final AliyunPushAndroidApi _hotsApi;

  static void registerWith() {
    AliyunPushInterface.instance = AliyunPushAndroid();
  }

  @override
  Future<void> initPush({String? appKey, String? appSecret}) async {
    try {
      await _hotsApi.initPush();
      AliyunPushFlutterApi.setUp(this);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addAlias(String alias) {
    return _hotsApi.addAlias(alias);
  }

  @override
  Future<List> listAlias() {
    return _hotsApi.listAlias();
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

  /// 添加标签
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
  Future<void> bindPhoneNumber(String phone) {
    return _hotsApi.bindPhoneNumber(phone);
  }

  @override
  Future<void> unbindPhoneNumber() {
    return _hotsApi.unbindPhoneNumber();
  }

  @override
  Future<String> getDeviceId() {
    return _hotsApi.getDeviceId();
  }

  @override
  Future<void> clearNotifications() {
    return _hotsApi.clearNotifications();
  }

  @override
  Future<void> createAndroidChannel(
    String id,
    String name,
    int importance,
    String description, {
    String? groupId,
    bool? allowBubbles,
    bool? light,
    int? lightColor,
    bool? showBadge,
    String? soundPath,
    int? soundUsage,
    int? soundContentType,
    int? soundFlag,
    bool? vibration,
    List<int>? vibrationPatterns,
  }) {
    return _hotsApi.createChannel(id, name, importance, description,
        groupId: groupId,
        allowBubbles: allowBubbles,
        light: light,
        lightColor: lightColor,
        showBadge: showBadge,
        soundPath: soundPath,
        soundUsage: soundUsage,
        soundContentType: soundContentType,
        soundFlag: soundFlag,
        vibration: vibration,
        vibrationPatterns: vibrationPatterns);
  }

  @override
  Future<void> createAndroidChannelGroup(String id, String name, String desc) {
    return _hotsApi.createChannelGroup(id, name, desc);
  }

  @override
  Future<void> setNotificationInGroup(bool inGroup) {
    return _hotsApi.setNotificationInGroup(inGroup);
  }

  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) {
    return _hotsApi.isNotificationEnabled(id: id);
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    _hotsApi.setPluginLogEnabled(enabled);
  }

  /// ########################
  @override
  Future<String> getApnsDeviceToken() {
    throw PlatformException(code: '1004', message: 'iOS only');
  }

  @override
  Future<bool> isIOSChannelOpened() {
    throw PlatformException(code: '1004', message: 'iOS only');
  }

  @override
  Future<void> setIOSBadgeNum(int num) {
    throw PlatformException(code: '1004', message: 'iOS only');
  }

  @override
  Future<void> showIOSNoticeWhenForeground(bool enable) {
    throw PlatformException(code: '1004', message: 'iOS only');
  }

  @override
  Future<void> syncIOSBadgeNum(int num) {
    throw PlatformException(code: '1004', message: 'iOS only');
  }

  @override
  Future<void> turnOnIOSDebug() {
    throw PlatformException(code: '1004', message: 'iOS only');
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
    notificationOpened.add(map);
  }

  @override
  void onNotificationRemoved(Map<Object?, Object?> map) {
    notificationRemoved.add(map);
  }

  @override
  void onNotificationClickedWithNoAction(Map<Object?, Object?> map) {
    androidNotificationClickedWithNoAction.add(map);
  }

  @override
  void onNotificationReceivedInApp(Map<Object?, Object?> map) {
    androidNotificationReceivedInApp.add(map);
  }
}
