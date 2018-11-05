//
//  ViewController.swift
//  Benchmark
//
//  Created by Matthew Oross and John Brown on 9/10/18.
//  Copyright © 2018 Benchmark Systems, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* This function is linked to the "Info" button on the landing page.
    *  It opens a link using the default browser for the phone.
    */
    @IBAction func followLink(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://flyinghistory.com")! as URL, options: [:], completionHandler: nil)
    }
}
