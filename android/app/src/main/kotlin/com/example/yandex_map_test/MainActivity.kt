package com.example.yandex_map_test
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterActivity
import com.yandex.mapkit.MapKitFactory

class MainActivity: FlutterActivity() {
override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    MapKitFactory.setApiKey("398d6724-89a6-47b8-8985-8cd5bc080837") 
    super.configureFlutterEngine(flutterEngine)
  }
}
