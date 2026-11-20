# Dopamine iOS WebView wrapper

This project packages `index.html` as a local resource inside an iOS app (deployment target iOS 16+).

## GitHub layout

Keep `index.html` and `project.yml` in the repository root. Keep `DopamineWebApp.swift` in `Sources/` and `build.yml` in `.github/workflows/`.

## Build

Open Actions → Build Dopamine IPA → Run workflow. The workflow verifies that `index.html` is present in the built app bundle before packaging an unsigned IPA.

The HTML interface is a simulation; packaging it as an IPA does not grant jailbreak privileges or perform a real jailbreak/respring.
