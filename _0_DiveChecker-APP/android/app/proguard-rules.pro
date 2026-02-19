# Flutter ProGuard Rules for DiveChecker (RTM 3.0)
# ==================================================

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Google Play Core (referenced by Flutter deferred components)
-dontwarn com.google.android.play.core.**

# BouncyCastle/PointyCastle (used for ECDSA authentication)
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# Keep annotations
-keepattributes *Annotation*

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
