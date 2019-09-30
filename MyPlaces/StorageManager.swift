//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Vasilii on 30/09/2019.
//  Copyright © 2019 Vasilii Burenkov. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    static func deliteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
