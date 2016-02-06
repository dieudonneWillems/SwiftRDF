//
//  ClassTypeEditor.swift
//  Ontologist
//
//  Created by Don Willems on 05/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa
import SwiftRDFOSX
import OntologistPlugins


public class ClassTypeEditor : Plugin, TypeEditorPlugin, TypeIconsPlugin {
    
    private var classIcon : NSImage?
    private var classResourceIcon : NSImage?
    
    public required init() {
        super.init()
        let instanceIconPath = self.pluginBundle.pathForImageResource("class")
        if instanceIconPath != nil {
            classIcon = NSImage(contentsOfFile: instanceIconPath!)
        }
        let resourceIconPath = self.pluginBundle.pathForImageResource("class-resource")
        if resourceIconPath != nil {
            classResourceIcon = NSImage(contentsOfFile: resourceIconPath!)
        }
    }
    
    public func iconForResource(resource: Resource) -> NSImage? {
        if resource == OWL.Class || resource == RDFS.Class {
            return classResourceIcon
        }
        return nil
    }
    
    public func iconForInstance(type: Resource) -> NSImage? {
        if type == OWL.Class || type == RDFS.Class {
            return classIcon
        }
        return nil
    }
    
}
