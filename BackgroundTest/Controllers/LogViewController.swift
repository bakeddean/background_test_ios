//
//  LogViewController.swift
//  BackgroundTest
//
//  Created by Dean Woodward on 17/04/16.
//  Copyright © 2016 Dean Woodward. All rights reserved.
//

import UIKit

class LogViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let resetButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: #selector(LogViewController.resetLog(_:)))
        navigationItem.rightBarButtonItem = resetButton
        textView.text = Logger.sharedInstance.logText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetLog(sender: UIBarButtonItem) {
        Logger.sharedInstance.reset()
        textView.text = Logger.sharedInstance.logText()
    }
    
}
