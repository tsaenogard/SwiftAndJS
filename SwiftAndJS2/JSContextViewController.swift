//
//  JSContextViewController.swift
//  SwiftAndJS2
//
//  Created by Eric Chen on 2017/7/30.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit
import JavaScriptCore

class JSContextViewController: UIViewController {
    var jsTextView: UITextView!
    var jsBtn: UIButton!
    var context = JSContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        //先寫入預設js
        let result1 = context?.evaluateScript("1 + 3")
        print(result1!)
        
        _ = context?.evaluateScript("var num1 = 10;")
        _ = context?.evaluateScript("var num2 = 20;")
        _ = context?.evaluateScript("function sum(parameter1, parameter2) {return parameter1 + parameter2}")
        
        let result2 = context?.evaluateScript("sum(num1, num2);")
        print(result2!)
        
        let jsFunction = context?.objectForKeyedSubscript("sum")
        let result3 = jsFunction?.call(withArguments: [99, 1]).toString()
        print(result3!)
        //建立textView供寫入js
        self.jsTextView = UITextView(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2))
        self.jsTextView.isSelectable = true
        self.jsTextView.isEditable = true
        self.jsTextView.autocapitalizationType = .none
        self.jsTextView.text = "請將js程式碼打於此處"
        self.view.addSubview(self.jsTextView)
        
        self.jsBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        self.jsBtn.center = CGPoint(x: UIScreen.main.bounds.midX, y: self.jsTextView.frame.maxY + 50)
        self.jsBtn.setTitle("SEND", for: .normal)
        self.jsBtn.setTitleColor(UIColor.white, for: .normal)
        self.jsBtn.backgroundColor = UIColor.blue
        self.jsBtn.layer.borderWidth = 1.0
        self.jsBtn.layer.borderColor = UIColor.black.cgColor
        self.jsBtn.addTarget(self, action: #selector(onBtnAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.jsBtn)

    }

    func onBtnAction(_ sender: UIButton) {
        let result4 = context?.evaluateScript(self.jsTextView.text)
        print(result4!)
    }
    

}
