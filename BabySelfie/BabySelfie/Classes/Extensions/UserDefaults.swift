//
//  UserDefaults.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-03-04.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func get(_ key: String) -> Any? {
        return self.object(forKey: key)
    }
    
    func getData(_ key: String) -> Any? {
        if let data = self.get(key) {
            return NSKeyedUnarchiver.unarchiveObject(with: data as! Data)
        }
        return nil
    }
    
    func save(_ object: Any, key: String) {
        self.set(object, forKey: key)
        self.synchronize()
    }
    
    func saveData(_ object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        self.set(data, forKey: key)
        self.synchronize()
    }
    
    func delete(_ key: String) {
        self.removeObject(forKey: key)
    }
    
}
