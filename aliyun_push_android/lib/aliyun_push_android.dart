
import 'aliyun_push_android_platform_interface.dart';

class AliyunPushAndroid {
  Future<String?> getPlatformVersion() {
    return AliyunPushAndroidPlatform.instance.getPlatformVersion();
  }
}
