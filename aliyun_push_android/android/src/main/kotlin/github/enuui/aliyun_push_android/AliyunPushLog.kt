package github.enuui.aliyun_push_android

import android.util.Log

class AliyunPushLog private constructor() {
    companion object {
        private var sLogEnabled = false

        fun isLogEnabled(): Boolean {
            return sLogEnabled
        }

        fun setLogEnabled(logEnabled: Boolean) {
            sLogEnabled = logEnabled
        }

        fun d(tag: String?, msg: String?) {
            if (sLogEnabled) {
                Log.d(tag, msg ?: "")
            }
        }

        fun e(tag: String?, msg: String?) {
            if (sLogEnabled) {
                Log.e(tag, msg ?: "")
            }
        }
    }
}