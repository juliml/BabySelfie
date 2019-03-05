//
//  Profile.swift
//  BabySelfie
//
//  Created by Juliana Lacerda on 2019-02-27.
//  Copyright © 2019 Juliana Lacerda. All rights reserved.
//

import Foundation

struct Profile {
    
    var id: String
    var displayName: String
    
    init(_ id: String, displayName: String) {
        self.id = id
        self.displayName = displayName
    }

}
