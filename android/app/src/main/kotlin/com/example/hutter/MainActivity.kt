package com.example.hutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Register our custom audio mute plugin (works in background isolates - no Activity needed)
        flutterEngine.plugins.add(AudioMutePlugin())
    }
}
