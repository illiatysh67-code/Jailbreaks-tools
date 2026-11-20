# Dopamine iOS WebView wrapper

This repository packages the supplied `index.html` interface inside a simple SwiftUI/WKWebView iOS app.

## Build on GitHub

1. Create or open your GitHub repository.
2. Upload **all contents of this folder** to the repository root (do not upload the outer `Dopamine-iOS` folder itself).
3. Make sure the repository's default branch is `main`.
4. Open the **Actions** tab.
5. Select **Build Dopamine IPA** and choose **Run workflow** (or push a commit to `main`).
6. When the workflow finishes, open the run and download the **Dopamine-IPA** artifact.

The workflow creates an **unsigned IPA**. Sign it with your own Apple signing method before normal installation (for example, AltStore or Sideloadly).

## Important limitation

This app displays the supplied HTML interface in a WKWebView. Packaging a web interface as an IPA does not grant jailbreak privileges or make simulated jailbreak/respring controls perform real system modifications.
