//
//  MessageModel.swift
//  WKWebView
//
//  Created by 蔡志文 on 2019/11/13.
//  Copyright © 2019 蔡志文. All rights reserved.
//

import Foundation

struct Response: Codable {
    
    var funcName: String
    var alertInfo: AlertInfoModel
    
    enum CodingKeys: String, CodingKey {
        case funcName = "func_name"
        case alertInfo = "alert_info"
    }
    
}

struct AlertInfoModel: Codable {
    var title: String
    var content: String
}
