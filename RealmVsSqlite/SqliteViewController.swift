//
//  SqliteViewController.swift
//  RealmVsSqlite
//
//  Created by Mark Aron Szulyovszky on 17/07/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import UIKit
import SQLite

class SqliteViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let db = Database()
    
    let numbers = db["RandomNumber"]
    let id = Expression<Int64>("id")
    let number1 = Expression<Int64?>("number1")
    let number2 = Expression<Int64?>("number2")
    let number3 = Expression<Int64?>("number3")
    let number4 = Expression<Int64?>("number4")
    let number5 = Expression<Int64?>("number5")

    db.create(table: numbers) { t in
      t.column(id, primaryKey: true)
      t.column(number1)
      t.column(number2)
      t.column(number3)
      t.column(number4)
      t.column(number5)
    }
    
    measure("writing on realm", { finish in
      for index in 1 ... 100000 {
        numbers.insert(id <- Int64(index), number1 <- Int64(index))
      }
      finish()
    })

    

    
    
  }
  
  
}
