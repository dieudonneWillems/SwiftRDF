//
//  Plugin.swift
//  Ontologist
//
//  Created by Don Willems on 05/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Foundation

public class Plugin {
    
    public let pluginBundle : NSBundle
    
    public required init() {
        pluginBundle = NSBundle(forClass: self.dynamicType)
    }
}