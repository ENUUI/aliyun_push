package github.enuui.aliyun_push_android

import android.app.Notification
import android.content.Context
import android.os.Handler
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.alibaba.sdk.android.push.MessageReceiver
import com.alibaba.sdk.android.push.notification.CPushMessage
import com.alibaba.sdk.android.push.notification.NotificationConfigure
import com.alibaba.sdk.android.push.notification.PushData


class AliyunPushMessageReceiver : MessageReceiver() {

    val recTag = "MPS:receiver"

    override fun hookNotificationBuild(): NotificationConfigure {
        return object : NotificationConfigure {
            override fun configBuilder(p0: Notification.Builder?, p1: PushData?) {
                AliyunPushLog.e(recTag, "configBuilder")
            }

            override fun configBuilder(p0: NotificationCompat.Builder?, p1: PushData?) {
                AliyunPushLog.e(recTag, "configBuilder")
            }

            override fun configNotification(p0: Notification?, p1: PushData?) {
                AliyunPushLog.e(recTag, "configNotification")
            }
        }
    }

    override fun showNotificationNow(p0: Context?, map: MutableMap<String, String>?): Boolean {
        map?.let {
            for ((key, value) in it) {
                AliyunPushLog.e(recTag, "key $key value $value")
            }
        }
        return super.showNotificationNow(p0, map)
    }

    /**
     * 推送通知的回调方法
     *
     * @param context
     * @param title
     * @param summary
     * @param extraMap
     */
    override fun onNotification(
        context: Context?,
        title: String?,
        summary: String?,
        extraMap: MutableMap<String, String>?
    ) {
        val arguments: MutableMap<Any, Any> = HashMap()
        if (null != extraMap) {
            arguments.putAll(extraMap)
        }

        runOnMainThread { AliyunPushAndroidPlugin.flutterApi?.onNotification(arguments) {} }
    }

    /**
     * 应用处于前台时通知到达回调。注意:该方法仅对自定义样式通知有效,相关详情请参考
     *  - https://help.aliyun.com/document_detail/30066.html?spm=5176.product30047.6.620.wjcC87#h3-3-4-basiccustompushnotification-api
     *
     * @param context
     * @param title
     * @param summary
     * @param extraMap
     * @param openType
     * @param openActivity
     * @param openUrl
     */
    override fun onNotificationReceivedInApp(
        context: Context?,
        title: String?,
        summary: String?,
        extraMap: MutableMap<String, String>?,
        openType: Int,
        openActivity: String?,
        openUrl: String?
    ) {
        val arguments: MutableMap<Any, Any?> = HashMap()
        if (!extraMap.isNullOrEmpty()) {
            arguments.putAll(extraMap)
        }
        arguments["title"] = title
        arguments["summary"] = summary
        arguments["openType"] = openType
        arguments["openActivity"] = openActivity
        arguments["openUrl"] = openUrl

        runOnMainThread { AliyunPushAndroidPlugin.flutterApi?.onNotificationReceivedInApp(arguments) {} }
    }

    /**
     * 推送消息的回调方法
     *
     * @param context
     * @param cPushMessage
     */
    override fun onMessage(context: Context?, cPushMessage: CPushMessage?) {
        val arguments: MutableMap<Any, Any?> = HashMap()
        cPushMessage?.let {
            arguments["title"] = it.title
            arguments["content"] = it.content
            arguments["msgId"] = it.messageId
            arguments["appId"] = it.appId
            arguments["traceInfo"] = it.traceInfo
        }

        runOnMainThread { AliyunPushAndroidPlugin.flutterApi?.onMessage(arguments) {} }
    }

    /**
     * 从通知栏打开通知的扩展处理
     *
     * @param context
     * @param title
     * @param summary
     * @param extraMap
     */
    override fun onNotificationOpened(
        context: Context?,
        title: String?,
        summary: String?,
        extraMap: String?
    ) {
        val arguments: MutableMap<Any, Any?> = HashMap()
        arguments["title"] = title
        arguments["summary"] = summary
        arguments["extraMap"] = extraMap

        runOnMainThread { AliyunPushAndroidPlugin.flutterApi?.onNotificationOpened(arguments) {} }
    }

    /**
     * 通知删除回调
     *
     * @param context
     * @param messageId
     */
    override fun onNotificationRemoved(context: Context?, messageId: String?) {
        val arguments: MutableMap<Any, Any?> = HashMap()
        arguments["msgId"] = messageId

        runOnMainThread { AliyunPushAndroidPlugin.flutterApi?.onNotificationRemoved(arguments) {} }
    }

    /**
     * 无动作通知点击回调。当在后台或阿里云控制台指定的通知动作为无逻辑跳转时,
     * 通知点击回调为onNotificationClickedWithNoAction而不是onNotificationOpened
     *
     * @param context
     * @param title
     * @param summary
     * @param extraMap
     */
    override fun onNotificationClickedWithNoAction(
        context: Context?,
        title: String?,
        summary: String?,
        extraMap: String?
    ) {
        val arguments: MutableMap<Any, Any?> = HashMap()
        arguments["title"] = title
        arguments["summary"] = summary
        arguments["extraMap"] = extraMap

        runOnMainThread {
            AliyunPushAndroidPlugin.flutterApi?.onNotificationClickedWithNoAction(arguments) {}
        }
    }


    private fun runOnMainThread(runnable: Runnable) {
        Handler(Looper.getMainLooper()).post(runnable)
    }
}