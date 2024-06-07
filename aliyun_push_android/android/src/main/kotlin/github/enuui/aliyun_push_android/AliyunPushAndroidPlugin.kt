package github.enuui.aliyun_push_android

import android.app.Activity
import android.app.Application
import android.app.NotificationChannel
import android.app.NotificationChannelGroup
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.app.NotificationManagerCompat
import com.alibaba.sdk.android.push.CloudPushService
import com.alibaba.sdk.android.push.CommonCallback
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import java.io.File


/** AliyunPushAndroidPlugin */
class AliyunPushAndroidPlugin : FlutterPlugin, AliyunPushAndroidApi {
    companion object {
        var flutterApi: AliyunPushFlutterApi? = null
    }

    private var mContext: Context? = null
    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        mContext = flutterPluginBinding.applicationContext
        flutterApi = AliyunPushFlutterApi(flutterPluginBinding.binaryMessenger)
        AliyunPushAndroidApi.setUp(flutterPluginBinding.binaryMessenger, this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterApi = null
        mContext = null
        AliyunPushAndroidApi.setUp(binding.binaryMessenger, null)
    }

    override fun initPush(callback: (Result<Unit>) -> Unit) {
        PushServiceFactory.init(mContext)
        val pushService: CloudPushService = PushServiceFactory.getCloudPushService()
        pushService.setLogLevel(CloudPushService.LOG_DEBUG)
        pushService.register(mContext, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
        pushService.turnOnPushChannel(object : CommonCallback {
            override fun onSuccess(response: String?) {
            }

            override fun onFailed(code: String?, errorMessage: String?) {
            }
        })
    }

    override fun initThirdPush(callback: (Result<Unit>) -> Unit) {
        val map = HashMap<String, String>()
        val context = mContext!!.applicationContext
        if (context is Application) {
            AliyunThirdPushUtils.registerHuaweiPush(context)
            AliyunThirdPushUtils.registerXiaoMiPush(context)
            AliyunThirdPushUtils.registerVivoPush(context)
            AliyunThirdPushUtils.registerOppoPush(context)
            AliyunThirdPushUtils.registerMeizuPush(context)
            AliyunThirdPushUtils.registerGCM(context)
            AliyunThirdPushUtils.registerHonorPush(context)
            callback(Result.success(Unit))
        } else {
            callback(Result.failure(FlutterError("500", "context is not Application", map)))
        }
    }

    override fun closePushLog(callback: (Result<Unit>) -> Unit) {
        val service = PushServiceFactory.getCloudPushService()
        service.setLogLevel(CloudPushService.LOG_OFF)
        callback(Result.success(Unit))
    }

    override fun getDeviceId(callback: (Result<String>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        val deviceId = pushService.deviceId

        if (deviceId != null) {
            callback(Result.success(deviceId))
        } else {
            callback(Result.failure(FlutterError("500", "deviceId is null", null)))
        }
    }

    override fun setLogLevel(level: Long, callback: (Result<Unit>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.setLogLevel(level.toInt())
        callback(Result.success(Unit))
    }

    override fun bindAccount(account: String, callback: (Result<Unit>) -> Unit) {
        if (account.isEmpty()) {
            callback(Result.failure(FlutterError("400", "account is empty", null)))
            return
        }

        val pushService = PushServiceFactory.getCloudPushService()
        pushService.bindAccount(account, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })

    }

    override fun unbindAccount(callback: (Result<Unit>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.unbindAccount(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun addAlias(alias: String, callback: (Result<Unit>) -> Unit) {
        if (alias.isEmpty()) {
            callback(Result.failure(FlutterError("400", "alias is empty", null)))
            return
        }
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.addAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun removeAlias(alias: String, callback: (Result<Unit>) -> Unit) {
        if (alias.isEmpty()) {
            callback(Result.failure(FlutterError("400", "alias is empty", null)))
            return
        }
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.removeAlias(alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun listAlias(callback: (Result<List<String>>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.listAliases(object : CommonCallback {
            override fun onSuccess(response: String?) {
                val aliases = response?.split(",")
                if (aliases != null) {
                    callback(Result.success(aliases))
                } else {
                    callback(Result.failure(FlutterError("500", "aliases is null", null)))
                }
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun bindTag(
        tags: List<String>, target: Long, alias: String?, callback: (Result<Unit>) -> Unit
    ) {
        if (tags.isEmpty()) {
            callback(Result.failure(FlutterError("400", "tags is empty", null)))
            return
        }
        val t: Int = target.toInt()
        if (t <= 0) {
            callback(Result.failure(FlutterError("400", "target is invalid", null)))
            return
        }


        val pushService = PushServiceFactory.getCloudPushService()
        pushService.bindTag(t, tags.toTypedArray(), alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun unbindTag(
        tags: List<String>, target: Long, alias: String?, callback: (Result<Unit>) -> Unit
    ) {
        if (tags.isEmpty()) {
            callback(Result.failure(FlutterError("400", "tags is empty", null)))
            return
        }
        val t: Int = target.toInt()
        if (t <= 0) {
            callback(Result.failure(FlutterError("400", "target is invalid", null)))
            return
        }

        val pushService = PushServiceFactory.getCloudPushService()
        pushService.unbindTag(t, tags.toTypedArray(), alias, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun listTags(target: Long, callback: (Result<List<String>>) -> Unit) {
        val t: Int = target.toInt()
        if (t <= 0) {
            callback(Result.failure(FlutterError("400", "target is invalid", null)))
            return
        }

        val pushService = PushServiceFactory.getCloudPushService()
        pushService.listTags(t, object : CommonCallback {
            override fun onSuccess(response: String?) {
                val tags = response?.split(",")
                if (tags != null) {
                    callback(Result.success(tags))
                } else {
                    callback(Result.failure(FlutterError("500", "tags is null", null)))
                }
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun bindPhoneNumber(phone: String, callback: (Result<Unit>) -> Unit) {
        if (phone.isEmpty()) {
            callback(Result.failure(FlutterError("400", "phone is empty", null)))
            return
        }

        val pushService = PushServiceFactory.getCloudPushService()
        pushService.bindPhoneNumber(phone, object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun unbindPhoneNumber(callback: (Result<Unit>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.unbindPhoneNumber(object : CommonCallback {
            override fun onSuccess(response: String?) {
                callback(Result.success(Unit))
            }

            override fun onFailed(code: String?, errorMessage: String?) {
                callback(Result.failure(FlutterError(code ?: "500", errorMessage, null)))
            }
        })
    }

    override fun setNotificationInGroup(inGroup: Boolean, callback: (Result<Unit>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.setNotificationShowInGroup(inGroup)
        callback(Result.success(Unit))
    }

    override fun clearNotifications(callback: (Result<Unit>) -> Unit) {
        val pushService = PushServiceFactory.getCloudPushService()
        pushService.clearNotifications()
        callback(Result.success(Unit))
    }

    override fun createChannel(
        id: String,
        name: String,
        importance: Long,
        description: String,
        groupId: String?,
        allowBubbles: Boolean?,
        light: Boolean?,
        lightColor: Long?,
        showBadge: Boolean?,
        soundPath: String?,
        soundUsage: Long?,
        soundContentType: Long?,
        soundFlag: Long?,
        vibration: Boolean?,
        vibrationPatterns: List<Long>?,
        callback: (Result<Unit>) -> Unit
    ) {
        val pushService = PushServiceFactory.getCloudPushService()

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            callback(Result.failure(FlutterError("500", "Android version is too low", null)))
            return
        }

        val notificationManager =
            mContext!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val channel = NotificationChannel(id, name, importance.toInt())
        channel.description = description
        if (groupId != null) {
            channel.group = groupId
        }
        if (allowBubbles != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            channel.setAllowBubbles(allowBubbles)
        }
        if (light != null) {
            channel.enableLights(light)
        }
        if (lightColor != null) {
            channel.lightColor = lightColor.toInt()
        }
        if (showBadge != null) {
            channel.setShowBadge(showBadge)
        }

        if (!soundPath.isNullOrEmpty()) {
            val file = File(soundPath)
            if (file.exists() && file.canRead() && file.isFile) {
                if (soundUsage == null) {
                    channel.setSound(Uri.fromFile(file), null)
                } else {
                    val builder = AudioAttributes.Builder().setUsage(soundUsage.toInt())
                    if (soundContentType != null) {
                        builder.setContentType(soundContentType.toInt())
                    }
                    if (soundFlag != null) {
                        builder.setFlags(soundFlag.toInt())
                    }
                    channel.setSound(Uri.fromFile(file), builder.build())
                }
            }
        }
        if (vibration != null) {
            channel.enableVibration(vibration)
        }
        if (!vibrationPatterns.isNullOrEmpty()) {
            val pattern = LongArray(vibrationPatterns.size)
            for (i in vibrationPatterns.indices) {
                pattern[i] = vibrationPatterns[i]
            }
            channel.vibrationPattern = pattern
        }
        notificationManager.createNotificationChannel(channel)

        callback(Result.success(Unit))
    }

    override fun createChannelGroup(
        id: String, name: String, desc: String, callback: (Result<Unit>) -> Unit
    ) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            callback(Result.failure(FlutterError("500", "Android version is too low", null)))
            return
        }
        val notificationManager =
            mContext!!.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val group = NotificationChannelGroup(id, name)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            group.description = desc
        }
        notificationManager.createNotificationChannelGroup(group)

        callback(Result.success(Unit))
    }

    override fun isNotificationEnabled(id: String?, callback: (Result<Boolean>) -> Unit) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            val enabled = NotificationManagerCompat.from(mContext!!).areNotificationsEnabled()
            callback(Result.success(enabled))
            return
        }

        val manager = mContext!!.getSystemService(
            Context.NOTIFICATION_SERVICE
        ) as NotificationManager
        if (!manager.areNotificationsEnabled()) {
            callback(Result.success(false))
            return
        }
        if (id == null) {
            callback(Result.success(true))
            return
        }
        val channels = manager.notificationChannels
        for (channel in channels) {
            if (channel.id == id) {
                if (channel.importance == NotificationManager.IMPORTANCE_NONE) {
                    callback(Result.success(false))
                    return
                } else {
                    if (channel.group != null) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                            val group = manager.getNotificationChannelGroup(channel.group)
                            callback(Result.success(!group.isBlocked))
                            return
                        }
                    }
                    callback(Result.success(true))
                    return
                }
            }
        }

        callback(Result.success(false))
    }

    override fun jumpToNotificationSettings(id: String?) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return
        }

        val intent: Intent
        if (id != null) {
            intent = Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS)
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, mContext!!.packageName)
            intent.putExtra(Settings.EXTRA_CHANNEL_ID, id)
        } else {
            // 跳转到应用的通知设置界面
            intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS)
            intent.putExtra(Settings.EXTRA_APP_PACKAGE, mContext!!.packageName)
        }
        if (mContext !is Activity) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        mContext!!.startActivity(intent)
    }

    override fun setPluginLogEnabled(enabled: Boolean) {
        AliyunPushLog.setLogEnabled(enabled);
    }
}
