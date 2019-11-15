//
//  WeakScriptMessageHandler.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/15.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import Foundation
import WebKit

class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler  {
    
    weak var delegate: WKScriptMessageHandler?
    
    init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.delegate?.userContentController(userContentController, didReceive: message)
    }
    
    deinit {
        print("WeakScriptMessageHandler deinit")
    }
}
