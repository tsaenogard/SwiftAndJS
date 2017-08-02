//
//  Utilities.swift
//  Toast
//
//  Created by smallHappy on 2017/4/6.
//  Copyright © 2017年 SmallHappy. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
//    private static let instance = Utilities()
//    static var sharedInstance: Utilities {
//        return self.instance
//    }
    
    // message
    static let message = Message()
    
    // flake
    static let flake = Flake()
    
    // UIDevice
    static let device = Device()
    
    // vector image
    static let vector = Vector()
}

//MARK: - message
extension Utilities {
    
    enum ToastLength: Double {
        case long = 3.5, short = 2.0
    }
    
    enum ToastStyle {
        case label, view
    }
    
    class Message {
        
        func showAlertView(title: String? = nil, message: String? = nil, target: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let confirmButton = UIAlertAction(title: "確認", style: .default, handler: handler)
            alert.addAction(confirmButton)
            DispatchQueue.main.async { target.present(alert, animated: true, completion: nil) }
        }
        
        func showAlertView(title: String? = nil, message: String? = nil, target: UIViewController, cancelHandler: ((UIAlertAction) -> Void)? = nil, confirmHandler: ((UIAlertAction) -> Void)? = nil) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "取消", style: .default, handler: cancelHandler)
            alert.addAction(cancelButton)
            let confirmButton = UIAlertAction(title: "確認", style: .default, handler: confirmHandler)
            alert.addAction(confirmButton)
            DispatchQueue.main.async { target.present(alert, animated: true, completion: nil) }
        }
        
        func toast(taget: UIViewController, style: ToastStyle = .view, message: String, length: ToastLength = .short) {
            let frameW = taget.view.frame.width
            let frameH = taget.view.frame.height
            let gap: CGFloat = 10
            let labelH: CGFloat = 21
            switch style {
            case .label:
                let label = UILabel(frame: CGRect(x: 0, y: frameH - labelH - gap, width: frameW, height: labelH))
                label.text = message
                label.textColor = UIColor.darkGray
                label.textAlignment = .center
                label.transform = CGAffineTransform(translationX: 0, y: labelH + gap)
                taget.view.addSubview(label)
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    label.transform = CGAffineTransform.identity
                }, completion: { (isFinish) in
                    UIView.animate(withDuration: length.rawValue, animations: {
                        label.alpha = 0.0
                    }, completion: { (isFinish) in
                        label.removeFromSuperview()
                    })
                })
            case .view:
                let viewH: CGFloat = labelH + gap * 2
                let _view = UIView(frame: CGRect(x: gap, y: frameH - viewH - gap, width: frameW - gap * 2, height: viewH))
                _view.backgroundColor = UIColor.black
                _view.alpha = 0.85
                _view.transform = CGAffineTransform(translationX: 0, y: viewH + gap)
                _view.layer.cornerRadius = 8.0
                taget.view.addSubview(_view)
                let label = UILabel(frame: CGRect(x: gap * 2, y: frameH - labelH - gap * 2, width: frameW - gap * 4, height: labelH))
                label.text = message
                label.textColor = UIColor.white
                label.textAlignment = .center
                label.transform = CGAffineTransform(translationX: 0, y: labelH + gap * 2)
                taget.view.addSubview(label)
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    _view.transform = CGAffineTransform.identity
                    label.transform = CGAffineTransform.identity
                }, completion: { (isFinish) in
                    UIView.animate(withDuration: length.rawValue, animations: {
                        _view.alpha = 0.0
                        label.alpha = 0.0
                    }, completion: { (isFinish) in
                        _view.removeFromSuperview()
                        label.removeFromSuperview()
                    })
                })
            }
        }
        
    }
    
    
    
}

//MARK: - flake
extension Utilities {
    
    class Flake {
        
        var timer: Timer?
        var target: UIViewController?
        
        func showSnow(target: UIViewController) {
            self.target = target
            self.timer = Timer.scheduledTimer(timeInterval: 1.75, target: self, selector: #selector(self.onTimerTick), userInfo: nil, repeats: true)
        }
        
        private func stopSnow() {
            self.target = nil
            self.timer?.invalidate()
        }
        
        @objc private func onTimerTick() {
            if self.target == nil { return }
            let frameW = self.target!.view.frame.width
            let frameH = self.target!.view.frame.height
            let flakeStartX = CGFloat(Int(arc4random()) % Int(frameW)) // 0.0~frameW
            let flakeEndX = CGFloat(Int(arc4random()) % Int(frameW)) // 0.0~frameW
            var flakeS = CGFloat(Int(arc4random()) % 100) / 100.0 // 0.0~1.0
            flakeS += 0.7 // 0.7~1.7
            flakeS *= 20.0 // 14~34
            
//            let flakeImageView = UIImageView(image: UIImage(named: "flake"))
            let flakeImageView = UIImageView(image: Utilities.vector.image(picture: .snowflate, color: UIColor.white))
            flakeImageView.frame = CGRect(x: flakeStartX, y: -40.0, width: flakeS, height: flakeS)
            flakeImageView.alpha = 0.4
            self.target!.view.addSubview(flakeImageView)
            
            var speed = Double(Int(arc4random()) % 100) / 100.0 // 0.0~1.0
            speed += 1.0 // 1.0~2.0
            speed *= 15.0 // 5.0~10.0
            
            UIView.animate(withDuration: speed, animations: {
                UIView.setAnimationCurve(.easeOut)
                flakeImageView.frame.origin = CGPoint(x: flakeEndX, y: frameH - 20)
            }) { (isFinish) in
                UIView.animate(withDuration: 2.5, animations: {
                    flakeImageView.alpha = 0.0
                }, completion: { (isFinish) in
                    flakeImageView.removeFromSuperview()
                })
            }
        }
        
    }
    
}

//MARK: - UIDevice
extension Utilities {
    
    class Device {
        
        var uuid: String {
            // device + app => Unique Device Identifier(設備唯一標識符)
            return UIDevice.current.identifierForVendor!.uuidString
        }
        
