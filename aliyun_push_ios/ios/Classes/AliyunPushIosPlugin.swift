import AlicloudUtils
import CloudPushSDK
import Flutter
import UIKit
import UserNotifications

extension FlutterError: Error {}

public class AliyunPushIosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let flutterApi = AliyunPushFlutterApi(binaryMessenger: registrar.messenger())
        let instance = AliyunPushIosPlugin(flutterApi: flutterApi)

        AliyunPushIosApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
        registrar.addApplicationDelegate(instance)
    }

    var flutterApi: AliyunPushFlutterApi
    var notificationCenter: UNUserNotificationCenter?
    var remoteNotification: [AnyHashable: Any]?
    var showNoticeForeground: Bool = true

    init(flutterApi: AliyunPushFlutterApi) {
        self.flutterApi = flutterApi
    }
}

extension AliyunPushIosPlugin {
    // 推送通道打开回调
    @objc func onChannelOpened(_: Notification) {
        onChannelOpened()
    }

    // 处理到来推送消息
    @objc func onMessageReceived(_ notification: Notification) {
        guard let message = notification.object as? CCPSysMessage else {
            return
        }

        var mDic: [String: Any] = [:]

        if let titleData = message.title, let title = String(data: titleData, encoding: .utf8) {
            mDic["title"] = title
        }

        if let bodyData = message.body, let body = String(data: bodyData, encoding: .utf8) {
            mDic["body"] = body
        }

        debugPrint("######## AliyunPush iOS onMessageReceived: \(mDic)")

        onMessage(mDic)
    }
}

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

        debugPrint("######## AliyunPush iOS will register -> [appKey: \(appKey), appSecret: \(appSecret)]")
        
        if CloudPushSDK.isChannelOpened() {
            completion(.success(Void()))
            return
        }
        
        // 注册APNs
        registerAPNs()
        // 这册aliyun push
        CloudPushSDK.asyncInit(appKey, appSecret: appSecret, callback: resultCompleted("initPush", completion))

        // 注册推送消息到来监听
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageReceived(_:)), name: NSNotification.Name("CCPDidReceiveMessageNotification"), object: nil)
        // 注册推送通道打开监听
        NotificationCenter.default.addObserver(self, selector: #selector(onChannelOpened(_:)), name: NSNotification.Name("CCPDidChannelConnectedSuccess"), object: nil)
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
        let deviceId = CloudPushSDK.getDeviceId()
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
        setBadgeCount(Int(num))
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

extension AliyunPushIosPlugin {
    func handleiOS10Notification(_ notification: UNNotification) {
        let request = notification.request
        let content = request.content
        let userInfo = content.userInfo

        debugPrint("####### AliyunPush ios willPresent notification without Notice: \(userInfo)")

        setBadgeCount(0)
        syncBadgeNum(num: 0) { _ in }

        CloudPushSDK.sendNotificationAck(userInfo)
        onNotification(userInfo)
    }

    func setBadgeCount(_: Int) {
        if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(0)
        } else {
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }

    func registerAPNs() {
        notificationCenter = UNUserNotificationCenter.current()
        notificationCenter?.delegate = self
        notificationCenter?.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { granted, _ in
            if granted {
                debugPrint("####### ===> User authored notification.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                debugPrint("####### ===> User denied notification.")
            }
        })
    }
}

public extension AliyunPushIosPlugin {
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        var opts: UNNotificationPresentationOptions = []

        if showNoticeForeground {
            opts.insert(.badge)
            opts.insert(.sound)
            opts.insert(.alert)
        } else {
            handleiOS10Notification(notification)
        }

        completionHandler(opts)
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let userAction = response.actionIdentifier
        if userAction == UNNotificationDefaultActionIdentifier {
            onNotificationOpened(userInfo)
            CloudPushSDK.sendNotificationAck(userInfo)

            debugPrint("####### ===> User opened the app from the notification interface: \(userInfo)")
        }

        if userAction == UNNotificationDismissActionIdentifier {
            onNotificationRemoved(userInfo)
            CloudPushSDK.sendDeleteNotificationAck(userInfo)

            debugPrint("####### ===> User explicitly dismissed the notification interface: \(userInfo)")
        }

        completionHandler()
    }

    func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any] = [:]) -> Bool {
        if let notificationInfo = launchOptions[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
            remoteNotification = notificationInfo
        }

        return true
    }

    func application(_: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        debugPrint("###### onNotification: \(userInfo)")

        CloudPushSDK.sendNotificationAck(userInfo)

        onNotification(userInfo)

        if let remoteNotification,
           let msgId = userInfo["m"] as? String,
           let remoteMsgId = remoteNotification["m"] as? String,
           msgId == remoteMsgId
        {
            CloudPushSDK.sendNotificationAck(remoteNotification)
            onNotificationOpened(remoteNotification)
            self.remoteNotification = nil
        }

        completionHandler(.newData)
        return true
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        CloudPushSDK.registerDevice(deviceToken) { r in
            debugPrint("###### didRegisterForRemoteNotificationsWithDeviceToken: \(String(describing: CloudPushSDK.getApnsDeviceToken()))")
            if r?.success == true {
                self.onRegisterDeviceTokenSuccess(CloudPushSDK.getApnsDeviceToken())
            }
        }
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("###### didFailToRegisterForRemoteNotificationsWithError: \(error.localizedDescription)")
    }
}

/// flutterApi
extension AliyunPushIosPlugin {
    func onNotification(_ userInfo: [AnyHashable: Any?]) {
        DispatchQueue.main.async {
            self.flutterApi.onNotification(map: userInfo) { _ in }
        }
    }

    func onNotificationOpened(_ userInfo: [AnyHashable: Any?]) {
        DispatchQueue.main.async {
            self.flutterApi.onNotificationOpened(map: userInfo) { _ in }
        }
    }

    func onNotificationRemoved(_ userInfo: [AnyHashable: Any?]) {
        DispatchQueue.main.async {
            self.flutterApi.onNotificationRemoved(map: userInfo) { _ in }
        }
    }

    func onMessage(_ userInfo: [AnyHashable: Any?]) {
        DispatchQueue.main.async {
            self.flutterApi.onMessage(map: userInfo) { _ in }
        }
    }

    func onChannelOpened() {
        DispatchQueue.main.async {
            self.flutterApi.onChannelOpened { _ in }
        }
    }

    func onRegisterDeviceTokenSuccess(_ token: String) {
        DispatchQueue.main.async {
            self.flutterApi.onRegisterDeviceTokenSuccess(token: token) { _ in }
        }
    }
}
