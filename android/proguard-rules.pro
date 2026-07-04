# Flutter Security Toolkit (fork) — R8 rules to eliminate the 'a.a' duplicate
# class clash with flutter_inappwebview_android.
#
# The prebuilt com.github.EXXETA:Android-Security-Toolkit ships obfuscated helper
# classes in the ROOT package 'a' (a/a, a/b, ...). flutter_inappwebview_android
# does the same, so at the app's R8 step they collide:
#   "Type a.a is defined multiple times".
# We run R8 on this library (minifyEnabled true) and REPACKAGE everything into a
# library-specific namespace so nothing lands in the bare 'a' package anymore.

# Keep the public EXXETA API surface used from Dart via Pigeon/method channels.
-keep class com.exxeta.securitytoolkit.** { *; }

# Keep this plugin's own entry points.
-keep class com.example.flutter_security_toolkit.** { *; }

# Keep native methods and anything Kotlin metadata needs.
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepattributes *Annotation*, Signature, InnerClasses, EnclosingMethod

# THE FIX: move every (still-obfuscated) class into a unique package, so the
# EXXETA 'a.*' helpers become com.example.flutter_security_toolkit.r8.* and can
# never collide with another library's 'a' package.
-repackageclasses 'com.example.flutter_security_toolkit.r8'
-allowaccessmodification

-dontwarn **
