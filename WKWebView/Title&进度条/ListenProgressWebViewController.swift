//
//  ListenProgressWebViewController.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/12.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit
import WebKit

class ListenProgressWebViewController: UIViewController {

    private let url = "https://www.jianshu.com/"
    
    private var urlIndex = 0
    
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: ProgressView!
    
    
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
        
       
        let request = URLRequest(url: URL(string: url)!)
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

extension ListenProgressWebViewController: WKUIDelegate {
    
}

extension ListenProgressWebViewController: WKNavigationDelegate {
    
}
