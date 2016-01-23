//
//  FileView.swift
//  Ontologist
//
//  Created by Don Willems on 21/01/16.
//  Copyright © 2016 lapsedpacifist. All rights reserved.
//

import Cocoa

class FileView: NSView {
    
    @IBOutlet weak var fileName: NSTextField?
    @IBOutlet weak var numberOfStatements: NSTextField?
    @IBOutlet weak var fileIcon: NSImageView?
    
    override func awakeFromNib() {
    }
}
