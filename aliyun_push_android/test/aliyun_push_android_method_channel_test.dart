import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_push_android/aliyun_push_android_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAliyunPushAndroid platform = MethodChannelAliyunPushAndroid();
  const MethodChannel channel = MethodChannel('aliyun_push_android');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
