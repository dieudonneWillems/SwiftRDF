//
//  TypeIconsPlugin.swift
//  Ontologist
//
//  Created by Don Willems on 05/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX

public protocol TypeIconsPlugin {
    
    func iconForResource(resource: Resource) -> NSImage?
    func iconForInstance(type: Resource) -> NSImage?
    
}
