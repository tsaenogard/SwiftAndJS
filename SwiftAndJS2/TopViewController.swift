//
//  TopViewController.swift
//  SwiftAndJS2
//
//  Created by Eric Chen on 2017/7/30.
//  Copyright © 2017年 wtfcompany. All rights reserved.
//

import UIKit

enum buttonStyle: Int {
    case jsContext = 0
    case webview
    case Markdown
}

class TopViewController: UIViewController {
    var jsContextBtn: UIButton!
    var webviewBtn: UIButton!
    var MarkdownBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        jsContextBtn = UIButton(type: .roundedRect)
        jsContextBtn.setTitle("測試jsContext", for: .normal)
        jsContextBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        jsContextBtn.tag = buttonStyle.jsContext.rawValue
        jsContextBtn.addTarget(self, action: #selector(onButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.jsContextBtn)
        
        webviewBtn = UIButton(type: .roundedRect)
        webviewBtn.setTitle("測試webview", for: .normal)
        webviewBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        webviewBtn.tag = buttonStyle.webview.rawValue
        webviewBtn.addTarget(self, action: #selector(onButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.webviewBtn)
        
        MarkdownBtn = UIButton(type: .roundedRect)
        MarkdownBtn.setTitle("測試第三方js庫Papa Parse", for: .normal)
        MarkdownBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        MarkdownBtn.tag = buttonStyle.Markdown.rawValue
        MarkdownBtn.addTarget(self, action: #selector(onButtonAction(_:)), for: .touchUpInside)
        self.view.addSubview(self.MarkdownBtn)
    }

    override func viewDidAppear(_ animated: Bool) {
        
        let gap: CGFloat = 50
        jsContextBtn.frame = CGRect(x: 0, y: 0, width: 700, height: 50)
        jsContextBtn.center = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height / 4)
        
        webviewBtn.frame = CGRect(x: 0, y: 0, width: 700, height: 50)
        webviewBtn.center = CGPoint(x: UIScreen.main.bounds.midX, y: self.jsContextBtn.frame.maxY + gap)
        
        MarkdownBtn.frame = CGRect(x: 0, y: 0, width: 700, height: 50)
        MarkdownBtn.center = CGPoint(x: UIScreen.main.bounds.midX, y: self.webviewBtn.frame.maxY + gap)
    }
    
    func onButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case buttonStyle.jsContext.rawValue:
            print("jsContext")
            self.navigationController?.pushViewController(JSContextViewController(), animated: true)
        case buttonStyle.webview.rawValue:
            print("webview")
            self.navigationController?.pushViewController(ViewController(), animated: true)
        case buttonStyle.Markdown.rawValue:
            print("Markdown")
            self.navigationController?.pushViewController(DevicesViewController(), animated: true)
        default:
            break
        }
    }
    

}
