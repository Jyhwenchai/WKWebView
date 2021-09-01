//
//  NavigationDelegateWebViewController.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/14.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import UIKit
import WebKit

class NavigationDelegateWebViewController: UIViewController {

    private let url = "https://www.jianshu.com/"
    
    private var progressObservation: NSKeyValueObservation?
    private var titleObservation: NSKeyValueObservation?
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: ProgressView!
    
    private var openWebView: WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

extension NavigationDelegateWebViewController: WKNavigationDelegate {
    
    /// 请求导航一个地址时，决定是否允许（顺序： 1）
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        guard let url = navigationAction.request.url?.absoluteString else { return }
        if url.hasPrefix("tel:") {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else if url.hasPrefix("https") || url.hasPrefix("file") || url.hasPrefix("http") {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    /// 请求导航一个地址时，决定是否允许（顺序： 1）, （iOS13 新增， 如果使用该方法那么前面一个方法将失效）
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, preferences: WKWebpagePreferences, decisionHandler: @escaping (WKNavigationActionPolicy, WKWebpagePreferences) -> Void) {
        print(#function)
        guard let url = navigationAction.request.url?.absoluteString else { return }
        let preference = WKWebpagePreferences()
        if url.hasPrefix("tel:") {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
            decisionHandler(.cancel, preference)
        } else if url.hasPrefix("https") || url.hasPrefix("file") || url.hasPrefix("http") {
            decisionHandler(.allow, preference)
        } else {
            decisionHandler(.cancel, preference)
        }
        
    }
    
    /// 请求导航允许后是否允许继续响应还是取消导航请求，如果拒绝则不会加载页面内容并取消导航（顺序： 3）
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        guard let url = navigationResponse.response.url?.absoluteString else { return }
        if url.hasPrefix("https") || url.hasPrefix("file") || url.hasPrefix("http") {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    /// 开始加载页面内容（顺序： 4）
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    /// 在页面开始加载数据时执行（顺序： 2）
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
     /// 在页面开始加载数据时发生错误时调用（顺序： 2）
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    /// 页面加载完成执行（顺序： 5）
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    /// 页面加载失败执行（顺序： 5）
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    /// 网页内容处理中断时会执行
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
    
    // MARK: - Authentication
    /// 当主机服务器重定向时调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    /// 当 web 视图需要响应身份验证质询时调用
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print(#function)
        completionHandler(.performDefaultHandling, nil)
    }
    
}

/**:
 
 public enum AuthChallengeDisposition : Int {

    //使用具体的证书
    case useCredential
    
    //使用默认的操作,如同没有实现这个代理方法
    case performDefaultHandling

    //取消认证
    case cancelAuthenticationChallenge

    //拒绝认证, 但是会重新调用认证的代理方法
    case rejectProtectionSpace
  }
 
 */

// 参考: https://www.jianshu.com/p/1005ce8fec8e
