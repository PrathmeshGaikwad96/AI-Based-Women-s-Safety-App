package com.example.hutter

import android.content.Context
import android.media.AudioManager
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Custom Flutter plugin for muting/unmuting specific Android audio streams.
 *
 * This plugin registers its MethodChannel in [onAttachedToEngine], which means it works
 * in BOTH the main isolate (with Activity) AND background isolates (services, foreground tasks)
 * where Activity context is not available.
 *
 * This resolves the MissingPluginException seen with flutter_volume_controller in background
 * foreground task isolates (which require ActivityAware but have no Activity).
 */
class AudioMutePlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    companion object {
        const val CHANNEL = "com.hutter.app/audio_mute"

        // Android AudioManager stream type constants
        const val STREAM_VOICE_CALL = AudioManager.STREAM_VOICE_CALL   // 0
        const val STREAM_SYSTEM = AudioManager.STREAM_SYSTEM           // 1
        const val STREAM_RING = AudioManager.STREAM_RING               // 2
        const val STREAM_MUSIC = AudioManager.STREAM_MUSIC             // 3
        const val STREAM_ALARM = AudioManager.STREAM_ALARM             // 4
        const val STREAM_NOTIFICATION = AudioManager.STREAM_NOTIFICATION // 5
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "muteStream" -> {
                val streamType = call.argument<Int>("streamType") ?: STREAM_SYSTEM
                val mute = call.argument<Boolean>("mute") ?: true
                try {
                    val audioManager =
                        applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        audioManager.adjustStreamVolume(
                            streamType,
                            if (mute) AudioManager.ADJUST_MUTE else AudioManager.ADJUST_UNMUTE,
                            0 // No flags — silent adjustment
                        )
                    } else {
                        @Suppress("DEPRECATION")
                        audioManager.setStreamMute(streamType, mute)
                    }
                    result.success(null)
                } catch (e: Exception) {
                    result.error("AUDIO_MUTE_ERROR", e.message, null)
                }
            }

            "muteMultipleStreams" -> {
                val streamTypes = call.argument<List<Int>>("streamTypes") ?: listOf(STREAM_SYSTEM)
                val mute = call.argument<Boolean>("mute") ?: true
                try {
                    val audioManager =
                        applicationContext.getSystemService(Context.AUDIO_SERVICE) as AudioManager
                    for (streamType in streamTypes) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            audioManager.adjustStreamVolume(
                                streamType,
                                if (mute) AudioManager.ADJUST_MUTE else AudioManager.ADJUST_UNMUTE,
                                0
                            )
                        } else {
                            @Suppress("DEPRECATION")
                            audioManager.setStreamMute(streamType, mute)
                        }
                    }
                    result.success(null)
                } catch (e: Exception) {
                    result.error("AUDIO_MUTE_ERROR", e.message, null)
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
