//
//  SqliteViewController.swift
//  RealmVsSqlite
//
//  Created by Mark Aron Szulyovszky on 17/07/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import UIKit


class SqliteViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

    let docsDir =
    NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
      .UserDomainMask, true)[0] as! String
    
    let databasePath = docsDir.stringByAppendingPathComponent(
      "contacts.db")
    
    let db = FMDatabase(path: databasePath as String)
    
    db.open()
    
    
    db.executeStatements("drop table RandomNumber")
    
    measure("writing on sqlite", { finish in
      
      db.beginTransaction()
      
      let sql_stmt = "CREATE TABLE RandomNumber (ID INTEGER PRIMARY KEY, Number1 INTEGER, Number2 INTEGER, Number3 INTEGER, Number4 INTEGER, Number5 INTEGER, Number6 INTEGER, Number7 INTEGER, Number8 INTEGER)"
      if !db.executeStatements(sql_stmt) {
        println("Error: \(db.lastErrorMessage())")
      }
      

      for index in 1 ... 100000 {
        let insertSQL = "INSERT INTO RandomNumber (id, Number1, Number2, Number3, Number4, Number5, Number6, Number7, Number8) VALUES ('\(index)', '\(index)', '\(index)', '\(index)', '\(index)', '\(index)', '\(index)', '\(index)')"
        
        let result = db.executeUpdate(insertSQL, withArgumentsInArray: nil)
      }
      
      db.commit()

      finish()
    })
    
    
    let rs = db.executeQuery("select count(*) as count from RandomNumber", withArgumentsInArray: nil)
    rs.next()
    
    println(rs.intForColumn("count"))

    
    db.close()

  }
  
  
}
