//
//  ProfileManager.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-27.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation

class ProfileManager {
    
    static let instance = ProfileManager()
    fileprivate var profile: Profile!
    
    struct keys {
        static let frequence = "frequence"
    }
    
    func setProfile(_ profile: Profile) {
        self.profile = profile
    }
    
    func getProfile() -> Profile {
        return self.profile
    }
    
    func getId() -> String {
        return self.profile.id
    }
    
    func getDisplayName() -> String {
        return self.profile.displayName
    }
    
    // MARK: - Frequence
    
    func saveFrequence(_ value:Float) {
        UserDefaults().saveData(value, key: keys.frequence)
    }
    
    func deleteFrequence() {
        return UserDefaults().delete(keys.frequence)
    }
    
    static func getFrequence() -> Float? {
        return UserDefaults().getData(keys.frequence) as? Float
    }

}
