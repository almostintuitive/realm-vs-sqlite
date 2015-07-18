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
    
    db.beginTransaction()
    
    db.executeStatements("drop table RandomNumber")
    
    let sql_stmt = "CREATE TABLE RandomNumber (ID INTEGER PRIMARY KEY, Number1 INTEGER)"
    if !db.executeStatements(sql_stmt) {
      println("Error: \(db.lastErrorMessage())")
    }
    
    measure("writing on realm", { finish in
      
      for index in 1 ... 100000 {
        let insertSQL = "INSERT INTO RandomNumber (id, Number1) VALUES ('\(index)', '\(index)')"
        
        let result = db.executeUpdate(insertSQL,
          withArgumentsInArray: nil)
      }
      finish()
    })
    
    db.commit()
    
    let rs = db.executeQuery("select count(*) as count from RandomNumber", withArgumentsInArray: nil)
    rs.next()
    
    println(rs.intForColumn("count"))

    
    db.close()

  }
  
  
}
