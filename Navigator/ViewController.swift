//
//  ViewController.swift
//  Navigator
//
//  Created by Jose Pablo on 17/01/2019.
//  Copyright © 2019 Jose Pablo. All rights reserved.
//

import UIKit

import SQLite3

class ViewController: UIViewController {

    @IBOutlet weak var tfURL: UITextField!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var btnForward: UIButton!
    @IBOutlet weak var btnBackward: UIButton!
    @IBOutlet weak var lblDown: UILabel!
    @IBOutlet weak var web: UIWebView!
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("ProductsDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("database oppened")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Historial (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        
        tfURL.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        btnOK.isEnabled=false
        
    }
    
    func insertar()  {
        
        //getting values from textfields
        let webURL = tfURL.text!
        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        print("INSERT EJECUTADO " + webURL)
        let queryString = "INSERT INTO Historial ('name') VALUES ('\(webURL)')"
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting Web: \(errmsg)")
            return
        }
        
        
        
        //  readValues()
        
        //displaying a success message
        print("Web saved successfully")
        
    }
    
    
    @IBAction func PressOk(_ sender: Any) {
        insertar();
        goWeb();
    }

    @IBAction func irAlante(_ sender: UIButton) {
   
        if web.canGoForward {
            web.goForward()
        }
        
        //insertar()

    }
    
    @IBAction func irAtras(_ sender: UIButton) {
        
        if web.canGoBack {
            web.goBack()
            
        }
        
        
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if (tfURL.text?.count)! > 0 {
            btnOK.isEnabled=true
        }
        else {
            btnOK.isEnabled=false
        }
    }
    
    @IBAction func UrlChange(_ sender: Any) {
        
        if (tfURL.text?.count)! > 0 {
            btnOK.isEnabled=true
        }
        else {
            btnOK.isEnabled=false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        lblDown.text=web.request?.description
        if web.canGoBack {
            btnBackward.isEnabled=true
        }
        else {
            btnBackward.isEnabled=false
        }
        
        if web.canGoForward {
            btnForward.isEnabled=true
        }
        else {
            btnForward.isEnabled=false
        }
    }
    
    func goWeb() {
        if tfURL.text != "" {
            if (tfURL.text?.characters.count)! > 7 {
                let index1 = tfURL.text?.index((tfURL.text?.startIndex)!, offsetBy: 7)
                
                let substring1 = tfURL.text?.substring(to: index1!)
                if substring1?.uppercased() != "HTTP://" {
                    tfURL.text="http://"+tfURL.text!
                }
            }
            else {
                tfURL.text="http://"+tfURL.text!
            }
        }
        web.loadRequest(URLRequest(url: URL(string: tfURL.text!)!))
    }
    
//    @IBAction func ComprobarURL(_ sender: UITextField) {
//        //getting values from textfields
//        let webURL = tfURL.text!
//        let webURLArray = webURL .components(separatedBy: ".")
//        let WebURLString = webURLArray[1]
//
//        //creating a statement
//        var stmt: OpaquePointer?
//
//        //the select query
//        let queryString = "SELECT name FROM Historial WHERE name = \(WebURLString)"
//        //preparing the query
//        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("error preparing select: \(errmsg)")
//            return
//        }
//
//        //executing the query to insert values
//        if sqlite3_step(stmt) != SQLITE_DONE {
//            let errmsg = String(cString: sqlite3_errmsg(db)!)
//            print("failure inserting Web: \(errmsg)")
//            return
//        }else {
//            let resultSelect = sqlite3_column_text(stmt, 1)
//        }
//    }
    
    
}