        var systemName: String {
            // 作業系統名稱
            return UIDevice.current.systemName
        }
        
        var systemVersion: String {
            // 作業系統版本
            return UIDevice.current.systemVersion
        }
        
        var bundleShortVersion: String {
            return (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String) ?? ""
        }
        
        var name: String {
            // 例如：某某某的iphone
            return UIDevice.current.name
        }
        
        var model: String {
            // 型號
            return UIDevice.current.model
        }
        
        var localizedModel: String {
            return UIDevice.current.localizedModel
        }
        
        var orientation: String {
            switch UIDevice.current.orientation {
            case .faceUp:
                return "faceUp"
            case .faceDown:
                return "faceDown"
            case .landscapeLeft:
                return "landscapeLeft"
            case .landscapeRight:
                return "landscapeRight"
            case .portrait:
                return "portrait"
            case .portraitUpsideDown:
                return "portraitUpsideDown"
            case .unknown:
                return "unknown"
            }
        }
        
        var userInterfaceIdiom: String {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone:
                return "phone"
            case .pad:
                return "pad"
            case .tv:
                return "tv"
            case .carPlay:
                return "carPlay"
            case .unspecified:
                return "unspecified"
            }
        }
        
        var batteryState: String {
            UIDevice.current.isBatteryMonitoringEnabled = true
            if !UIDevice.current.isBatteryMonitoringEnabled {
                return "Battery monitoring is not Enabled."
            }
            switch UIDevice.current.batteryState {
            case .unknown:
                return "unknown"
            case .unplugged:
                return "unplugged"
            case .charging:
                return "charging"
            case .full:
                return "full"
            }
        }
        
        var batteryLevel: Float {
            UIDevice.current.isBatteryMonitoringEnabled = true
            return UIDevice.current.batteryLevel
        }
        
        var proximityState: Bool? {
            UIDevice.current.isProximityMonitoringEnabled = true
            if !UIDevice.current.isProximityMonitoringEnabled {
                return nil
            }
            return UIDevice.current.proximityState
        }
        
        var multitaskingSupported: Bool {
            return UIDevice.current.isMultitaskingSupported
        }
        
    }
    
}

//MARK: - vector image
extension Utilities {
    
    class Vector {
        
        enum Picture {
            case snowflate
        }
        
        func image(picture: Picture, color: UIColor) -> UIImage? {
            switch picture {
            case .snowflate:
                UIGraphicsBeginImageContextWithOptions(CGSize(width: 1024, height: 1024), false, 1.0)
                self.drawSonwflake(color)
                return UIGraphicsGetImageFromCurrentImageContext()
            }
        }
        
