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
    

    dispatch_async(GlobalBackgroundQueue) {

      let db = FMDatabase(path: NSTemporaryDirectory().stringByAppendingString("tempSQlite"))
      
      db.open()
      
      
      db.executeStatements("drop table RandomNumber")
      
      measure("inserting on sqlite", block: { finish in
        
        db.beginTransaction()
        
        let sql_stmt = "CREATE TABLE RandomNumber (ID INTEGER PRIMARY KEY, Number1 STRING, Number2 STRING, Number3 STRING, Number4 STRING, Number5 STRING, Number6 STRING, Number7 STRING, Number8 STRING)"
        if !db.executeStatements(sql_stmt) {
          print("Error: \(db.lastErrorMessage())")
        }
        

        for index in 1 ... 100000 {
          let stringIndex = "\(index)"
          let insertSQL = "INSERT INTO RandomNumber (id, Number1, Number2, Number3, Number4, Number5, Number6, Number7, Number8) VALUES ('\(index)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)', '\(stringIndex)')"
          
          let result = db.executeUpdate(insertSQL, withArgumentsInArray: nil)
        }
        
        db.commit()
        finish()
      })
      
      
      let rs = db.executeQuery("select count(*) as count from RandomNumber", withArgumentsInArray: nil)
      rs.next()
      
      print(rs.intForColumn("count"))

      
      
      measure("updating on sqlite", block: { finish in
        
        db.beginTransaction()
        
        for index in 1 ... 100000 {
          
          let indexString = "\(index+1)"
          
          let updateSQL = "UPDATE RandomNumber SET Number1 = \(indexString), Number2 = \(indexString), Number3 = \(indexString), Number4 = \(indexString), Number5 = \(indexString), Number6 = \(indexString), Number7 = \(indexString), Number8 = \(indexString) WHERE id = \(index)"
          
          let result = db.executeUpdate(updateSQL, withArgumentsInArray: nil)
        }
        
        db.commit()
        finish()
      })
      
      
      let rs2 = db.executeQuery("select count(*) as count from RandomNumber", withArgumentsInArray: nil)
      rs2.next()
      
      print(rs2.intForColumn("count"))
      
      
      
//      measure("query (count) with sqlite", block: { finish in
//        
//        let results = db.executeQuery("SELECT count(*) as count FROM RandomNumber WHERE id BETWEEN 10000 and 20000", withArgumentsInArray: nil)
//        
//        results.next()
//        print(results.intForColumn("count"))
//                
//        finish()
//      })
      
      measure("query with sqlite (dictionaries)", block: { finish in
        
        var array = [NSDictionary]()
        
        let results = db.executeQuery("SELECT * FROM RandomNumber", withArgumentsInArray: nil)
        
        while results.next() {
          let dictionary = results.resultDictionary()
          array.append(dictionary)
        }
        
        print("array count: \(array.count)")
        
        finish()
      })
      
      
      measure("query with sqlite (values mapped on object)", block: { finish in
        
        var array = [RandomNumberSqlite]()
        
        let results = db.executeQuery("SELECT * FROM RandomNumber", withArgumentsInArray: nil)
        
        while results.next() {
          let number = RandomNumberSqlite()
          number.number1 = results.stringForColumnIndex(1)
          number.number2 = results.stringForColumnIndex(2)
          number.number3 = results.stringForColumnIndex(3)
          number.number4 = results.stringForColumnIndex(4)
          number.number5 = results.stringForColumnIndex(5)
          number.number6 = results.stringForColumnIndex(6)
          number.number7 = results.stringForColumnIndex(7)
          number.number8 = results.stringForColumnIndex(8)
          array.append(number)
        }
        
        print("array count: \(array.count)")
        
        finish()
      })

      
      measure("query with sqlite (values mapped on object with an intermediary dictionary)", block: { finish in
        
        var array = [NSDictionary]()
        
        let results = db.executeQuery("SELECT * FROM RandomNumber", withArgumentsInArray: nil)
        
        while results.next() {
          let dictionary = results.resultDictionary()
          array.append(dictionary)
        }
        
        let objectArray = array.map({ RandomNumberSqlite(dictionary: $0) })
        
        print("array count: \(objectArray.count)")
        
        finish()
      })
      

      
      db.close()

    }
  }
  
  
}

final class RandomNumberSqlite {
  
  var id = 0
  
  var number1 = "0"
  var number2 = "0"
  var number3 = "0"
  var number4 = "0"
  var number5 = "0"
  var number6 = "0"
  var number7 = "0"
  var number8 = "0"
  
  init() {
    
  }
  
  init(dictionary: NSDictionary) {
    self.number1 = String(dictionary["Number1"] as! Int)
    self.number2 = String(dictionary["Number2"] as! Int)
    self.number3 = String(dictionary["Number3"] as! Int)
    self.number4 = String(dictionary["Number4"] as! Int)
    self.number5 = String(dictionary["Number5"] as! Int)
    self.number6 = String(dictionary["Number6"] as! Int)
    self.number7 = String(dictionary["Number7"] as! Int)
    self.number8 = String(dictionary["Number8"] as! Int)

  }
}
