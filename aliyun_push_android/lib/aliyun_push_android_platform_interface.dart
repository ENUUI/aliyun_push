import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'aliyun_push_android_method_channel.dart';

abstract class AliyunPushAndroidPlatform extends PlatformInterface {
  /// Constructs a AliyunPushAndroidPlatform.
  AliyunPushAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AliyunPushAndroidPlatform _instance = MethodChannelAliyunPushAndroid();

  /// The default instance of [AliyunPushAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelAliyunPushAndroid].
  static AliyunPushAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AliyunPushAndroidPlatform] when
  /// they register themselves.
  static set instance(AliyunPushAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
