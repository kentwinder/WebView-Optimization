//
//  ViewController.swift
//  WebView-Optimization
//
//  Created by Kent Winder on 06/01/2018.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    var webView: WKWebView!
    var popupWebViews: [WKWebView] = []
    var urlPath: String = "https://facebook-login-demo-71f0c.firebaseapp.com"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebView()
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
    
    func loadWebView() {
        if let url = URL(string: urlPath) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
        }
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        debugPrint("createWebViewWith: ", configuration)
        let popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView.navigationDelegate = self
        popupWebView.uiDelegate = self
        view.addSubview(popupWebView)
        popupWebViews.append(popupWebView)
        return popupWebView
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        debugPrint("webViewDidClose")
        if popupWebViews.contains(webView) {
            webView.removeFromSuperview()
            popupWebViews.removeLast()
        }
    }
}

extension ViewController: WKNavigationDelegate {
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

