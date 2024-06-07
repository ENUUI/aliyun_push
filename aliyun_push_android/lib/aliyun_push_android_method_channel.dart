import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aliyun_push_android_platform_interface.dart';

/// An implementation of [AliyunPushAndroidPlatform] that uses method channels.
class MethodChannelAliyunPushAndroid extends AliyunPushAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('aliyun_push_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
