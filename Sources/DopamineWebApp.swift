
import SwiftUI
import WebKit

@main
struct DopamineWebApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        DopamineWebView()
            .ignoresSafeArea()
    }
}

struct DopamineWebView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {

        let config = WKWebViewConfiguration()

        let errorScript = """
        window.addEventListener('error', function(e) {
            setTimeout(function() {
                var box = document.createElement('div');
                box.style.cssText = 'position:fixed;z-index:999999;top:10px;left:10px;right:10px;padding:15px;background:#8b0000;color:white;border-radius:12px;font:14px Arial;';
                box.textContent = 'JavaScript error: ' + e.message + ' (line ' + e.lineno + ')';
                document.body.appendChild(box);
            }, 100);
        });
        """

        config.userContentController.addUserScript(
            WKUserScript(
                source: errorScript,
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )

        let webView = WKWebView(
            frame: .zero,
            configuration: config
        )

        webView.navigationDelegate = context.coordinator
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isOpaque = false
        webView.backgroundColor = .clear

        if let htmlURL = findHTML() {
            webView.loadFileURL(
                htmlURL,
                allowingReadAccessTo: Bundle.main.resourceURL ?? htmlURL.deletingLastPathComponent()
            )
        } else {
            webView.loadHTMLString("""
            <html>
            <body style="background:#101820;color:white;font:18px Arial;padding:30px">
            <h2>HTML file not found</h2>
            <p>index.html is missing from the app bundle.</p>
            <p>Check that index.html is in the main GitHub repository and project.yml includes it as a resource.</p>
            </body>
            </html>
            """, baseURL: nil)
        }

        return webView
    }

    func findHTML() -> URL? {
        if let url = Bundle.main.url(
            forResource: "index",
            withExtension: "html"
        ) {
            return url
        }

        if let resourceURL = Bundle.main.resourceURL {
            let directURL = resourceURL.appendingPathComponent("index.html")

            if FileManager.default.fileExists(atPath: directURL.path) {
                return directURL
            }

            if let enumerator = FileManager.default.enumerator(
                at: resourceURL,
                includingPropertiesForKeys: nil
            ) {
                for case let url as URL in enumerator {
                    if url.lastPathComponent == "index.html" {
                        return url
                    }
                }
            }
        }

        return nil
    }

    func updateUIView(
        _ webView: WKWebView,
        context: Context
    ) {}

    class Coordinator: NSObject, WKNavigationDelegate {

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            showError(webView, error: error)
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            showError(webView, error: error)
        }

        func showError(_ webView: WKWebView, error: Error) {
            webView.loadHTMLString("""
            <html>
            <body style="background:#101820;color:white;font:18px Arial;padding:30px">
            <h2>Page loading failed</h2>
            <p>\(error.localizedDescription)</p>
            </body>
            </html>
            """, baseURL: nil)
        }
    }
}

