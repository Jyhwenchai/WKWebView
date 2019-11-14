//
//  StaticWebViewController.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/12.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit
import WebKit

class StaticWebViewController: UIViewController {

    private let urls = [
        "https://www.baidu.com/",
        "https://www.jianshu.com/",
        "https://www.163.com/"
    ]
    
    private var urlIndex = 0
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 代理
        webView.uiDelegate = self
        
        // 导航代理
        webView.navigationDelegate = self
        
        // 是否允许左滑返回上一级
        webView.allowsBackForwardNavigationGestures = true
        
        // 已打开网页列表
        let _ = webView.backForwardList
        
       
        openNewPage()
    
    }
    
    /// 返回之前页面
    @IBAction func previousAction(_ sender: Any) {
        webView.goBack()
    }
    
    /// 前进页面
    @IBAction func nextAction(_ sender: Any) {
        webView.goForward()
    }
    
    /// 重新加载页面
    @IBAction func reloadAction(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func openNewPageAction(_ sender: Any) {
        openNewPage()
    }
    
    func openNewPage() {
        // 请求加载一个新网页
        
        if urlIndex >= urls.count {
            urlIndex = 0
        }
        
        let request = URLRequest(url: URL(string: urls[urlIndex])!)
        webView.load(request)
        
        urlIndex += 1
    }
}

extension StaticWebViewController: WKUIDelegate {
    
}

extension StaticWebViewController: WKNavigationDelegate {
    
}
