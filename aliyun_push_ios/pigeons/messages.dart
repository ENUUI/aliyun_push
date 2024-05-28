import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  swiftOut: 'ios/Classes/messages.g.swift',
  swiftOptions: SwiftOptions(),
))
@HostApi()
abstract class AliyunPushIosApi {
  @async
  @SwiftFunction('initPush(appKey:appSecret:)')
  Map initPush({String? appKey, String? appSecret});

  @async
  @SwiftFunction('addAlias(alias:)')
  Map addAlias(String alias);

  @async
  @SwiftFunction('listAlias()')
  Map listAlias();

  @async
  @SwiftFunction('removeAlias(alias:)')
  Map removeAlias(String alias);

  @async
  @SwiftFunction('bindAccount(account:)')
  Map bindAccount(String account);

  @async
  @SwiftFunction('bindPhoneNumber(phone:)')
  Map bindPhoneNumber(String phone);

  @async
  @SwiftFunction('bindTag(tags:target:alias:)')
  Map bindTag(List<String> tags, {int target = 1, String? alias});

  @async
  @SwiftFunction('unbindTag(tags:target:alias:)')
  Map unbindTag(List<String> tags, {int target = 1, String? alias});

  @async
  @SwiftFunction('listTags(target:)')
  Map listTags({int target = 1});

  @async
  @SwiftFunction('clearNotifications()')
  Map clearNotifications();

  @async
  @SwiftFunction('getDeviceToken()')
  String getApnsDeviceToken();

  @async
  @SwiftFunction('getDeviceId()')
  String getDeviceId();

  @async
  @SwiftFunction('isIOSChannelOpened()')
  bool isIOSChannelOpened();

  @async
  @SwiftFunction('setBadgeNum(num:)')
  Map setIOSBadgeNum(int num);

  @async
  @SwiftFunction('setPluginLogEnabled(enabled:)')
  void setPluginLogEnabled(bool enabled);

  @async
  @SwiftFunction('showNoticeWhenForeground(enable:)')
  Map showIOSNoticeWhenForeground(bool enable);

  @async
  @SwiftFunction('syncBadgeNum(num:)')
  Map syncIOSBadgeNum(int num);

  @async
  @SwiftFunction('turnOnDebug()')
  Map turnOnIOSDebug();

  @async
  @SwiftFunction('unbindAccount()')
  Map unbindAccount();

  @async
  @SwiftFunction('unbindPhoneNumber()')
  Map unbindPhoneNumber();
}
