//
//  Measure.swift
//  RealmVsSqlite
//
//  Created by Mark Aron Szulyovszky on 17/07/2015.
//  Copyright (c) 2015 Mark Aron Szulyovszky. All rights reserved.
//

import Foundation

func measure(title: String, block: (() -> ()) -> ()) {
  
  let startTime = CFAbsoluteTimeGetCurrent()
  
  block {
    let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    println("\(title):: Time: \(timeElapsed)")
  }
}