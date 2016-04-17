//
//  AddLoadViewController.swift
//  BackgroundTest
//
//  Created by Dean Woodward on 17/04/16.
//  Copyright © 2016 Dean Woodward. All rights reserved.
//

import UIKit
import Alamofire

class AddLoadViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitLoadButtonTapped(sender: UIButton) {
        let networkReachabilityManager = NetworkManager.networkReachabilityManager!
        
        if networkReachabilityManager.isReachable {
            submitLoad()
        } else {
            let title = "Network Unavailable"
            let message = "The load will be submitted when network availability is restored."
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: {_ in
                self.submitLoad()
            })
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func submitLoad() {
        Logger.sharedInstance.log("Submit Load Button Tapped")
        Logger.sharedInstance.demarcate()
        
        // does the whole post body need to be written to a file?
        
        guard let docketPath = NSBundle.mainBundle().pathForResource("docket", ofType: "jpg") else {
            print("No docket")
            return
        }
        let docketURL = NSURL(fileURLWithPath: docketPath)
    
        guard let packetPath = NSBundle.mainBundle().pathForResource("packet", ofType: "jpg") else {
            print("No packet")
            return
        }
        let packetURL = NSURL(fileURLWithPath: packetPath)
        
        let URL = NSURL(string: "http://bushdocketapp-api.stage.c3.co.nz/api")!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent("load"))
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        mutableURLRequest.setValue("abc123456786", forHTTPHeaderField: "DeviceId")
        mutableURLRequest.setValue("apikey eR6cIZYg3Soh87r65s654MN2491u1A3O", forHTTPHeaderField: "Authorization")
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        
        let manager = NetworkManager.backgroundManager
        manager.upload(mutableURLRequest, multipartFormData: { multipartFormData in
            multipartFormData.appendBodyPart(fileURL: docketURL, name: "Dkt1")
            multipartFormData.appendBodyPart(fileURL: packetURL, name: "DKT1_Pkt1")
            multipartFormData.appendBodyPart(data: "NPE".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "Destination")
            multipartFormData.appendBodyPart(data: "AKITIO".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "Carrier")
            multipartFormData.appendBodyPart(data: "reg1238".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "TruckRego")
            multipartFormData.appendBodyPart(data: "67853".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "FleetNumber")
            multipartFormData.appendBodyPart(data: "Rob".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "Driver")
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    
                    upload.progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                        dispatch_async(dispatch_get_main_queue()) {
                            let percent = (Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                            Logger.sharedInstance.log("Percent: \(percent)")
                        }
                    }
                    
                    // Should you use responseJSON? or another response method?
                    
                    upload.responseJSON { response in
                        debugPrint(response)
                        
                        let title = response.result.isSuccess ? "Success" : "Failure"
                        let message = response.result.isSuccess ? "Load submitted successfully." : "Error submitting load."
                        
                        if UIApplication.sharedApplication().applicationState == .Background {
                            let notification = UILocalNotification()
                            notification.alertTitle = title
                            notification.alertBody = message
                            notification.soundName = UILocalNotificationDefaultSoundName
                            notification.applicationIconBadgeNumber = 1
                            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
                        } else {
                            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                            alertController.addAction(okAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }

                        switch response.result {
                        case .Success(_):
                            print("In response result - success")
                            
                        case.Failure(_):
                            print("In response result - failure")
                        }
                        
                        let startTime = NSDate(timeIntervalSinceReferenceDate: response.timeline.requestStartTime)
                        let endTime = NSDate(timeIntervalSinceReferenceDate: response.timeline.requestCompletedTime)
                        let startTimeString = Logger.sharedInstance.timeFormatter.stringFromDate(startTime)
                        let endTimeString = Logger.sharedInstance.timeFormatter.stringFromDate(endTime)
                        
                        Logger.sharedInstance.log("Start Time was: \(startTimeString)")
                        Logger.sharedInstance.log("End Time was: \(endTimeString)")
                        Logger.sharedInstance.demarcate()
                        Logger.sharedInstance.log(response.debugDescription)
                        Logger.sharedInstance.demarcate(withDate: false)
                        
                                            }
                case .Failure(let encodingError):
                    print(encodingError)
                    Logger.sharedInstance.demarcate()
                    Logger.sharedInstance.log("\(encodingError)")
                    Logger.sharedInstance.demarcate(withDate: false)
                }
            }
        )

        
        
    }
    
}
