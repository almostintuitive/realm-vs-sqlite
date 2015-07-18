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
    
    let realm = Realm()
    
    realm.write { () -> Void in
      realm.deleteAll()
    }
    
    measure("writing on realm", { finish in
      
      realm.write({ () -> Void in
        autoreleasepool({ () -> () in
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
            realm.add(rand, update: false)
          }
        })
      })
      finish()
    })
    
    println(realm.objects(RandomNumber).count)
    
  }


}


class RandomNumber: Object {
  
  dynamic var id = 0
  
  dynamic var number1 = 0
  dynamic var number2 = 0
  dynamic var number3 = 0
  dynamic var number4 = 0
  dynamic var number5 = 0
  dynamic var number6 = 0
  dynamic var number7 = 0
  dynamic var number8 = 0

  
  override static func primaryKey() -> String? {
    return "id"
  }
}

