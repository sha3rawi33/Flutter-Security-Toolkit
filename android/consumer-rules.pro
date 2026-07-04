# Consumer rules injected into the APP's R8 when it depends on this library.
# The library already repackaged its classes (incl. the bundled EXXETA toolkit)
# out of the root 'a' package during its own release build, so nothing extra is
# needed here beyond keeping the public API. Deliberately does NOT contain any
# -repackageclasses rule (that would affect the whole app).

-keep class com.exxeta.securitytoolkit.** { *; }
-keep class com.example.flutter_security_toolkit.** { *; }
-dontwarn com.exxeta.securitytoolkit.**
