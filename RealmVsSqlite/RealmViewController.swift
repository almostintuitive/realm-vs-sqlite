//
//  ViewController.swift
//  RealmVsSqlite
//
//  Created by Mark Aron Szulyovszky on 17/07/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import UIKit
import Realm


class RealmViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let queue = dispatch_queue_create("db", DISPATCH_QUEUE_SERIAL)
    
    
    dispatch_async(queue) {

      let realm = RLMRealm.defaultRealm()
      
      realm.beginWriteTransaction()
      realm.deleteAllObjects()
      try! realm.commitWriteTransaction()
      

      var items = [RandomNumberObjc]()
      for index in 1 ... 100000 {
        let rand = RandomNumberObjc()
        let indexString = "\(index)"
        rand.id = index
        rand.number1 = indexString
        rand.number2 = indexString
        rand.number3 = indexString
        rand.number4 = indexString
        rand.number5 = indexString
        rand.number6 = indexString
        rand.number7 = indexString
        rand.number8 = indexString
        items.append(rand)
      }
      
      
      measure("insert on realmObjc", block: { finish in
        
        realm.beginWriteTransaction()
        realm.addObjects(items)
        try! realm.commitWriteTransaction()

        finish()
      })
      
      print( RandomNumberObjc.allObjects().count )
      
      
      
      // updating
      
      
      measure("updating on realmObjc", block: { finish in
        
        realm.beginWriteTransaction()
        
        for (index, item) in items.enumerate() {
          let indexString = "\(index+1)"
          item.number1 += indexString
          item.number2 += indexString
          item.number3 += indexString
          item.number4 += indexString
          item.number5 += indexString
          item.number6 += indexString
          item.number7 += indexString
          item.number8 += indexString
        }

        try! realm.commitWriteTransaction()

        finish()
      })
      
      print( RandomNumberObjc.allObjects().count )
      
      
//      measure("query (count) with realmObjc", block: { finish in
//        
//        
//        let results = RandomNumberObjc.objectsWithPredicate(NSPredicate(format: "id >  %i AND id <  %i", 10000, 20000))
//        
//        print(results.count)
//        finish()
//        
//      })
		
      

      measure("query with realmObjc", block: { finish in
        
        var array = [RandomNumberObjc]()
        
        let results = RandomNumberObjc.allObjects()
        for index in 0...results.count-1 {
          array.append(results[index] as! RandomNumberObjc)
        }
        print("array count: \(array.count)")
        finish()
      })
      
      
      measure("query with realmObjc with new objects", block: { finish in
        
        var array = [RandomNumberObjcNonRealm]()
        
        let results = RandomNumberObjc.allObjects()
        for index in 0...results.count-1 {
          array.append(RandomNumberObjcNonRealm(realmObject: results[index] as! RandomNumberObjc))
        }
        print("array count: \(array.count)")
        finish()
      })
      
    }
    

  }


}

class RandomNumberObjc: RLMObject {
  
  dynamic var id = 0
  
  dynamic var number1 = "0"
  dynamic var number2 = "0"
  dynamic var number3 = "0"
  dynamic var number4 = "0"
  dynamic var number5 = "0"
  dynamic var number6 = "0"
  dynamic var number7 = "0"
  dynamic var number8 = "0"
}




class RandomNumberObjcNonRealm {
  
  var id = 0
  
  var number1 = "0"
  var number2 = "0"
  var number3 = "0"
  var number4 = "0"
  var number5 = "0"
  var number6 = "0"
  var number7 = "0"
  var number8 = "0"
  
  init(realmObject: RandomNumberObjc) {
    self.id = realmObject.id
    self.number1 = realmObject.number1
    self.number2 = realmObject.number2
    self.number3 = realmObject.number3
    self.number4 = realmObject.number4
    self.number5 = realmObject.number5
    self.number6 = realmObject.number6
    self.number7 = realmObject.number7
    self.number8 = realmObject.number8

  }
  
}

