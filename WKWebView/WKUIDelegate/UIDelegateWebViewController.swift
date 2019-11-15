//
//  UIDelegateWebViewController.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/14.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit
import WebKit

class UIDelegateWebViewController: UIViewController {

    private let fileName = "/webview_delegate.html"
    
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: ProgressView!
    
    private var openWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 代理
        webView.uiDelegate = self
        
        // 是否允许左滑返回上一级
        webView.allowsBackForwardNavigationGestures = true
    
        // 已打开网页列表
        let _ = webView.backForwardList
        
       
        let path = Bundle.main.bundlePath.appending(fileName)
        let requestURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: requestURL)
        webView.load(request)
        
        addObserver()

    }


    func addObserver() {

        /// 获取 title
        self.titleObservation = webView.observe(\.title, changeHandler: { [weak self](webView, change) in
            guard let self = self else { return }
            self.title = webView.title
        })
        
        /// 读取进度
        self.progressObservation = webView.observe(\.estimatedProgress) { [weak self](webView,  change) in
            guard let self = self else { return }
            self.progressView.animate(with: webView.estimatedProgress)
        }
    }
 
    deinit {
        self.progressObservation?.invalidate()
        self.titleObservation?.invalidate()
    }
    
    
}

extension UIDelegateWebViewController: WKUIDelegate {
    
    // MARK: - javaScript 弹窗触发 WKWebView 的相关代理
    /// js 执行 alert 方法将执行该代理方法
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        show(panel: .alert, prompt: "", text: message) { _ in
            completionHandler()
        }
    }
    
    /// js 执行 confirm 方法将执行该代理方法
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        show(panel: .confirm, prompt: "", text: message)
        completionHandler(true)
    }
    
    /// js 执行 prompt 方法将执行该代理方法
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        show(panel: .input, prompt: prompt, text: defaultText ?? "") {
            completionHandler($0)
        }
    }
    
    // MARK: - javaScript 打开新页面或关闭触发代理
    /// 当 js 调用 window.open(url) 方法时会触发该回调
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        // 通过已有的 webView 加载网页, 这种方式加载的网页无法通过 window.close() 来关闭
        _ = webView.load(navigationAction.request)
        return nil
        
        // 创建一个新的 webView 加载网页，当页面调用 window.close() 方法时会触发 webViewDidClose 代理
//        openWebView = WKWebView(frame: view.bounds, configuration: configuration)
//        openWebView?.uiDelegate = self
//        openWebView?.navigationDelegate = self
//        view.addSubview(openWebView!)
//
//        return openWebView;
    }
    
    /// 当 js 调用 window.close() 方法时会触发该回调, 前提是 html 对应的页面是通过 window.open(url) 方式打开的
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        openWebView = nil
    }
    
    /// Alert Controller
    func show(panel: PanelType, prompt: String = "", text: String = "", completeHandle: ((_ text: String) -> Void)? = nil) {
        let controller = UIAlertController(title: panel.title, message: panel == .input ? prompt : text, preferredStyle: .alert)
        if panel == .input {
            controller.addTextField { textField in
                textField.placeholder = text
            }
        }
        
        let action = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let completeHandle = completeHandle {
                if let textField = controller.textFields?.first {
                    completeHandle(textField.text!)
                } else {
                    completeHandle("")
                }
            }
        })
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }

    enum PanelType {
           
        case alert
        case confirm
        case input
           
        var title: String {
            switch self {
               case .alert:
                   return "alert"
               case .confirm:
                   return "confirm"
               case .input:
                   return "input"
            }
        }
    }
}



