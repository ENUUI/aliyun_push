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
  void initPush({String? appKey, String? appSecret});

  @async
  @SwiftFunction('addAlias(alias:)')
  void addAlias(String alias);

  @async
  @SwiftFunction('listAlias()')
  List<String> listAlias();

  @async
  @SwiftFunction('removeAlias(alias:)')
  void removeAlias(String alias);

  @async
  @SwiftFunction('bindAccount(account:)')
  void bindAccount(String account);

  // @async
  // @SwiftFunction('bindPhoneNumber(phone:)')
  // void bindPhoneNumber(String phone);
  //
  // @async
  // @SwiftFunction('unbindPhoneNumber()')
  // void unbindPhoneNumber();

  @async
  @SwiftFunction('bindTag(tags:target:alias:)')
  void bindTag(List<String> tags, {int target = 1, String? alias});

  @async
  @SwiftFunction('unbindTag(tags:target:alias:)')
  void unbindTag(List<String> tags, {int target = 1, String? alias});

  @async
  @SwiftFunction('listTags(target:)')
  List<String> listTags({int target = 1});

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
  void setIOSBadgeNum(int num);

  @async
  @SwiftFunction('showNoticeWhenForeground(enable:)')
  void showIOSNoticeWhenForeground(bool enable);

  @async
  @SwiftFunction('syncBadgeNum(num:)')
  void syncIOSBadgeNum(int num);

  @async
  @SwiftFunction('turnOnDebug()')
  void turnOnIOSDebug();

  @async
  @SwiftFunction('unbindAccount()')
  void unbindAccount();
}

@FlutterApi()
abstract class AliyunPushFlutterApi {
  @SwiftFunction('onNotificationOpened(map:)')
  void onNotificationOpened(Map map);

  @SwiftFunction('onNotificationRemoved(map:)')
  void onNotificationRemoved(Map map);

  @SwiftFunction('onNotification(map:)')
  void onNotification(Map map);

  @SwiftFunction('onMessage(map:)')
  void onMessage(Map map);

  @SwiftFunction('onChannelOpened()')
  void onChannelOpened();

  @SwiftFunction('onRegisterDeviceTokenSuccess(token:)')
  void onRegisterDeviceTokenSuccess(String token);
}
