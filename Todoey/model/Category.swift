//
//  Category.swift
//  Todoey
//
//  Created by Peter Larson on 4/1/18.
//  Copyright © 2018 Peter Larson. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {

    @objc dynamic var name: String = ""
    @objc dynamic var color: String = "000000"
    let items = List<Item>()
    
}
