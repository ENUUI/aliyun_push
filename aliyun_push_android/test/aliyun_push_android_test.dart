import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_push_android/aliyun_push_android.dart';
import 'package:aliyun_push_android/aliyun_push_android_platform_interface.dart';
import 'package:aliyun_push_android/aliyun_push_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAliyunPushAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AliyunPushAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AliyunPushAndroidPlatform initialPlatform = AliyunPushAndroidPlatform.instance;

  test('$MethodChannelAliyunPushAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAliyunPushAndroid>());
  });

  test('getPlatformVersion', () async {
    AliyunPushAndroid aliyunPushAndroidPlugin = AliyunPushAndroid();
    MockAliyunPushAndroidPlatform fakePlatform = MockAliyunPushAndroidPlatform();
    AliyunPushAndroidPlatform.instance = fakePlatform;

    expect(await aliyunPushAndroidPlugin.getPlatformVersion(), '42');
  });
}
