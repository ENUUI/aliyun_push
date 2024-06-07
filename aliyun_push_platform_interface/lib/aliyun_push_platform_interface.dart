library aliyun_push_platform_interface;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

const MethodChannel _channel =
    MethodChannel('plugins.github.enuui/aliyun_push');

abstract class AliyunPushInterface extends PlatformInterface {
  AliyunPushInterface() : super(token: _token);

  static final Object _token = Object();

  static AliyunPushInterface _instance = MethodChannelAliyunPushInterface();

  static AliyunPushInterface get instance => _instance;

  static set instance(AliyunPushInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  final StreamController<bool> channelOpened = StreamController.broadcast();
  final StreamController<Map> messageArrived = StreamController.broadcast();
  final StreamController<Map> notificationArrived =
      StreamController.broadcast();
  final StreamController<Map> notificationOpened = StreamController.broadcast();
  final StreamController<Map> notificationRemoved =
      StreamController.broadcast();

  /// 注册设备token.
  /// iOS: APNs token
  final StreamController<String> registeredDeviceToken =
      StreamController.broadcast();

  Future<void> initPush({String? appKey, String? appSecret});

  /// 获取deviceId
  Future<String> getDeviceId();

  /// 绑定账号
  Future<void> bindAccount(String account);

  ///解绑账号
  Future<void> unbindAccount();

  ///添加别名
  Future<void> addAlias(String alias);

  /// 移除别名
  /// 当alias为length = 0时，删除当前设备绑定所有别名
  Future<void> removeAlias(String alias);

  ///查询绑定别名
  Future<List> listAlias();

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<void> bindTag(List<String> tags, {int target = 1, String? alias});

  ///移除标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<void> unbindTag(List<String> tags, {int target = 1, String? alias});

  /// 查询标签列表
  ///
  /// @param target   目标类型，1: 本设备
  Future<List<String>> listTags({int target = 1});

  ///绑定手机号码
  Future<void> bindPhoneNumber(String phone);

  ///解绑手机号码
  Future<void> unbindPhoneNumber();

  ///设置通知分组展示，只针对android
  ///
  ///@param inGroup 是否分组折叠展示
  Future<void> setNotificationInGroup(bool inGroup);

  /// 清除所有通知
  Future<void> clearNotifications();

  void setPluginLogEnabled(bool enabled);

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
      List<int>? vibrationPatterns});

  /// 创建通知通道的分组
  ///
  /// Android only
  /// Other platforms will throw PlatformException
  Future<void> createAndroidChannelGroup(String id, String name, String desc);

  /// 检查通知状态
  ///
  /// @param id 通道的id
  ///
  /// Android only
  /// Other platforms will throw PlatformException
  Future<bool> isAndroidNotificationEnabled({String? id});

  /// 开启iOS的debug日志
  ///
  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> turnOnIOSDebug();

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> showIOSNoticeWhenForeground(bool enable);

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> setIOSBadgeNum(int num);

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<void> syncIOSBadgeNum(int num);

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<String> getApnsDeviceToken();

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<bool> isIOSChannelOpened();
}

class MethodChannelAliyunPushInterface extends AliyunPushInterface {
  @visibleForTesting
  MethodChannel get channel => _channel;

  @override
  Future<void> initPush({
    String? appKey,
    String? appSecret,
  }) async {
    await _channel.invokeMapMethod(
        "initPush", {"appKey": appKey, "appSecret": appSecret});
  }

  @override
  Future<String> getDeviceId() async {
    final r = await _channel.invokeMethod('getDeviceId');
    if (r == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    }
    return r;
  }

