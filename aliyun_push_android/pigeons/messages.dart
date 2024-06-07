import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  kotlinOut:
      'android/src/main/kotlin/github/enuui/aliyun_push_android/Messages.kt',
  kotlinOptions: KotlinOptions(
    package: 'github.enuui.aliyun_push_android',
  ),
))
@HostApi()
abstract class AliyunPushAndroidApi {
  @async
  void initPush();

  @async
  void initThirdPush();

  @async
  void closePushLog();

  @async
  String getDeviceId();

  @async
  void setLogLevel(int level);

  @async
  void bindAccount(String account);

  @async
  void unbindAccount();

  @async
  void addAlias(String alias);

  @async
  void removeAlias(String alias);

  @async
  List<String> listAlias();

  @async
  void bindTag(List<String> tags, {int target = 1, String? alias});

  @async
  void unbindTag(List<String> tags, {int target = 1, String? alias});

  @async
  List<String> listTags({int target = 1});

  @async
  void bindPhoneNumber(String phone);

  @async
  void unbindPhoneNumber();

  @async
  void setNotificationInGroup(bool inGroup);

  @async
  void clearNotifications();

  @async
  void createChannel(String id, String name, int importance, String description,
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

  @async
  void createChannelGroup(String id, String name, String desc);

  @async
  bool isNotificationEnabled({String? id});

  void jumpToNotificationSettings({String? id});

  void setPluginLogEnabled(bool enabled);
}
