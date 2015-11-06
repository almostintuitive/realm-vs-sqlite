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
        rand.id = index
        rand.number1 = index
        rand.number2 = index
        rand.number3 = index
        rand.number4 = index
        rand.number5 = index
        rand.number6 = index
        rand.number7 = index
        rand.number8 = index
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
        
        for item in items {
          item.number1 += 1
          item.number2 += 2
          item.number3 += 2
          item.number4 += 2
          item.number5 += 2
          item.number6 += 2
          item.number7 += 2
          item.number8 += 2
        }

        try! realm.commitWriteTransaction()

        finish()
      })
      
      print( RandomNumberObjc.allObjects().count )
      
      
      measure("query (count) with realmObjc", block: { finish in
        
        
        let results = RandomNumberObjc.objectsWithPredicate(NSPredicate(format: "id >  %i AND id <  %i", 10000, 20000))
        
        print(results.count)
        finish()
        
      })
		
      

      measure("query with realmObjc", block: { finish in
        
        var array = [RandomNumberObjc]()
        
        let results = RandomNumberObjc.allObjects()
        for index in 0...results.count-1 {
          array.append(results[index] as! RandomNumberObjc)
        }
        print("array count: \(array.count)")

      })
      
    }
    

  }


}

class RandomNumberObjc: RLMObject {
  
  dynamic var id = 0
  
  dynamic var number1 = 0
  dynamic var number2 = 0
  dynamic var number3 = 0
  dynamic var number4 = 0
  dynamic var number5 = 0
  dynamic var number6 = 0
  dynamic var number7 = 0
  dynamic var number8 = 0

  
}