  ///设置log的级别
  Future<void> setAndroidLogLevel(int level) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('setLogLevel', {'level': level});
  }

  ///绑定账号
  @override
  Future<void> bindAccount(String account) async {
    await channel.invokeMethod('bindAccount', {'account': account});
  }

  ///解绑账号
  @override
  Future<void> unbindAccount() async {
    await channel.invokeMethod('unbindAccount');
  }

  ///添加别名
  @override
  Future<void> addAlias(String alias) async {
    await channel.invokeMethod('addAlias', {'alias': alias});
  }

  ///移除别名
  @override
  Future<void> removeAlias(String alias) async {
    await channel.invokeMethod('removeAlias', {'alias': alias});
  }

  ///查询绑定别名
  @override
  Future<List> listAlias() async {
    List listResult = await channel.invokeMethod('listAlias');
    return listResult;
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<void> bindTag(
    List<String> tags, {
    int target = 1,
    String? alias,
  }) async {
    await channel.invokeMethod(
      'bindTag',
      {'tags': tags, 'target': target, 'alias': alias},
    );
  }

  ///移除标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<void> unbindTag(List<String> tags,
      {int target = 1, String? alias}) async {
    await channel.invokeMethod(
        'unbindTag', {'tags': tags, 'target': target, 'alias': alias});
  }

  /// 查询标签列表
  ///
  /// @param target   目标类型，1: 本设备
  @override
  Future<List<String>> listTags({int target = 1}) async {
    final List l = await channel.invokeMethod('listTags', {'target': target});
    return l.where((e) => e != null).toList().cast();
  }

  ///绑定手机号码
  @override
  Future<void> bindPhoneNumber(String phone) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('bindPhoneNumber', {'phone': phone});
  }

  ///解绑手机号码
  @override
  Future<void> unbindPhoneNumber() async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('unbindPhoneNumber');
  }

  ///设置通知分组展示，只针对android
  ///
  ///@param inGroup 是否分组折叠展示
  @override
  Future<void> setNotificationInGroup(bool inGroup) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('setNotificationInGroup', {'inGroup': inGroup});
  }

  ///清除所有通知
  @override
  Future<void> clearNotifications() async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('clearNotifications');
  }

  ///创建Android平台的NotificationChannel
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
      List<int>? vibrationPatterns}) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod('createChannel', {
      'id': id,
      'name': name,
      'importance': importance,
      'desc': description,
      'groupId': groupId,
      'allowBubbles': allowBubbles,
      'light': light,
      'lightColor': lightColor,
      'showBadge': showBadge,
      'soundPath': soundPath,
      'soundUsage': soundUsage,
      'soundContentType': soundContentType,
      'soundFlag': soundFlag,
      'vibration': vibration,
      'vibrationPatterns': vibrationPatterns
    });
  }

  ///创建通知通道的分组
  @override
  Future<void> createAndroidChannelGroup(
      String id, String name, String desc) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    await channel.invokeMethod(
        'createChannelGroup', {'id': id, 'name': name, 'desc': desc});
  }

  ///检查通知状态
  ///
  ///@param id 通道的id
  @override
  Future<bool> isAndroidNotificationEnabled({String? id}) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    bool enabled =
        await channel.invokeMethod('isNotificationEnabled', {'id': id});
    return enabled;
  }

  ///开启iOS的debug日志
  @override
  Future<void> turnOnIOSDebug() async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    await channel.invokeMethod('turnOnDebug');
  }

  @override
  Future<void> showIOSNoticeWhenForeground(bool enable) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    await channel.invokeMethod('showNoticeWhenForeground', {'enable': enable});
  }

  @override
  Future<void> setIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    await channel.invokeMethod('setBadgeNum', {'badgeNum': num});
  }

  @override
  Future<void> syncIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    await channel.invokeMethod('syncBadgeNum', {'badgeNum': num});
  }

  @override
  Future<String> getApnsDeviceToken() async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    var apnsDeviceToken = await channel.invokeMethod('getApnsDeviceToken');
    return apnsDeviceToken;
  }

  @override
  Future<bool> isIOSChannelOpened() async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    var opened = await channel.invokeMethod('isChannelOpened');
    return opened;
  }

  @override
  void setPluginLogEnabled(bool enabled) {
    channel.invokeMethod('setPluginLogEnabled', {'enabled': enabled});
  }
}
