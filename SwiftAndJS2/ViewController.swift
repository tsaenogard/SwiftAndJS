//
//  ViewController.swift
//  SwiftAndJS2
//
//  Created by Xcode on 2017/6/9.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {
    
    var webView: UIWebView!
    var context: JSContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.webView = UIWebView(frame: self.view.frame)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        self.view.addSubview(self.webView)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        let request = URLRequest(url: url!)
        self.webView.loadRequest(request)
    }



}

extension ViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //從js得到的code
        
        self.context = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as! JSContext
        
        let manager = SwiftJavaScriptManager()
        manager.target = self
        manager.jsContext = self.context
        //放入manager里
        //需要有Bridge連結兩種語言
        
        //let managerObject = unsafeBitCast(manager, to: AnyObject.self)
        context.setObject(manager, forKeyedSubscript: "WebViewJavascriptBridge"  as NSCopying & NSObjectProtocol)
        let url = Bundle.main.url(forResource: "demo", withExtension: "html")
        context.evaluateScript(try? String(contentsOf: url!, encoding: .utf8))
        
        
        context.exceptionHandler = { (context, exception) in print("exception: \(exception!)")
        }
    }
}

