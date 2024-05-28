import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_push_ios/aliyun_push_ios.dart';
import 'package:aliyun_push_ios/aliyun_push_ios_platform_interface.dart';
import 'package:aliyun_push_ios/aliyun_push_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAliyunPushIosPlatform
    with MockPlatformInterfaceMixin
    implements AliyunPushIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AliyunPushIosPlatform initialPlatform = AliyunPushIosPlatform.instance;

  test('$MethodChannelAliyunPushIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAliyunPushIos>());
  });

  test('getPlatformVersion', () async {
    AliyunPushIos aliyunPushIosPlugin = AliyunPushIos();
    MockAliyunPushIosPlatform fakePlatform = MockAliyunPushIosPlatform();
    AliyunPushIosPlatform.instance = fakePlatform;

    expect(await aliyunPushIosPlugin.getPlatformVersion(), '42');
  });
}
