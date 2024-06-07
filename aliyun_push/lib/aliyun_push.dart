library aliyun_push;

import 'package:aliyun_push_platform_interface/aliyun_push_platform_interface.dart';
import 'package:flutter/foundation.dart';

class AliyunPush {
  @visibleForTesting
  static AliyunPushInterface get platform => AliyunPushInterface.instance;

  /// 推送通道打开回调
  /// iOS only
  set iOSChannelOpened(void Function(bool)? callback) {
    platform.iOSChannelOpened = callback;
  }

  /// 注册设备token.
  /// iOS: APNs token
  /// bool: 是否成功
  /// String: If success, the token; If failed, the error message.
  set iOSRegisteredDeviceToken(void Function(bool, String)? callback) {
    platform.iOSRegisteredDeviceToken = callback;
  }

  /// 收到消息
  Stream<Map<dynamic, dynamic>> get message => platform.messageArrived.stream;

  /// 收到通知
  Stream<Map<dynamic, dynamic>> get notification =>
      platform.notificationArrived.stream;

  /// 从通知栏打开通知的扩展处理
  Stream<Map<dynamic, dynamic>> get notificationOpened =>
      platform.notificationOpened.stream;

  /// 通知删除回调
  Stream<Map<dynamic, dynamic>> get notificationRemoved =>
      platform.notificationRemoved.stream;

  /// 无动作通知点击回调
  /// Android only
  Stream<Map<dynamic, dynamic>> androidNotificationClickedWithNoAction =
      platform.androidNotificationClickedWithNoAction.stream;

  /// 应用处于前台时通知到达回调
  /// Android only
  final Stream<Map<dynamic, dynamic>> androidNotificationReceivedInApp =
      platform.androidNotificationReceivedInApp.stream;

  /// 初始化推送
  /// iOS: 同时requestAuthorization， register APNs
  Future<void> initPush({String? appKey, String? appSecret}) {
    return platform.initPush(appKey: appKey, appSecret: appSecret);
  }

  /// 获取deviceId
  Future<String> getDeviceId() {
    return platform.getDeviceId();
  }

  /// 绑定账号
  Future<void> bindAccount(String account) {
    return platform.bindAccount(account);
  }

  /// 解绑账号
  Future<void> unbindAccount() {
    return platform.unbindAccount();
  }

  /// 添加别名
  Future<void> addAlias(String alias) {
    return platform.addAlias(alias);
  }

  /// 移除别名
  Future<void> removeAlias(String alias) {
    return platform.removeAlias(alias);
  }

  /// 获取别名列表
  Future<List<String>> listAlias() async {
    final l = await platform.listAlias();
    return l.where((e) => e != null).toList().cast();
  }

  /// 添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<void> bindTag(List<String> tags, {int target = 1, String? alias}) {
    return platform.bindTag(tags, target: target, alias: alias);
  }

  /// 移除标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<void> unbindTag(List<String> tags, {int target = 1, String? alias}) {
    return platform.unbindTag(tags, target: target, alias: alias);
  }

  /// 查询标签列表
  ///
  /// @param target   目标类型，1: 本设备
  Future<List<String>> listTags({int target = 1}) {
    return platform.listTags(target: target);
  }

  /// 绑定手机号
  Future<void> bindPhoneNumber(String phone) {
    return platform.bindPhoneNumber(phone);
  }

  /// 解绑手机号
  Future<void> unbindPhoneNumber() {
    return platform.unbindPhoneNumber();
  }

  /// 设置通知分组展示
  ///
  /// [inGroup] 是否分组折叠展示
  /// Android only
  Future<void> setNotificationInGroup(bool inGroup) {
    return platform.setNotificationInGroup(inGroup);
  }

  /// 清除所有通知
  ///
  /// Android only
  Future<void> clearNotifications() {
    return platform.clearNotifications();
  }

  /// 是否开启插件日志
  /// Android only
  void setPluginLogEnabled(bool enabled) {
    platform.setPluginLogEnabled(enabled);
  }

  /// 创建Android平台的NotificationChannel
  ///
  /// Android only
  /// Other platforms will throw PlatformException
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
    return platform.createAndroidChannel(
      id,
      name,
      importance,
      description,
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
      vibrationPatterns: vibrationPatterns,
    );
  }

  /// 创建通知通道的分组
  ///
  /// Android only
  /// Other platforms will throw PlatformException
  Future<void> createAndroidChannelGroup(String id, String name, String desc) {
    return platform.createAndroidChannelGroup(id, name, desc);
  }

  /// 检查通知状态
  ///
  /// @param id 通道的id
  ///
  /// Android only
  /// Other platforms will throw PlatformException
  Future<bool> isAndroidNotificationEnabled({String? id}) {
    return platform.isAndroidNotificationEnabled(id: id);
  }

  /// 开启iOS的debug日志
  ///
  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> turnOnIOSDebug() {
    return platform.turnOnIOSDebug();
  }

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> showIOSNoticeWhenForeground(bool enable) {
    return platform.showIOSNoticeWhenForeground(enable);
  }

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> setIOSBadgeNum(int num) {
    return platform.setIOSBadgeNum(num);
  }

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> syncIOSBadgeNum(int num) {
    return platform.syncIOSBadgeNum(num);
  }

  /// 获取APNs设备token
  /// iOS only
  Future<String> getApnsDeviceToken() {
    return platform.getApnsDeviceToken();
  }

  /// 是否开启iOS通道
  /// iOS only
  Future<bool> isIOSChannelOpened() {
    return platform.isIOSChannelOpened();
  }
}