        private func drawSonwflake(_ color: UIColor) {
            //// Color Declarations
            let fillColor = color
            
            //// flake Group
            //// Bezier Drawing
            let bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: 502.74, y: 401.08))
            bezierPath.addCurve(to: CGPoint(x: 424.65, y: 440.54), controlPoint1: CGPoint(x: 476.71, y: 414.24), controlPoint2: CGPoint(x: 450.68, y: 427.39))
            bezierPath.addCurve(to: CGPoint(x: 397.8, y: 463.58), controlPoint1: CGPoint(x: 414.19, y: 445.83), controlPoint2: CGPoint(x: 397.8, y: 451.04))
            bezierPath.addLine(to: CGPoint(x: 397.8, y: 496.24))
            bezierPath.addLine(to: CGPoint(x: 397.8, y: 545.49))
            bezierPath.addCurve(to: CGPoint(x: 407.77, y: 574.51), controlPoint1: CGPoint(x: 397.8, y: 555.99), controlPoint2: CGPoint(x: 395.46, y: 568.29))
            bezierPath.addCurve(to: CGPoint(x: 491.12, y: 616.62), controlPoint1: CGPoint(x: 435.55, y: 588.55), controlPoint2: CGPoint(x: 463.34, y: 602.58))
            bezierPath.addCurve(to: CGPoint(x: 502.74, y: 622.49), controlPoint1: CGPoint(x: 494.99, y: 618.58), controlPoint2: CGPoint(x: 498.87, y: 620.54))
            bezierPath.addCurve(to: CGPoint(x: 521.17, y: 622.49), controlPoint1: CGPoint(x: 508.43, y: 625.37), controlPoint2: CGPoint(x: 515.48, y: 625.37))
            bezierPath.addCurve(to: CGPoint(x: 617.07, y: 574.04), controlPoint1: CGPoint(x: 553.14, y: 606.34), controlPoint2: CGPoint(x: 585.11, y: 590.19))
            bezierPath.addCurve(to: CGPoint(x: 625.45, y: 564.71), controlPoint1: CGPoint(x: 621.82, y: 571.64), controlPoint2: CGPoint(x: 624.44, y: 568.3))
            bezierPath.addCurve(to: CGPoint(x: 626.11, y: 560.24), controlPoint1: CGPoint(x: 625.87, y: 563.35), controlPoint2: CGPoint(x: 626.11, y: 561.87))
            bezierPath.addLine(to: CGPoint(x: 626.11, y: 510.74))
            bezierPath.addLine(to: CGPoint(x: 626.11, y: 476.55))
            bezierPath.addCurve(to: CGPoint(x: 623.62, y: 455.27), controlPoint1: CGPoint(x: 626.11, y: 470.02), controlPoint2: CGPoint(x: 627.55, y: 461.14))
            bezierPath.addCurve(to: CGPoint(x: 605.45, y: 443.67), controlPoint1: CGPoint(x: 619.93, y: 449.75), controlPoint2: CGPoint(x: 611.53, y: 446.74))
            bezierPath.addCurve(to: CGPoint(x: 572.24, y: 426.89), controlPoint1: CGPoint(x: 594.38, y: 438.07), controlPoint2: CGPoint(x: 583.31, y: 432.48))
            bezierPath.addCurve(to: CGPoint(x: 521.17, y: 401.08), controlPoint1: CGPoint(x: 555.22, y: 418.29), controlPoint2: CGPoint(x: 538.19, y: 409.69))
            bezierPath.addCurve(to: CGPoint(x: 502.74, y: 401.08), controlPoint1: CGPoint(x: 515.48, y: 398.21), controlPoint2: CGPoint(x: 508.43, y: 398.21))
            bezierPath.close()
            fillColor.setFill()
            bezierPath.fill()
            
            
            //// Bezier 2 Drawing
            let bezier2Path = UIBezierPath()
            bezier2Path.move(to: CGPoint(x: 786.37, y: 632.79))
            bezier2Path.addCurve(to: CGPoint(x: 786.78, y: 627.81), controlPoint1: CGPoint(x: 786.62, y: 631.18), controlPoint2: CGPoint(x: 786.78, y: 629.53))
            bezier2Path.addCurve(to: CGPoint(x: 786.37, y: 632.79), controlPoint1: CGPoint(x: 786.78, y: 629.53), controlPoint2: CGPoint(x: 786.62, y: 631.18))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 783.36, y: 642.16))
            bezier2Path.addCurve(to: CGPoint(x: 784.72, y: 639.05), controlPoint1: CGPoint(x: 783.86, y: 641.15), controlPoint2: CGPoint(x: 784.32, y: 640.11))
            bezier2Path.addCurve(to: CGPoint(x: 783.36, y: 642.16), controlPoint1: CGPoint(x: 784.32, y: 640.11), controlPoint2: CGPoint(x: 783.86, y: 641.15))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 780.28, y: 647.32))
            bezier2Path.addCurve(to: CGPoint(x: 782.78, y: 643.35), controlPoint1: CGPoint(x: 781.2, y: 646.04), controlPoint2: CGPoint(x: 782.03, y: 644.71))
            bezier2Path.addCurve(to: CGPoint(x: 780.28, y: 647.32), controlPoint1: CGPoint(x: 782.03, y: 644.71), controlPoint2: CGPoint(x: 781.2, y: 646.04))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 777.21, y: 651.04))
            bezier2Path.addCurve(to: CGPoint(x: 779.82, y: 647.88), controlPoint1: CGPoint(x: 778.14, y: 650.03), controlPoint2: CGPoint(x: 779.01, y: 648.97))
            bezier2Path.addCurve(to: CGPoint(x: 777.21, y: 651.04), controlPoint1: CGPoint(x: 779.01, y: 648.97), controlPoint2: CGPoint(x: 778.14, y: 650.03))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 773.65, y: 654.59))
            bezier2Path.addCurve(to: CGPoint(x: 776.09, y: 652.22), controlPoint1: CGPoint(x: 774.49, y: 653.82), controlPoint2: CGPoint(x: 775.3, y: 653.03))
            bezier2Path.addCurve(to: CGPoint(x: 773.65, y: 654.59), controlPoint1: CGPoint(x: 775.3, y: 653.03), controlPoint2: CGPoint(x: 774.49, y: 653.82))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 785.24, y: 637.52))
            bezier2Path.addCurve(to: CGPoint(x: 786.07, y: 634.26), controlPoint1: CGPoint(x: 785.58, y: 636.46), controlPoint2: CGPoint(x: 785.85, y: 635.37))
            bezier2Path.addCurve(to: CGPoint(x: 785.24, y: 637.52), controlPoint1: CGPoint(x: 785.85, y: 635.37), controlPoint2: CGPoint(x: 785.58, y: 636.46))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 764.14, y: 661.9))
            bezier2Path.addCurve(to: CGPoint(x: 768.35, y: 658.97), controlPoint1: CGPoint(x: 765.58, y: 660.95), controlPoint2: CGPoint(x: 766.99, y: 659.97))
            bezier2Path.addCurve(to: CGPoint(x: 764.14, y: 661.9), controlPoint1: CGPoint(x: 766.99, y: 659.97), controlPoint2: CGPoint(x: 765.58, y: 660.95))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 769.45, y: 658.1))
            bezier2Path.addCurve(to: CGPoint(x: 772.35, y: 655.75), controlPoint1: CGPoint(x: 770.45, y: 657.34), controlPoint2: CGPoint(x: 771.42, y: 656.55))
            bezier2Path.addCurve(to: CGPoint(x: 769.45, y: 658.1), controlPoint1: CGPoint(x: 771.42, y: 656.55), controlPoint2: CGPoint(x: 770.45, y: 657.34))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 752.78, y: 668.52))
            bezier2Path.addCurve(to: CGPoint(x: 749.88, y: 670.01), controlPoint1: CGPoint(x: 751.81, y: 669.02), controlPoint2: CGPoint(x: 750.85, y: 669.52))
            bezier2Path.addCurve(to: CGPoint(x: 752.78, y: 668.52), controlPoint1: CGPoint(x: 750.85, y: 669.52), controlPoint2: CGPoint(x: 751.81, y: 669.02))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 757.68, y: 665.83))
            bezier2Path.addCurve(to: CGPoint(x: 754.84, y: 667.41), controlPoint1: CGPoint(x: 756.74, y: 666.36), controlPoint2: CGPoint(x: 755.79, y: 666.89))
            bezier2Path.addCurve(to: CGPoint(x: 757.68, y: 665.83), controlPoint1: CGPoint(x: 755.79, y: 666.89), controlPoint2: CGPoint(x: 756.74, y: 666.36))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 762.79, y: 662.76))
            bezier2Path.addCurve(to: CGPoint(x: 759.59, y: 664.72), controlPoint1: CGPoint(x: 761.74, y: 663.42), controlPoint2: CGPoint(x: 760.68, y: 664.08))
            bezier2Path.addCurve(to: CGPoint(x: 762.79, y: 662.76), controlPoint1: CGPoint(x: 760.68, y: 664.08), controlPoint2: CGPoint(x: 761.74, y: 663.42))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 745.37, y: 672.24))
            bezier2Path.addCurve(to: CGPoint(x: 743.57, y: 673.11), controlPoint1: CGPoint(x: 744.77, y: 672.53), controlPoint2: CGPoint(x: 744.17, y: 672.83))
            bezier2Path.addCurve(to: CGPoint(x: 745.37, y: 672.24), controlPoint1: CGPoint(x: 744.17, y: 672.83), controlPoint2: CGPoint(x: 744.77, y: 672.53))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 771.84, y: 366.77))
            bezier2Path.addCurve(to: CGPoint(x: 769.05, y: 364.69), controlPoint1: CGPoint(x: 770.97, y: 366.05), controlPoint2: CGPoint(x: 770.02, y: 365.36))
            bezier2Path.addCurve(to: CGPoint(x: 771.84, y: 366.77), controlPoint1: CGPoint(x: 770.02, y: 365.36), controlPoint2: CGPoint(x: 770.97, y: 366.05))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 775.4, y: 370.13))
            bezier2Path.addCurve(to: CGPoint(x: 773.26, y: 368.05), controlPoint1: CGPoint(x: 774.73, y: 369.41), controlPoint2: CGPoint(x: 774.01, y: 368.73))
            bezier2Path.addCurve(to: CGPoint(x: 775.4, y: 370.13), controlPoint1: CGPoint(x: 774.01, y: 368.73), controlPoint2: CGPoint(x: 774.73, y: 369.41))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 778.4, y: 373.74))
            bezier2Path.addCurve(to: CGPoint(x: 776.67, y: 371.55), controlPoint1: CGPoint(x: 777.86, y: 372.99), controlPoint2: CGPoint(x: 777.28, y: 372.27))
            bezier2Path.addCurve(to: CGPoint(x: 778.4, y: 373.74), controlPoint1: CGPoint(x: 777.28, y: 372.27), controlPoint2: CGPoint(x: 777.86, y: 372.99))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 780.88, y: 377.61))
            bezier2Path.addCurve(to: CGPoint(x: 779.46, y: 375.24), controlPoint1: CGPoint(x: 780.43, y: 376.81), controlPoint2: CGPoint(x: 779.96, y: 376.02))
            bezier2Path.addCurve(to: CGPoint(x: 780.88, y: 377.61), controlPoint1: CGPoint(x: 779.96, y: 376.02), controlPoint2: CGPoint(x: 780.43, y: 376.81))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 782.93, y: 381.83))
            bezier2Path.addCurve(to: CGPoint(x: 781.7, y: 379.11), controlPoint1: CGPoint(x: 782.54, y: 380.91), controlPoint2: CGPoint(x: 782.15, y: 380))
            bezier2Path.addCurve(to: CGPoint(x: 782.93, y: 381.83), controlPoint1: CGPoint(x: 782.15, y: 380), controlPoint2: CGPoint(x: 782.54, y: 380.91))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 784.82, y: 387.25))
            bezier2Path.addCurve(to: CGPoint(x: 783.48, y: 383.15), controlPoint1: CGPoint(x: 784.44, y: 385.86), controlPoint2: CGPoint(x: 783.99, y: 384.49))
            bezier2Path.addCurve(to: CGPoint(x: 784.82, y: 387.25), controlPoint1: CGPoint(x: 783.99, y: 384.49), controlPoint2: CGPoint(x: 784.44, y: 385.86))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 785.83, y: 391.66))
            bezier2Path.addCurve(to: CGPoint(x: 784.85, y: 387.33), controlPoint1: CGPoint(x: 785.56, y: 390.2), controlPoint2: CGPoint(x: 785.23, y: 388.75))
            bezier2Path.addCurve(to: CGPoint(x: 785.83, y: 391.66), controlPoint1: CGPoint(x: 785.23, y: 388.75), controlPoint2: CGPoint(x: 785.56, y: 390.2))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 786.51, y: 396.13))
            bezier2Path.addCurve(to: CGPoint(x: 786.08, y: 393.18), controlPoint1: CGPoint(x: 786.4, y: 395.14), controlPoint2: CGPoint(x: 786.23, y: 394.15))
            bezier2Path.addCurve(to: CGPoint(x: 786.51, y: 396.13), controlPoint1: CGPoint(x: 786.23, y: 394.15), controlPoint2: CGPoint(x: 786.4, y: 395.14))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 787.04, y: 402.6))
            bezier2Path.addCurve(to: CGPoint(x: 787.14, y: 405.34), controlPoint1: CGPoint(x: 787.09, y: 403.51), controlPoint2: CGPoint(x: 787.12, y: 404.42))
            bezier2Path.addCurve(to: CGPoint(x: 787.04, y: 402.6), controlPoint1: CGPoint(x: 787.12, y: 404.42), controlPoint2: CGPoint(x: 787.09, y: 403.51))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 787.2, y: 410.11))
            bezier2Path.addCurve(to: CGPoint(x: 787.18, y: 407.24), controlPoint1: CGPoint(x: 787.2, y: 409.16), controlPoint2: CGPoint(x: 787.2, y: 408.2))
            bezier2Path.addCurve(to: CGPoint(x: 787.2, y: 410.11), controlPoint1: CGPoint(x: 787.2, y: 408.2), controlPoint2: CGPoint(x: 787.2, y: 409.16))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 787.13, y: 415.01))
            bezier2Path.addCurve(to: CGPoint(x: 787.18, y: 411.92), controlPoint1: CGPoint(x: 787.15, y: 413.98), controlPoint2: CGPoint(x: 787.17, y: 412.95))
            bezier2Path.addCurve(to: CGPoint(x: 787.13, y: 415.01), controlPoint1: CGPoint(x: 787.17, y: 412.95), controlPoint2: CGPoint(x: 787.15, y: 413.98))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 786.97, y: 420.65))
            bezier2Path.addCurve(to: CGPoint(x: 787.09, y: 416.61), controlPoint1: CGPoint(x: 787.02, y: 419.31), controlPoint2: CGPoint(x: 787.06, y: 417.96))
            bezier2Path.addCurve(to: CGPoint(x: 786.97, y: 420.65), controlPoint1: CGPoint(x: 787.06, y: 417.96), controlPoint2: CGPoint(x: 787.02, y: 419.31))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 786.7, y: 397.93))
            bezier2Path.addCurve(to: CGPoint(x: 786.93, y: 400.69), controlPoint1: CGPoint(x: 786.79, y: 398.84), controlPoint2: CGPoint(x: 786.87, y: 399.76))
            bezier2Path.addCurve(to: CGPoint(x: 786.7, y: 397.93), controlPoint1: CGPoint(x: 786.87, y: 399.76), controlPoint2: CGPoint(x: 786.79, y: 398.84))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 698.93, y: 606.18))
            bezier2Path.addCurve(to: CGPoint(x: 512.09, y: 700.58), controlPoint1: CGPoint(x: 636.65, y: 637.65), controlPoint2: CGPoint(x: 574.38, y: 669.12))
            bezier2Path.addCurve(to: CGPoint(x: 325.26, y: 606.18), controlPoint1: CGPoint(x: 449.82, y: 669.12), controlPoint2: CGPoint(x: 387.53, y: 637.65))
            bezier2Path.addLine(to: CGPoint(x: 325.26, y: 417.4))
            bezier2Path.addCurve(to: CGPoint(x: 512.09, y: 323), controlPoint1: CGPoint(x: 387.53, y: 385.93), controlPoint2: CGPoint(x: 449.82, y: 354.46))
            bezier2Path.addCurve(to: CGPoint(x: 698.93, y: 417.4), controlPoint1: CGPoint(x: 574.38, y: 354.46), controlPoint2: CGPoint(x: 636.65, y: 385.93))
            bezier2Path.addLine(to: CGPoint(x: 698.93, y: 606.18))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 264.26, y: 664.55))
            bezier2Path.addCurve(to: CGPoint(x: 269.13, y: 667.08), controlPoint1: CGPoint(x: 265.87, y: 665.41), controlPoint2: CGPoint(x: 267.49, y: 666.27))
            bezier2Path.addCurve(to: CGPoint(x: 264.26, y: 664.55), controlPoint1: CGPoint(x: 267.49, y: 666.27), controlPoint2: CGPoint(x: 265.87, y: 665.41))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 269.46, y: 667.25))
            bezier2Path.addCurve(to: CGPoint(x: 284.8, y: 674.57), controlPoint1: CGPoint(x: 274.7, y: 669.84), controlPoint2: CGPoint(x: 279.97, y: 672.22))
            bezier2Path.addCurve(to: CGPoint(x: 269.46, y: 667.25), controlPoint1: CGPoint(x: 279.98, y: 672.22), controlPoint2: CGPoint(x: 274.69, y: 669.83))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 257.02, y: 660.32))
            bezier2Path.addCurve(to: CGPoint(x: 253.44, y: 657.78), controlPoint1: CGPoint(x: 255.78, y: 659.51), controlPoint2: CGPoint(x: 254.61, y: 658.65))
            bezier2Path.addCurve(to: CGPoint(x: 257.02, y: 660.32), controlPoint1: CGPoint(x: 254.61, y: 658.65), controlPoint2: CGPoint(x: 255.78, y: 659.51))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 262.83, y: 663.79))
            bezier2Path.addCurve(to: CGPoint(x: 258.75, y: 661.37), controlPoint1: CGPoint(x: 261.43, y: 663.01), controlPoint2: CGPoint(x: 260.09, y: 662.19))
            bezier2Path.addCurve(to: CGPoint(x: 262.83, y: 663.79), controlPoint1: CGPoint(x: 260.09, y: 662.19), controlPoint2: CGPoint(x: 261.43, y: 663.01))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 248.51, y: 653.65))
            bezier2Path.addCurve(to: CGPoint(x: 251.74, y: 656.54), controlPoint1: CGPoint(x: 249.56, y: 654.63), controlPoint2: CGPoint(x: 250.59, y: 655.62))
            bezier2Path.addCurve(to: CGPoint(x: 248.51, y: 653.65), controlPoint1: CGPoint(x: 250.59, y: 655.62), controlPoint2: CGPoint(x: 249.56, y: 654.63))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 240.59, y: 642.47))
            bezier2Path.addCurve(to: CGPoint(x: 243.4, y: 647.78), controlPoint1: CGPoint(x: 241.37, y: 644.32), controlPoint2: CGPoint(x: 242.28, y: 646.11))
            bezier2Path.addCurve(to: CGPoint(x: 247.15, y: 652.39), controlPoint1: CGPoint(x: 244.49, y: 649.4), controlPoint2: CGPoint(x: 245.75, y: 650.93))
            bezier2Path.addCurve(to: CGPoint(x: 243.4, y: 647.78), controlPoint1: CGPoint(x: 245.76, y: 650.93), controlPoint2: CGPoint(x: 244.49, y: 649.4))
            bezier2Path.addCurve(to: CGPoint(x: 240.59, y: 642.47), controlPoint1: CGPoint(x: 242.28, y: 646.11), controlPoint2: CGPoint(x: 241.37, y: 644.32))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 239.91, y: 640.55))
            bezier2Path.addCurve(to: CGPoint(x: 238.68, y: 636.66), controlPoint1: CGPoint(x: 239.46, y: 639.28), controlPoint2: CGPoint(x: 239.01, y: 637.99))
            bezier2Path.addCurve(to: CGPoint(x: 239.91, y: 640.55), controlPoint1: CGPoint(x: 239.01, y: 637.99), controlPoint2: CGPoint(x: 239.46, y: 639.28))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 237.51, y: 630.48))
            bezier2Path.addCurve(to: CGPoint(x: 238.18, y: 634.29), controlPoint1: CGPoint(x: 237.69, y: 631.77), controlPoint2: CGPoint(x: 237.92, y: 633.04))
            bezier2Path.addCurve(to: CGPoint(x: 237.51, y: 630.48), controlPoint1: CGPoint(x: 237.92, y: 633.03), controlPoint2: CGPoint(x: 237.69, y: 631.77))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 237.23, y: 627.93))
            bezier2Path.addCurve(to: CGPoint(x: 236.95, y: 624.02), controlPoint1: CGPoint(x: 237.11, y: 626.63), controlPoint2: CGPoint(x: 237.01, y: 625.33))
            bezier2Path.addCurve(to: CGPoint(x: 237.23, y: 627.93), controlPoint1: CGPoint(x: 237.01, y: 625.33), controlPoint2: CGPoint(x: 237.11, y: 626.63))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 236.82, y: 617.31))
            bezier2Path.addCurve(to: CGPoint(x: 236.85, y: 621.48), controlPoint1: CGPoint(x: 236.81, y: 618.7), controlPoint2: CGPoint(x: 236.81, y: 620.09))
            bezier2Path.addCurve(to: CGPoint(x: 236.82, y: 617.31), controlPoint1: CGPoint(x: 236.81, y: 620.08), controlPoint2: CGPoint(x: 236.81, y: 618.7))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 236.99, y: 609.98))
            bezier2Path.addCurve(to: CGPoint(x: 236.84, y: 615), controlPoint1: CGPoint(x: 236.92, y: 611.64), controlPoint2: CGPoint(x: 236.87, y: 613.32))
            bezier2Path.addCurve(to: CGPoint(x: 236.99, y: 609.98), controlPoint1: CGPoint(x: 236.87, y: 613.32), controlPoint2: CGPoint(x: 236.92, y: 611.65))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 237.28, y: 602.57))
            bezier2Path.addCurve(to: CGPoint(x: 237.04, y: 608.62), controlPoint1: CGPoint(x: 237.21, y: 604.53), controlPoint2: CGPoint(x: 237.12, y: 606.56))
            bezier2Path.addCurve(to: CGPoint(x: 237.28, y: 602.57), controlPoint1: CGPoint(x: 237.12, y: 606.56), controlPoint2: CGPoint(x: 237.21, y: 604.53))
            bezier2Path.close()
            bezier2Path.move(to: CGPoint(x: 1003.36, y: 718.38))
            bezier2Path.addLine(to: CGPoint(x: 879.16, y: 655.62))
            bezier2Path.addLine(to: CGPoint(x: 982.32, y: 631.44))
            bezier2Path.addCurve(to: CGPoint(x: 1011.48, y: 587.23), controlPoint1: CGPoint(x: 1004.32, y: 626.28), controlPoint2: CGPoint(x: 1017.38, y: 606.48))
            bezier2Path.addCurve(to: CGPoint(x: 960.96, y: 561.7), controlPoint1: CGPoint(x: 1005.59, y: 567.97), controlPoint2: CGPoint(x: 982.97, y: 556.55))
            bezier2Path.addLine(to: CGPoint(x: 786.78, y: 602.55))
            bezier2Path.addLine(to: CGPoint(x: 786.78, y: 549.21))
            bezier2Path.addLine(to: CGPoint(x: 786.78, y: 430.69))
            bezier2Path.addCurve(to: CGPoint(x: 786.97, y: 421.07), controlPoint1: CGPoint(x: 786.78, y: 427.53), controlPoint2: CGPoint(x: 786.86, y: 424.32))
            bezier2Path.addLine(to: CGPoint(x: 960.96, y: 461.87))
            bezier2Path.addCurve(to: CGPoint(x: 1011.48, y: 436.35), controlPoint1: CGPoint(x: 982.97, y: 467.03), controlPoint2: CGPoint(x: 1005.59, y: 455.6))
            bezier2Path.addCurve(to: CGPoint(x: 982.32, y: 392.14), controlPoint1: CGPoint(x: 1017.38, y: 417.09), controlPoint2: CGPoint(x: 1004.32, y: 397.31))
            bezier2Path.addLine(to: CGPoint(x: 879.16, y: 367.95))
            bezier2Path.addLine(to: CGPoint(x: 1003.36, y: 305.2))
            bezier2Path.addCurve(to: CGPoint(x: 1018.47, y: 255.89), controlPoint1: CGPoint(x: 1023.09, y: 295.23), controlPoint2: CGPoint(x: 1029.85, y: 273.15))
            bezier2Path.addCurve(to: CGPoint(x: 962.12, y: 242.68), controlPoint1: CGPoint(x: 1007.07, y: 238.63), controlPoint2: CGPoint(x: 981.85, y: 232.72))
            bezier2Path.addLine(to: CGPoint(x: 837.92, y: 305.44))
            bezier2Path.addLine(to: CGPoint(x: 865.56, y: 215.16))
            bezier2Path.addCurve(to: CGPoint(x: 836.39, y: 170.96), controlPoint1: CGPoint(x: 871.45, y: 195.91), controlPoint2: CGPoint(x: 858.4, y: 176.12))
            bezier2Path.addCurve(to: CGPoint(x: 785.88, y: 196.48), controlPoint1: CGPoint(x: 814.39, y: 165.8), controlPoint2: CGPoint(x: 791.77, y: 177.22))
            bezier2Path.addLine(to: CGPoint(x: 739.2, y: 348.95))
            bezier2Path.addCurve(to: CGPoint(x: 762.79, y: 360.87), controlPoint1: CGPoint(x: 747.06, y: 352.92), controlPoint2: CGPoint(x: 754.92, y: 356.9))
            bezier2Path.addCurve(to: CGPoint(x: 767.65, y: 363.68), controlPoint1: CGPoint(x: 764.54, y: 361.76), controlPoint2: CGPoint(x: 766.14, y: 362.7))
            bezier2Path.addCurve(to: CGPoint(x: 762.79, y: 360.87), controlPoint1: CGPoint(x: 766.14, y: 362.7), controlPoint2: CGPoint(x: 764.54, y: 361.76))
            bezier2Path.addCurve(to: CGPoint(x: 562.23, y: 259.54), controlPoint1: CGPoint(x: 695.94, y: 327.1), controlPoint2: CGPoint(x: 629.09, y: 293.32))
            bezier2Path.addCurve(to: CGPoint(x: 534.26, y: 245.41), controlPoint1: CGPoint(x: 552.91, y: 254.83), controlPoint2: CGPoint(x: 543.59, y: 250.12))
            bezier2Path.addCurve(to: CGPoint(x: 559.54, y: 258.18), controlPoint1: CGPoint(x: 542.69, y: 249.67), controlPoint2: CGPoint(x: 551.12, y: 253.92))
            bezier2Path.addLine(to: CGPoint(x: 687.08, y: 146.56))
            bezier2Path.addCurve(to: CGPoint(x: 687.08, y: 95.52), controlPoint1: CGPoint(x: 703.19, y: 132.46), controlPoint2: CGPoint(x: 703.19, y: 109.61))
            bezier2Path.addCurve(to: CGPoint(x: 628.76, y: 95.52), controlPoint1: CGPoint(x: 670.98, y: 81.42), controlPoint2: CGPoint(x: 644.86, y: 81.42))
            bezier2Path.addLine(to: CGPoint(x: 553.24, y: 161.6))
            bezier2Path.addLine(to: CGPoint(x: 553.24, y: 36.09))
            bezier2Path.addCurve(to: CGPoint(x: 512, y: 0), controlPoint1: CGPoint(x: 553.24, y: 16.16), controlPoint2: CGPoint(x: 534.78, y: 0))
            bezier2Path.addCurve(to: CGPoint(x: 470.75, y: 36.09), controlPoint1: CGPoint(x: 489.22, y: 0), controlPoint2: CGPoint(x: 470.75, y: 16.16))
            bezier2Path.addLine(to: CGPoint(x: 470.75, y: 161.6))
            bezier2Path.addLine(to: CGPoint(x: 395.24, y: 95.52))
            bezier2Path.addCurve(to: CGPoint(x: 336.91, y: 95.52), controlPoint1: CGPoint(x: 379.13, y: 81.42), controlPoint2: CGPoint(x: 353.01, y: 81.42))
            bezier2Path.addCurve(to: CGPoint(x: 336.91, y: 146.56), controlPoint1: CGPoint(x: 320.8, y: 109.61), controlPoint2: CGPoint(x: 320.8, y: 132.46))
            bezier2Path.addLine(to: CGPoint(x: 464.53, y: 258.24))
            bezier2Path.addCurve(to: CGPoint(x: 489.93, y: 245.41), controlPoint1: CGPoint(x: 472.99, y: 253.96), controlPoint2: CGPoint(x: 481.46, y: 249.68))
            bezier2Path.addCurve(to: CGPoint(x: 284.82, y: 349.03), controlPoint1: CGPoint(x: 421.55, y: 279.95), controlPoint2: CGPoint(x: 353.19, y: 314.49))
            bezier2Path.addLine(to: CGPoint(x: 238.11, y: 196.48))
            bezier2Path.addCurve(to: CGPoint(x: 187.6, y: 170.96), controlPoint1: CGPoint(x: 232.22, y: 177.22), controlPoint2: CGPoint(x: 209.6, y: 165.8))
            bezier2Path.addCurve(to: CGPoint(x: 158.44, y: 215.16), controlPoint1: CGPoint(x: 165.6, y: 176.11), controlPoint2: CGPoint(x: 152.54, y: 195.91))
            bezier2Path.addLine(to: CGPoint(x: 186.08, y: 305.44))
            bezier2Path.addLine(to: CGPoint(x: 61.87, y: 242.68))
            bezier2Path.addCurve(to: CGPoint(x: 5.53, y: 255.89), controlPoint1: CGPoint(x: 42.14, y: 232.72), controlPoint2: CGPoint(x: 16.92, y: 238.63))
            bezier2Path.addCurve(to: CGPoint(x: 20.63, y: 305.2), controlPoint1: CGPoint(x: -5.86, y: 273.15), controlPoint2: CGPoint(x: 0.9, y: 295.23))
            bezier2Path.addLine(to: CGPoint(x: 144.83, y: 367.95))
            bezier2Path.addLine(to: CGPoint(x: 41.68, y: 392.14))
            bezier2Path.addCurve(to: CGPoint(x: 12.51, y: 436.35), controlPoint1: CGPoint(x: 19.67, y: 397.3), controlPoint2: CGPoint(x: 6.62, y: 417.09))
            bezier2Path.addCurve(to: CGPoint(x: 63.03, y: 461.87), controlPoint1: CGPoint(x: 18.41, y: 455.6), controlPoint2: CGPoint(x: 41.02, y: 467.03))
            bezier2Path.addLine(to: CGPoint(x: 237.41, y: 420.98))
            bezier2Path.addLine(to: CGPoint(x: 237.41, y: 514.32))
            bezier2Path.addLine(to: CGPoint(x: 237.41, y: 596.58))
            bezier2Path.addCurve(to: CGPoint(x: 237.28, y: 602.57), controlPoint1: CGPoint(x: 237.41, y: 598.5), controlPoint2: CGPoint(x: 237.35, y: 600.5))
            bezier2Path.addLine(to: CGPoint(x: 63.03, y: 561.7))
            bezier2Path.addCurve(to: CGPoint(x: 12.51, y: 587.23), controlPoint1: CGPoint(x: 41.02, y: 556.55), controlPoint2: CGPoint(x: 18.41, y: 567.97))
            bezier2Path.addCurve(to: CGPoint(x: 41.68, y: 631.44), controlPoint1: CGPoint(x: 6.62, y: 606.48), controlPoint2: CGPoint(x: 19.67, y: 626.28))
            bezier2Path.addLine(to: CGPoint(x: 144.83, y: 655.62))
            bezier2Path.addLine(to: CGPoint(x: 20.63, y: 718.38))
            bezier2Path.addCurve(to: CGPoint(x: 5.53, y: 767.68), controlPoint1: CGPoint(x: 0.9, y: 728.35), controlPoint2: CGPoint(x: -5.86, y: 750.42))
            bezier2Path.addCurve(to: CGPoint(x: 61.87, y: 780.89), controlPoint1: CGPoint(x: 16.92, y: 784.95), controlPoint2: CGPoint(x: 42.14, y: 790.86))
            bezier2Path.addLine(to: CGPoint(x: 186.08, y: 718.14))
            bezier2Path.addLine(to: CGPoint(x: 158.43, y: 808.42))
            bezier2Path.addCurve(to: CGPoint(x: 187.6, y: 852.62), controlPoint1: CGPoint(x: 152.54, y: 827.67), controlPoint2: CGPoint(x: 165.6, y: 847.46))
            bezier2Path.addCurve(to: CGPoint(x: 238.11, y: 827.1), controlPoint1: CGPoint(x: 209.6, y: 857.78), controlPoint2: CGPoint(x: 232.22, y: 846.36))
            bezier2Path.addLine(to: CGPoint(x: 284.81, y: 674.58))
            bezier2Path.addCurve(to: CGPoint(x: 287.14, y: 675.71), controlPoint1: CGPoint(x: 285.58, y: 674.96), controlPoint2: CGPoint(x: 286.39, y: 675.33))
            bezier2Path.addCurve(to: CGPoint(x: 367.02, y: 716.07), controlPoint1: CGPoint(x: 313.77, y: 689.16), controlPoint2: CGPoint(x: 340.39, y: 702.62))
            bezier2Path.addCurve(to: CGPoint(x: 489.93, y: 778.17), controlPoint1: CGPoint(x: 407.99, y: 736.77), controlPoint2: CGPoint(x: 448.96, y: 757.47))
            bezier2Path.addCurve(to: CGPoint(x: 534.26, y: 778.17), controlPoint1: CGPoint(x: 503.61, y: 785.08), controlPoint2: CGPoint(x: 520.58, y: 785.08))
            bezier2Path.addCurve(to: CGPoint(x: 551.93, y: 769.24), controlPoint1: CGPoint(x: 540.15, y: 775.19), controlPoint2: CGPoint(x: 546.04, y: 772.22))
            bezier2Path.addCurve(to: CGPoint(x: 534.26, y: 778.17), controlPoint1: CGPoint(x: 546.04, y: 772.22), controlPoint2: CGPoint(x: 540.15, y: 775.19))
            bezier2Path.addCurve(to: CGPoint(x: 489.93, y: 778.17), controlPoint1: CGPoint(x: 520.58, y: 785.08), controlPoint2: CGPoint(x: 503.61, y: 785.08))
            bezier2Path.addCurve(to: CGPoint(x: 464.53, y: 765.33), controlPoint1: CGPoint(x: 481.46, y: 773.89), controlPoint2: CGPoint(x: 472.99, y: 769.62))
            bezier2Path.addLine(to: CGPoint(x: 336.91, y: 877.02))
            bezier2Path.addCurve(to: CGPoint(x: 336.91, y: 928.06), controlPoint1: CGPoint(x: 320.8, y: 891.11), controlPoint2: CGPoint(x: 320.8, y: 913.97))
            bezier2Path.addCurve(to: CGPoint(x: 395.23, y: 928.06), controlPoint1: CGPoint(x: 353.01, y: 942.16), controlPoint2: CGPoint(x: 379.13, y: 942.16))
            bezier2Path.addLine(to: CGPoint(x: 470.75, y: 861.98))
            bezier2Path.addLine(to: CGPoint(x: 470.75, y: 987.49))
            bezier2Path.addCurve(to: CGPoint(x: 512, y: 1023.58), controlPoint1: CGPoint(x: 470.75, y: 1007.41), controlPoint2: CGPoint(x: 489.22, y: 1023.58))
            bezier2Path.addCurve(to: CGPoint(x: 553.24, y: 987.49), controlPoint1: CGPoint(x: 534.78, y: 1023.58), controlPoint2: CGPoint(x: 553.24, y: 1007.41))
            bezier2Path.addLine(to: CGPoint(x: 553.24, y: 861.98))
            bezier2Path.addLine(to: CGPoint(x: 628.76, y: 928.06))
            bezier2Path.addCurve(to: CGPoint(x: 687.08, y: 928.06), controlPoint1: CGPoint(x: 644.86, y: 942.16), controlPoint2: CGPoint(x: 670.98, y: 942.16))
            bezier2Path.addCurve(to: CGPoint(x: 687.08, y: 877.02), controlPoint1: CGPoint(x: 703.19, y: 913.97), controlPoint2: CGPoint(x: 703.19, y: 891.11))
            bezier2Path.addLine(to: CGPoint(x: 559.54, y: 765.4))
            bezier2Path.addCurve(to: CGPoint(x: 722.17, y: 683.23), controlPoint1: CGPoint(x: 613.75, y: 738.01), controlPoint2: CGPoint(x: 667.96, y: 710.62))
            bezier2Path.addCurve(to: CGPoint(x: 739.47, y: 675.04), controlPoint1: CGPoint(x: 727.46, y: 680.55), controlPoint2: CGPoint(x: 733.4, y: 677.87))
            bezier2Path.addCurve(to: CGPoint(x: 739.34, y: 675.1), controlPoint1: CGPoint(x: 739.43, y: 675.06), controlPoint2: CGPoint(x: 739.38, y: 675.08))
            bezier2Path.addLine(to: CGPoint(x: 785.88, y: 827.1))
            bezier2Path.addCurve(to: CGPoint(x: 836.39, y: 852.62), controlPoint1: CGPoint(x: 791.77, y: 846.36), controlPoint2: CGPoint(x: 814.39, y: 857.78))
            bezier2Path.addCurve(to: CGPoint(x: 865.56, y: 808.42), controlPoint1: CGPoint(x: 858.4, y: 847.46), controlPoint2: CGPoint(x: 871.45, y: 827.67))
            bezier2Path.addLine(to: CGPoint(x: 837.92, y: 718.14))
            bezier2Path.addLine(to: CGPoint(x: 962.12, y: 780.89))
            bezier2Path.addCurve(to: CGPoint(x: 1018.47, y: 767.68), controlPoint1: CGPoint(x: 981.85, y: 790.86), controlPoint2: CGPoint(x: 1007.07, y: 784.95))
            bezier2Path.addCurve(to: CGPoint(x: 1003.36, y: 718.38), controlPoint1: CGPoint(x: 1029.85, y: 750.42), controlPoint2: CGPoint(x: 1023.09, y: 728.35))
            bezier2Path.close()
            fillColor.setFill()
            bezier2Path.fill()
        }
        
    }
    
}
