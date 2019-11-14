//
//  JSInteractionWebViewController.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/13.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit
import WebKit

private let iosInteractionMainKey = "ios_interaction_main"
private let iosInteractionFuncKey = "ios_interaction_func"

class JSInteractionWebViewController: UIViewController {

    private let fileName = "/js_webview_interaction.html"
    
    private var urlIndex = 0
    
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: ProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 是否允许左滑返回上一级
        webView.allowsBackForwardNavigationGestures = true
        
        // 已打开网页列表
        let _ = webView.backForwardList
        
       
        let path = Bundle.main.bundlePath.appending(fileName)
        let requestURL = URL(fileURLWithPath: path)
        let request = URLRequest(url: requestURL)
        webView.load(request)
    
        
        updateConfigure()
        
        addObserver()

    }
    
    func updateConfigure() {
        let configuration = webView.configuration
        let contentController = configuration.userContentController
        contentController.add(self, name: iosInteractionMainKey)
        configuration.userContentController = contentController
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
 
    @IBAction func evaluateJsAction(_ sender: Any) {
        let jsString = """
                changeElementColorAndText("now, iOS webView call javaScript.");
            """
        
        webView.evaluateJavaScript(jsString) { (complete, error) in
            if let completeMessage = complete as? String {
                print(completeMessage)
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    deinit {
        self.progressObservation?.invalidate()
        self.titleObservation?.invalidate()
    }
}

extension JSInteractionWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == iosInteractionMainKey {
            let dict = message.body as! [String: Any]
            let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let body = try! JSONDecoder().decode(Response.self, from: data)
            if body.funcName == "showTip" {
                alert(with: body.alertInfo.title, content: body.alertInfo.content)
            }
        }
    }
    
    func alert(with title: String, content: String) {
        let controller = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
}
