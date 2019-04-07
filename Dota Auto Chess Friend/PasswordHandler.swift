//
//  PasswordHandler.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-28.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit

class PasswordHandler: NSObject {

    
    
    public func setPassword() {
        UserDefaults.standard.set(nil, forKey: "admin password")
        if UserDefaults.standard.string(forKey: "admin password") == nil {
            UserDefaults.standard.set("Hejsan1", forKey: "admin password" )
        }
    }
    
}
