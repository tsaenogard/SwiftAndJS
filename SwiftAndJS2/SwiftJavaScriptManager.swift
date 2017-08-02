//
//  SwiftJavaScriptManager.swift
//  SwiftAndJS2
//
//  Created by Xcode on 2017/6/9.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import JavaScriptCore

@objc protocol SwiftJavaScriptDelegate: JSExport {
    func pay(_ order: String)
    
    func share(_ dictionary: [String: AnyObject])
    
    func showDialog(_ title: String, message: String)
    //js完成呼叫alertDialog//要從js呼叫swift的程式需將變數放入呼叫函數裡如showDialogMessage
    
    func callHandler(_ functionName: String)
    //js呼叫swift內容
    
}

@objc class SwiftJavaScriptManager: NSObject, SwiftJavaScriptDelegate {
    weak var target: UIViewController?
    
    weak var jsContext: JSContext?
    
    func pay(_ order: String) {
        print("訂單編號:\(order)")
    }
    
    func share(_ dictionary: [String : AnyObject]) {
        print("分享訊息:\(dictionary)")
    }
    
    func showDialog(_ title: String, message: String) {
        guard let target = self.target else { return }
        Utilities.message.showAlertView(title: title, message: message, target: target, cancelHandler: nil) { (alert) in
            print("Hello world!")
        }

    }
    
    func callHandler(_ functionName: String) {
        //將js的function名字傳入
        guard let handler = self.jsContext?.objectForKeyedSubscript(functionName) else { return }
        //假裝從資料庫取得一些資訊，且經過一番比對及運算
        let dictionary: [String: Any] = ["name": "小強", "age": 18]
        handler.call(withArguments: [dictionary])
    }
    
    
    
    
    
    
    
}
