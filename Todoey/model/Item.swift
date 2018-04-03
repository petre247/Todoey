//
//  Item.swift
//  Todoey
//
//  Created by Peter Larson on 3/31/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var itemName: String = ""
    @objc dynamic var checked: Bool = false
    
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
