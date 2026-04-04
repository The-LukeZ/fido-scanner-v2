# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Preserve stack trace info for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# CameraX camera2 backend is discovered via ServiceLoader by ProcessCameraProvider —
# not referenced directly in code, so R8 strips it without this rule.
-keep class androidx.camera.camera2.Camera2Config$DefaultProvider { *; }

# Keep camera2 internal implementation classes whose fields R8 may null-out by
# treating them as dead code (they're wired up inside Camera2Config.defaultConfig()
# via lambdas, not direct static references that R8 can trace).
-keep class androidx.camera.camera2.internal.** { *; }

# Keep analyze() on Analyzer implementations so CameraX can invoke it via the interface.
-keepclassmembers class * implements androidx.camera.core.ImageAnalysis$Analyzer {
    public void analyze(androidx.camera.core.ImageProxy);
}