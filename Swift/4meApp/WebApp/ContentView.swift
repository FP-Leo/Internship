//
//  ContentView.swift
//  4MeWebApp
//
//  Created by Leo on 15.08.2023.
//  Simple app to display a web page 

import SwiftUI
import WebKit

struct ContentView: View {
    var body: some View {
        NavigationView {
            WebView(urlString: "https://rint-destek.4me.qa/self-service")
        }
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//     static var previews: some View {
//         ContentView()
//     }
// }