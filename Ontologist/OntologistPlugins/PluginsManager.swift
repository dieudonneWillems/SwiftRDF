//
//  PluginsManager.swift
//  Ontologist
//
//  Created by Don Willems on 05/02/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Foundation
import SwiftRDFOSX

public class PluginsManager {
    
    public static let sharedPluginsManager = PluginsManager()
    
    public private(set) var typeIconPlugins = [TypeIconsPlugin]()
    public private(set) var typeEditorPlugins = [TypeEditorPlugin]()
    
    private init() {
        let appBundle = NSBundle.mainBundle()
        let pluginPaths = appBundle.pathsForResourcesOfType("plugin", inDirectory: "../PlugIns")
        
        for pluginPath in pluginPaths {
            let bundle = NSBundle(  path: pluginPath)
            if bundle != nil {
                let bundleClass = bundle!.principalClass as? Plugin.Type
                
                if bundleClass != nil {
                    let instance : Plugin = bundleClass!.init()
                    if (instance as? TypeIconsPlugin) != nil {
                        typeIconPlugins.append(instance as! TypeIconsPlugin)
                    }
                    if (instance as? TypeEditorPlugin) != nil {
                        typeEditorPlugins.append(instance as! TypeEditorPlugin)
                    }
                }
            }
        }
    }
    
    public func iconForInstance(type : Resource) -> NSImage? {
        for typeIconPlugin in typeIconPlugins {
            let icon = typeIconPlugin.iconForInstance(type)
            if icon != nil {
                return icon
            }
         }
        return nil
    }
    
    public func iconForInstance(types : [Resource]) -> NSImage? {
        for type in types {
            let image = iconForInstance(type)
            if image != nil {
                return image
            }
        }
        return nil
    }
    
    public func iconForResource(resource : Resource) -> NSImage? {
        for typeIconPlugin in typeIconPlugins {
            let icon = typeIconPlugin.iconForResource(resource)
            if icon != nil {
                return icon
            }
        }
        return nil
    }
}