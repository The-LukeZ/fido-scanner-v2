# Preserve stack traces for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# CameraX camera2 backend — discovered via ServiceLoader, not a direct code reference,
# so R8 would otherwise strip it.
-keep class androidx.camera.camera2.Camera2Config$DefaultProvider { *; }

# Keep analyze() on Analyzer implementations so CameraX can call it via the interface.
-keepclassmembers class * implements androidx.camera.core.ImageAnalysis$Analyzer {
    public void analyze(androidx.camera.core.ImageProxy);
}

# ML Kit barcode — internal implementation classes accessed via factory/registry patterns
# not visible to R8 static analysis.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.internal.mlkit_**
