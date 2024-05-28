import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aliyun_push_ios_method_channel.dart';

abstract class AliyunPushIosPlatform extends PlatformInterface {
  /// Constructs a AliyunPushIosPlatform.
  AliyunPushIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliyunPushIosPlatform _instance = MethodChannelAliyunPushIos();

  /// The default instance of [AliyunPushIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliyunPushIos].
  static AliyunPushIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliyunPushIosPlatform] when
  /// they register themselves.
  static set instance(AliyunPushIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
