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
