import SwiftUI
import WebKit

@main
struct DopamineWebApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

struct ContentView: View {
    var body: some View {
        DopamineWebView().ignoresSafeArea()
    }
}

struct DopamineWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = UIColor(red: 10/255, green: 20/255, blue: 28/255, alpha: 1)
        webView.scrollView.backgroundColor = webView.backgroundColor
        webView.scrollView.contentInsetAdjustmentBehavior = .never

        // Load the bundled HTML from the app's resource directory.
        if let htmlURL = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.loadFileURL(htmlURL, allowingReadAccessTo: htmlURL.deletingLastPathComponent())
        } else {
            let message = """
            <!doctype html><html><head><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"><title>HTML missing</title></head>
            <body style=\"margin:0;padding:28px;background:#101820;color:white;font:17px -apple-system\">
            <h2>index.html was not included in this build</h2>
            <p>Check that the repository contains index.html in its top-level folder and that project.yml lists it under resources.</p>
            </body></html>
            """
            webView.loadHTMLString(message, baseURL: nil)
        }
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
