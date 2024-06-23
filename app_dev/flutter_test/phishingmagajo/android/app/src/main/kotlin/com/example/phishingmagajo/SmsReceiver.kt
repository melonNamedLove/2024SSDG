package com.example.phishingmagajo

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.os.Bundle
import android.provider.Telephony
import android.telephony.SmsMessage
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class SmsReceiver : BroadcastReceiver() {
    companion object {
        private const val CHANNEL = "com.example.phishingmagajo/sms"
        private var channel: MethodChannel? = null

        fun registerWith(registrar: PluginRegistry.Registrar) {
            channel = MethodChannel(registrar.messenger(), CHANNEL)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {
            val bundle = intent.extras
            val messages: Array<SmsMessage?>
            var strMessage = ""

            if (bundle != null) {
                val pdus = bundle["pdus"] as Array<*>
                messages = arrayOfNulls(pdus.size)

                for (i in pdus.indices) {
                    messages[i] = SmsMessage.createFromPdu(pdus[i] as ByteArray)
                    strMessage += "SMS from ${messages[i]?.originatingAddress}"
                    strMessage += " : ${messages[i]?.messageBody}"
                    strMessage += "\n"
                }

                Log.d("SmsReceiver", strMessage)

                // Flutter로 데이터를 전송하는 코드를 추가
                channel?.invokeMethod("smsReceived", strMessage)
            }
        }
    }
}
