//
//  item.swift
//  Todoey
//
//  Created by Peter Larson on 3/29/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import Foundation

class Item: Codable {
    var itemName : String = ""
    var checked : Bool = false
    
    init(name : String) {
        itemName = name
    }
    
    func updateState() -> Bool {
        checked = !checked
        print(itemName,"  ",checked)
        return checked
    }
}
