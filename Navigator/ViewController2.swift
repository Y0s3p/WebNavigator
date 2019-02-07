//
//  ViewController2.swift
//  Navigator
//
//  Created by Jose Pablo on 22/01/2019.
//  Copyright © 2019 Jose Pablo. All rights reserved.
//

import UIKit

import SQLite3

class ViewController2: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var db: OpaquePointer?
    var historialURL : [String] = []
    @IBOutlet weak var tableView: UITableView!
        
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
        
        
        readValues()
    }
    
    func readValues(){
        
        //first empty the list of heroes
        historialURL.removeAll()
        
        //this is our select query
        let queryString = "SELECT name FROM Historial"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing select: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            
            let name = String(cString: sqlite3_column_text(stmt,0))
            print(name)
            //adding values to list
            historialURL.append(name)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historialURL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "mycell")
        cell.textLabel?.text  = historialURL[indexPath.row]
        
        return cell
        
    }
    
}

//class Web {
//
//    var id: Int
//    var name: String?
//
//    init(id: Int, name: String?){
//        self.id = id
//        self.name = name
//    }

