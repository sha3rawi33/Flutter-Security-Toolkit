# security-toolkit-relocated.jar

A **package-relocated** copy of the upstream
`com.github.EXXETA:Android-Security-Toolkit:1.0.1` runtime jar.

## Why

The upstream jar ships four obfuscated helper classes in the **root package `a`**
(`a/a`, `a/b`, `a/c`, `a/d`). `flutter_inappwebview_android` also places classes
in package `a`, so an app depending on **both** fails at the R8 step with:

```
Type a.a is defined multiple times
```

You can't rename classes inside a prebuilt transitive binary from the app side,
so we relocate them here: package **`a`** → **`com/exxeta/securitytoolkit/internal`**,
rewriting every bytecode reference. The public
`com.exxeta.securitytoolkit.*` API (`ThreatDetectionCenter`, its `Threat` enum,
`areRootPrivilegesDetected()`, `areHooksDetected()`, `isSimulatorDetected()`) is
**unchanged** — the plugin behaves identically. This is a packaging fix only, not
a security/obfuscation change (the public API an attacker would hook is stable
regardless).

## How it was produced

Relocated with ASM (`ClassRemapper`), mapping internal name `a` / `a/*` to
`com/exxeta/securitytoolkit/internal/*`, rewriting both the class bytecode and
the zip entry paths. Verified: no `a/*.class` remain; `ThreatDetectionCenter`
now references `com/exxeta/securitytoolkit/internal/{a,c,d}`.

To regenerate against a newer upstream version, re-run the same relocation on the
new jar (map root package `a` → `com/exxeta/securitytoolkit/internal`) and replace
this file.
