//
//  DeviceInfo.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore
//要加@objc才讀得到
@objc protocol DeviceInfoJSExport: JSExport {
    var model: String! {get set}
    var initialOS: String! {get set}
    var latestOS: String! {get set}
    var imageURL: String! {get set}
    
    static func initializeDevice(withModel: String) -> DeviceInfo
}


class DeviceInfo: NSObject, DeviceInfoJSExport {
    var model: String!
    var initialOS: String!
    var latestOS: String!
    var imageURL: String!
    
    init(withModel model: String) {
        super.init()
        self.model = model
    }
    //因為JavaScriptCore框架無法在 Swift 和 JavaScript 之間橋接初始化方法，因此不得不用 initializeDevice(withModel:) 方法來實例化一個新的 DeviceInfo 實例並返回這個對象
    class func initializeDevice(withModel: String) -> DeviceInfo {
        return DeviceInfo(withModel: withModel)
    }
    
    func concatOS() -> String {
        if let initial = initialOS {
            if let latest = latestOS {
                return initial + "-" + latest
            }
        }
        return ""
    }
}
