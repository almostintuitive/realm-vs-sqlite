//
//  ViewController.swift
//  RealmVsSqlite
//
//  Created by Mark Aron Szulyovszky on 17/07/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import UIKit
import RealmSwift

class RealmViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    dispatch_async(GlobalBackgroundQueue) {

      let realm = Realm()
      
      realm.write { () -> Void in
        realm.deleteAll()
      }
      
      var items = [RandomNumber]()
      
      for index in 1 ... 100000 {
        let rand = RandomNumber()
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
      
      
      measure("writing on realm", { finish in
        
        realm.write({ () -> Void in
          realm.add(items, update: false)
        })
        finish()
      })
      
      println(realm.objects(RandomNumber).count)
      
      
      
      // updating
      
      
      measure("updating on realm", { finish in
        
        realm.write({ () -> Void in
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
        })
        finish()
      })
      
      println(realm.objects(RandomNumber).count)
      
      
      measure("select 10k item", { finish in
        
        let results = realm.objects(RandomNumber).filter("id > 10000 AND id < 20000").sorted("id")
        println(results.count)
        finish()
        
      })
      
    }
    

  }


}


final class RandomNumber: Object {
  
  dynamic var id = 0
  
  dynamic var number1 = 0
  dynamic var number2 = 0
  dynamic var number3 = 0
  dynamic var number4 = 0
  dynamic var number5 = 0
  dynamic var number6 = 0
  dynamic var number7 = 0
  dynamic var number8 = 0

  
//  override static func primaryKey() -> String? {
//    return "id"
//  }
}



