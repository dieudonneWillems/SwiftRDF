//
//  ProgressDelegate.swift
//  
//
//  Created by Don Willems on 26/02/16.
//
//

import Foundation

/**
 Instances of this protocal can be used by some time consuming functions/classes to propegate progress information that
 can be presented to the user.
 */
public protocol ProgressDelegate {
    
    /**
     This function is called when a time consuming process has been started.
     
     - parameter progressTitle: The main title that can be used by the user to identify the process whose progress is
     being presented. In most cases the title remains the same during one time-consuming task.
     - parameter progressSubtitle: A subtitle that can be used by the user to identify the process whose progress is
     being presented. The subtitle will be updated several times during a time-consuming taks. The subtitle may are
     may not be presented to the user.
     - parameter object: The object which is running the task.
     */
    func taskStarted(progressTitle : String, progressSubtitle : String, object: AnyObject?)
    
    /**
     This function is called by a time consuming processes to update progress information to be presented to the user.
     The time consuming process should execute this method in the main (GUI) thread.
     
     - parameter progressTitle: The main title that can be used by the user to identify the process whose progress is 
     being presented. In most cases the title remains the same during one time-consuming task.
     - parameter progressSubtitle: A subtitle that can be used by the user to identify the process whose progress is
     being presented. The subtitle will be updated several times during a time-consuming taks. The subtitle may are
     may not be presented to the user.
     - parameter progress: A numerical representation of the progress. The maximum value would be equal to the 
     `target` parameter, if it can be determined at all.
     - parameter target: The target value of the numerical representation of the progress. If this value is `nil`,
     the progress is indeterminate.
     - parameter object: The object which is running the task.
     */
    func updateProgress(progressTitle : String, progressSubtitle : String, progress : Double, target : Double?, object: AnyObject?)
    
    
    /**
     This function is called when a time consuming process has finished.
     
     - parameter progressTitle: The main title that can be used by the user to identify the process whose progress is
     being presented. In most cases the title remains the same during one time-consuming task.
     - parameter progressSubtitle: A subtitle that can be used by the user to identify the process whose progress is
     being presented. The subtitle will be updated several times during a time-consuming taks. The subtitle may are
     may not be presented to the user.
     - parameter object: The object which is running the task.
     */
    func taskFinished(progressTitle : String, progressSubtitle : String, object: AnyObject?)
}