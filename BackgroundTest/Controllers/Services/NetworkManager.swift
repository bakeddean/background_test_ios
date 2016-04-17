//
//  Manager.swift
//  BackgroundTest
//
//  Created by Dean Woodward on 17/04/16.
//  Copyright © 2016 Dean Woodward. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    //static let sharedManager: Manager = Manager()
    
    static let backgroundManager: Alamofire.Manager = {
        let bundleIdentifier = "com.gmail.bakeddean.BackgroundTest"
        return Alamofire.Manager(configuration: NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(bundleIdentifier + ".Background"))
    }()
    
    var backgroundCompletionHandler: (() -> Void)? {
        get {
            return NetworkManager.backgroundManager.backgroundCompletionHandler
        }
        set {
            NetworkManager.backgroundManager.backgroundCompletionHandler = newValue
        }
    }
    
    static let networkReachabilityManager = NetworkReachabilityManager(host: "http://bushdocketapp-api.stage.c3.co.nz")

}