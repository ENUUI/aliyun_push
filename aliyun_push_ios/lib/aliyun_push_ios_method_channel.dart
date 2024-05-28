import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'aliyun_push_ios_platform_interface.dart';

/// An implementation of [AliyunPushIosPlatform] that uses method channels.
class MethodChannelAliyunPushIos extends AliyunPushIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('aliyun_push_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
