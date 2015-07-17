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
      realm.write { () -> Void in
        autoreleasepool({ () -> () in
          for index in 1 ... 100000 {
            let rand = RandomNumber()
            rand.id = Int64(index)
            rand.number1 = Int64(index)
            realm.add(rand, update: false)
          }
        })
        
      }
      finish()
    })
    
    
  }


}


class RandomNumber: Object {
  
  dynamic var id:Int64 = 0
  
  dynamic var number1: Int64 = 0
  dynamic var number2: Int64 = 0
  dynamic var number3: Int64 = 0
  dynamic var number4: Int64 = 0
  dynamic var number5: Int64 = 0

  
  override static func primaryKey() -> String? {
    return "id"
  }
}

