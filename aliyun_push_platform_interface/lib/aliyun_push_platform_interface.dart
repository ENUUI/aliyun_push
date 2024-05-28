library aliyun_push_platform_interface;

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

  Future<Map<dynamic, dynamic>> initPush({String? appKey, String? appSecret});

  /// 获取deviceId
  Future<String> getDeviceId();

  /// 绑定账号
  Future<Map<dynamic, dynamic>> bindAccount(String account);

  ///解绑账号
  Future<Map<dynamic, dynamic>> unbindAccount();

  ///添加别名
  Future<Map<dynamic, dynamic>> addAlias(String alias);

  ///移除别名
  Future<Map<dynamic, dynamic>> removeAlias(String alias);

  ///查询绑定别名
  Future<Map<dynamic, dynamic>> listAlias();

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<Map<dynamic, dynamic>> bindTag(List<String> tags,
      {int target = 1, String? alias});

  ///移除标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  Future<Map<dynamic, dynamic>> unbindTag(List<String> tags,
      {int target = 1, String? alias});

  /// 查询标签列表
  ///
  /// @param target   目标类型，1: 本设备
  Future<Map<dynamic, dynamic>> listTags({int target = 1});

  ///绑定手机号码
  Future<Map<dynamic, dynamic>> bindPhoneNumber(String phone);

  ///解绑手机号码
  Future<Map<dynamic, dynamic>> unbindPhoneNumber();

  ///设置通知分组展示，只针对android
  ///
  ///@param inGroup 是否分组折叠展示
  Future<Map<dynamic, dynamic>> setNotificationInGroup(bool inGroup);

  /// 清除所有通知
  Future<Map<dynamic, dynamic>> clearNotifications();

  void setPluginLogEnabled(bool enabled);

  /// 创建Android平台的NotificationChannel
  ///
  /// Android only
  /// Other platforms will throw PlatformException
  Future<Map<dynamic, dynamic>> createAndroidChannel(
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
  Future<Map<dynamic, dynamic>> createAndroidChannelGroup(
      String id, String name, String desc);

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
  Future<Map<dynamic, dynamic>> turnOnIOSDebug();

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<Map<dynamic, dynamic>> showIOSNoticeWhenForeground(bool enable);

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<Map<dynamic, dynamic>> setIOSBadgeNum(int num);

  /// iOS only
  /// Other platforms will throw PlatformException
  Future<Map<dynamic, dynamic>> syncIOSBadgeNum(int num);

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
  Future<Map<dynamic, dynamic>> initPush({
    String? appKey,
    String? appSecret,
  }) async {
    final r = await _channel.invokeMapMethod(
        "initPush", {"appKey": appKey, "appSecret": appSecret});
    if (r == null) {
      throw PlatformException(
        code: 'null-error',
        message: 'Host platform returned null value for non-null return value.',
      );
    }
    return r;
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
  Future<Map<dynamic, dynamic>> setAndroidLogLevel(int level) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> result =
        await channel.invokeMethod('setLogLevel', {'level': level});
    return result;
  }

  ///绑定账号
  @override
  Future<Map<dynamic, dynamic>> bindAccount(String account) async {
    Map<dynamic, dynamic> bindResult =
        await channel.invokeMethod('bindAccount', {'account': account});
    return bindResult;
  }

  ///解绑账号
  @override
  Future<Map<dynamic, dynamic>> unbindAccount() async {
    Map<dynamic, dynamic> unbindResult =
        await channel.invokeMethod('unbindAccount');
    return unbindResult;
  }

  ///添加别名
  @override
  Future<Map<dynamic, dynamic>> addAlias(String alias) async {
    Map<dynamic, dynamic> addResult =
        await channel.invokeMethod('addAlias', {'alias': alias});
    return addResult;
  }

  ///移除别名
  @override
  Future<Map<dynamic, dynamic>> removeAlias(String alias) async {
    Map<dynamic, dynamic> removeResult =
        await channel.invokeMethod('removeAlias', {'alias': alias});
    return removeResult;
  }

  ///查询绑定别名
  @override
  Future<Map<dynamic, dynamic>> listAlias() async {
    Map<dynamic, dynamic> listResult = await channel.invokeMethod('listAlias');
    return listResult;
  }

  ///添加标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<Map<dynamic, dynamic>> bindTag(List<String> tags,
      {int target = 1, String? alias}) async {
    Map<dynamic, dynamic> bindResult = await channel.invokeMethod(
        'bindTag', {'tags': tags, 'target': target, 'alias': alias});
    return bindResult;
  }

  ///移除标签
  ///
  /// @param tags     标签名
  /// @param target   目标类型，1: 本设备  2: 本设备绑定账号  3: 别名
  /// @param alias    别名（仅当target = 3时生效）
  @override
  Future<Map<dynamic, dynamic>> unbindTag(List<String> tags,
      {int target = 1, String? alias}) async {
    Map<dynamic, dynamic> unbindResult = await channel.invokeMethod(
        'unbindTag', {'tags': tags, 'target': target, 'alias': alias});
    return unbindResult;
  }

  /// 查询标签列表
  ///
  /// @param target   目标类型，1: 本设备
  @override
  Future<Map<dynamic, dynamic>> listTags({int target = 1}) async {
    Map<dynamic, dynamic> listResult =
        await channel.invokeMethod('listTags', {'target': target});
    return listResult;
  }

  ///绑定手机号码
  @override
  Future<Map<dynamic, dynamic>> bindPhoneNumber(String phone) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> bindResult =
        await channel.invokeMethod('bindPhoneNumber', {'phone': phone});
    return bindResult;
  }

  ///解绑手机号码
  @override
  Future<Map<dynamic, dynamic>> unbindPhoneNumber() async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> unbindResult =
        await channel.invokeMethod('unbindPhoneNumber');
    return unbindResult;
  }

  ///设置通知分组展示，只针对android
  ///
  ///@param inGroup 是否分组折叠展示
  @override
  Future<Map<dynamic, dynamic>> setNotificationInGroup(bool inGroup) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> result = await channel
        .invokeMethod('setNotificationInGroup', {'inGroup': inGroup});
    return result;
  }

  ///清除所有通知
  @override
  Future<Map<dynamic, dynamic>> clearNotifications() async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> result =
        await channel.invokeMethod('clearNotifications');
    return result;
  }

  ///创建Android平台的NotificationChannel
  @override
  Future<Map<dynamic, dynamic>> createAndroidChannel(
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
    Map<dynamic, dynamic> createResult =
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
    return createResult;
  }

  ///创建通知通道的分组
  @override
  Future<Map<dynamic, dynamic>> createAndroidChannelGroup(
      String id, String name, String desc) async {
    if (!Platform.isAndroid) {
      throw PlatformException(
        code: "",
        message: 'Only support Android',
      );
    }
    Map<dynamic, dynamic> createResult = await channel.invokeMethod(
        'createChannelGroup', {'id': id, 'name': name, 'desc': desc});
    return createResult;
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
  Future<Map<dynamic, dynamic>> turnOnIOSDebug() async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    Map<dynamic, dynamic> result = await channel.invokeMethod('turnOnDebug');
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> showIOSNoticeWhenForeground(bool enable) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    Map<dynamic, dynamic> result = await channel
        .invokeMethod('showNoticeWhenForeground', {'enable': enable});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> setIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    Map<dynamic, dynamic> result =
        await channel.invokeMethod('setBadgeNum', {'badgeNum': num});
    return result;
  }

  @override
  Future<Map<dynamic, dynamic>> syncIOSBadgeNum(int num) async {
    if (!Platform.isIOS) {
      throw PlatformException(
        code: '',
        message: 'Only support iOS',
      );
    }
    Map<dynamic, dynamic> result =
        await channel.invokeMethod('syncBadgeNum', {'badgeNum': num});
    return result;
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
