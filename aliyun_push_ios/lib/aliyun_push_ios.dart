
import 'aliyun_push_ios_platform_interface.dart';

class AliyunPushIos {
  Future<String?> getPlatformVersion() {
    return AliyunPushIosPlatform.instance.getPlatformVersion();
  }
}
