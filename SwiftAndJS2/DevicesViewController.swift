//
//  DevicesViewController.swift
//  JSCore
//
//  Created by Gabriel Theodoropoulos on 13/02/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import UIKit
import JavaScriptCore

class DevicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tblDeviceList: UITableView!
    var jsContext: JSContext!
    var deviceInfo: [DeviceInfo]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tblDeviceList = UITableView()
        self.tblDeviceList.delegate = self
        self.tblDeviceList.dataSource = self
        self.view.addSubview(self.tblDeviceList)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeJS()
        parseDeviceData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tblDeviceList.frame = self.view.frame
        tblDeviceList.tableFooterView = UIView(frame: CGRect.zero)
    }

    
    func initializeJS() {
        self.jsContext = JSContext()
        
        self.jsContext.exceptionHandler = { (context, exception) in
            if let exc = exception {
                print("JS Exception: ", exc.toString())
            }
            
        }
            if let papaParsePath = Bundle.main.path(forResource: "papaparse.min", ofType: "js") {
                do {
                    let papaParseContents = try String(contentsOfFile: papaParsePath)
                    self.jsContext.evaluateScript(papaParseContents)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            if let jsSourcePath = Bundle.main.path(forResource: "jssource", ofType: "js") {
                do {
                    let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                    self.jsContext.evaluateScript(jsSourceContents)
                } catch  {
                    print(error.localizedDescription)
                }
            }
            
            self.jsContext.setObject(DeviceInfo.self, forKeyedSubscript: "DeviceInfo" as (NSCopying & NSObjectProtocol)!)
        }
    
    //將csv送入parseiPhoneList運用papaparse解析，得到各機種資料
    func parseDeviceData()  {
        if let path = Bundle.main.path(forResource: "iPhone_List", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: path)
                
                if let functionParseiPhoneList = self.jsContext.objectForKeyedSubscript("parseiPhoneList") {
                    if let parseDeviceData = functionParseiPhoneList.call(withArguments: [contents]).toArray() as? [DeviceInfo] {
                        self.deviceInfo = parseDeviceData
                        self.tblDeviceList.reloadData()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: IBAction Methods
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: UITableViewDelegate & UITableViewDataSource Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.deviceInfo != nil) ? self.deviceInfo.count : 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "idDeviceCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "idDeviceCell")
        }
        
        let currentDevice = self.deviceInfo[indexPath.row]
        
        cell?.textLabel?.text = currentDevice.model
        cell?.detailTextLabel?.text = currentDevice.concatOS()
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: URL(string: currentDevice.imageURL)!, completionHandler: { (imageData, response, error) in
            if let data = imageData {
                DispatchQueue.main.async {
                    cell?.imageView?.image = UIImage(data: data)
                    cell?.layoutSubviews()
                }
            }
        }).resume()
        
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
}
