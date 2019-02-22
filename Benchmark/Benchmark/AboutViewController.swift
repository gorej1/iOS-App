//
//  AboutViewController.swift
//  Benchmark
//
//  Created by Elizabeth LoPresti on 2/20/19.
//  Copyright © 2019 Benchmark Systems, LLC. All rights reserved.
//
// This file contains code to control the About page view

import UIKit

class AboutViewController: UITableViewController {

    //MARK: Actions
    @IBAction func gotoHomepage(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://flyinghistory.com")! as URL, options: [:], completionHandler: nil)
    }
    
    @IBAction func gotoUDWebsite(_ sender: Any) {
        UIApplication.shared.open(URL(string:"https://udayton.edu/engineering/connect/innovation_center/index.php")! as URL, options: [:], completionHandler: nil)
    }
    
    //MARK: auto-generated
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
