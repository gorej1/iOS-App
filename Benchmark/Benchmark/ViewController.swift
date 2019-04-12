//
//  ViewController.swift
//  Benchmark
//
//  Created by Matthew Oross and John Brown on 9/10/18.
//  Copyright © 2018 Benchmark Systems, LLC. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Picker View
    @IBOutlet weak var topicPicker: UIPickerView!
    let topics = ["Select topic", "Evolution of Flight", "Mary Apparitions", "More topics coming soon!"]
    let topicURLs = ["", "http://evolutionofflight.com", "https://sites.google.com/a/udayton.edu/maryapparitions", ""]
    
    @IBAction func goTopic(_ sender: Any) {
        let row = topicPicker.selectedRow(inComponent: 0)
        if topicURLs[row] == "" {
            return // Intentional do nothing
        }
        UIApplication.shared.open(URL(string:topicURLs[row])! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return topics.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return topics[row]
    }
    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if topicURLs[row] == "" {
//            return // Intentional do nothing
//        }
//        UIApplication.shared.open(URL(string:topicURLs[row])! as URL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
//    }

    //MARK: Auto-generated
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topicPicker.delegate = self
        topicPicker.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

