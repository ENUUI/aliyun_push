import AlicloudUtils
import CloudPushSDK
import Flutter
import UIKit
import UserNotifications

public class AliyunPushIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = AliyunPushIosPlugin()
        AliyunPushIosApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }

    var notificationInfo: [AnyHashable: Any]?

    var showNoticeForeground: Bool = true
}

public extension AliyunPushIosPlugin {
    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        if let notificationInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            self.notificationInfo = notificationInfo
        }

        return true
    }
}

extension FlutterError: Error {}

extension AliyunPushIosPlugin: AliyunPushIosApi {
    func initPush(appKey: String?, appSecret: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appKey, !appKey.isEmpty else {
            completion(.failure(FlutterError(code: "400", message: "The [appKey] can not be empty", details: "")))
            return
        }

        guard let appSecret, !appSecret.isEmpty else {
            completion(.failure(FlutterError(code: "400", message: "The [appSecret] can not be empty", details: "")))
            return
        }

        CloudPushSDK.asyncInit(appKey, appSecret: appSecret, callback: resultCompleted("initPush", completion))
    }

    func addAlias(alias: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard !alias.isEmpty else {
            completion(.failure(FlutterError(code: "400", message: "The [alias] can not be empty!", details: "")))
            return
        }

        CloudPushSDK.addAlias(alias, withCallback: resultCompleted("addAlias", completion))
    }

    func listAlias(completion: @escaping (Result<[String], Error>) -> Void) {
        CloudPushSDK.listAliases(resultCompleted("listAliases", completion))
    }

    func removeAlias(alias: String, completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.removeAlias(alias, withCallback: resultCompleted("removeAlias", completion))
    }

    func bindAccount(account: String, completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.bindAccount(account, withCallback: resultCompleted("bindAccount", completion))
    }

    func unbindAccount(completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.unbindAccount(resultCompleted("unbindAccount", completion))
    }

    func bindPhoneNumber(phone _: String, completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(FlutterError(code: "500", message: "The method [bindPhoneNumber] not implemented.", details: "")))
    }

    func unbindPhoneNumber(completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.failure(FlutterError(code: "500", message: "The method [unbindPhoneNumber] not implemented.", details: "")))
    }

    func bindTag(tags: [String], target: Int64, alias: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.bindTag(Int32(target), withTags: tags, withAlias: alias, withCallback: resultCompleted("bindTag", completion))
    }

    func unbindTag(tags: [String], target: Int64, alias: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.unbindTag(Int32(target), withTags: tags, withAlias: alias, withCallback: resultCompleted("unbindTag", completion))
    }

    func listTags(target: Int64, completion: @escaping (Result<[String], Error>) -> Void) {
        CloudPushSDK.listTags(Int32(target), withCallback: resultCompleted("listTags", completion))
    }

    func getDeviceToken(completion: @escaping (Result<String, Error>) -> Void) {
        let token = CloudPushSDK.getApnsDeviceToken()

        guard let token, !token.isEmpty else {
            completion(.failure(FlutterError(code: "500", message: "AliyunPush [getApnsDeviceToken] failed!", details: "")))
            return
        }

        completion(.success(token))
    }

    func getDeviceId(completion: @escaping (Result<String, Error>) -> Void) {
        let deviceId = CloudPushSDK.getVersion()
        guard let deviceId, !deviceId.isEmpty else {
            completion(.failure(FlutterError(code: "500", message: "AliyunPush [getDeviceId] failed!", details: "")))
            return
        }

        completion(.success(deviceId))
    }

    func isIOSChannelOpened(completion: @escaping (Result<Bool, Error>) -> Void) {
        let open = CloudPushSDK.isChannelOpened()
        completion(.success(open))
    }

    func setBadgeNum(num: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        UIApplication.shared.applicationIconBadgeNumber = Int(num)
        completion(.success(()))
    }

    func showNoticeWhenForeground(enable: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        showNoticeForeground = enable
        completion(.success(()))
    }

    func syncBadgeNum(num: Int64, completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.syncBadgeNum(UInt(num), withCallback: resultCompleted("syncBadgeNum", completion))
    }

    func turnOnDebug(completion: @escaping (Result<Void, Error>) -> Void) {
        CloudPushSDK.turnOnDebug()
        completion(.success(()))
    }
}

extension AliyunPushIosPlugin {
    func resultCompleted(_ method: String, _ completion: @escaping (Result<Void, Error>) -> Void) -> (CloudPushCallbackResult?) -> Void {
        { r in
            guard let r, r.success else {
                completion(.failure(FlutterError(code: "500", message: "AliyunPush [\(method)] failed!", details: r?.error?.localizedDescription)))
                return
            }

            completion(.success(()))
        }
    }

    func resultCompleted(_ method: String, _ completion: @escaping (Result<[String], Error>) -> Void) -> (CloudPushCallbackResult?) -> Void {
        { r in
            guard let r, r.success else {
                completion(.failure(FlutterError(code: "500", message: "AliyunPush [\(method)] failed!", details: r?.error?.localizedDescription)))
                return
            }
            let l = r.data as? [String] ?? []
            completion(.success(l))
        }
    }
}
