//
//  QRScanner.swift
//  Benchmark
//
//  Created by Matthew Oross and John Brown on 10/1/18.
//  Copyright © 2018 Benchmark Systems, LLC. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //MARK: Variables
    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
        
    //MARK: Navigation
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        
        // Start a video capture session
        captureSession = AVCaptureSession()
        
        // Tries to get the default camera device for video
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            // Print an error message if a device is not found
            print("Failed to get the camera device")
            return
        }
        // Create an AVCaptureDeviceInput object
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Add the video input to the capture session
        if (captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else {
            // If the input can't be added call the failed function
            failed()
            return
        }
        // Create an AVCaptureMetadataOutput object
        let metadataOutput = AVCaptureMetadataOutput()
        // Try to add the output to the capture session
        if (captureSession.canAddOutput(metadataOutput)){
            // If successful, add the output and set object delegates
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            // If unsuccessful, call the failed function
            failed()
            return
        }
        
        // Define the video preview layer to use the capture session
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        // Set the preview layer to cover the whole screen
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        
        // Add the preview layer to the main view
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        
        // Start the capture session
        captureSession.startRunning()
    }
    
    // This function opens an alert to inform the user that their device does not support QR scanning
    func failed() {
        self.showError(message: "Your device does not support QR code scanning. Please use a device with a camera.")
        captureSession = nil
    }
    
    // This function starts running the capture session when the view appears if not already running
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    // This function stops the capture session when the view disappears if still running
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    // This function sets the metadata output needed to use the QR library
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            // This causes the phone to vibrate on a successful QR scan
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            // Run the found function once QR is scanned successfully
            found(code: stringValue)
            }
        dismiss(animated: true)
        }
    
    // This function is run once a QR code is successfully detected
    func found(code: String) {
        // Setting up the URL to use the PHP script on the website
        // TODO: Update this URL once we get websites migrated
        let url: NSURL = NSURL(string: "https://flyinghistory.com/geturl.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        let bodyData = "code=\(code)"

        // Set up a POST request to the PHP script to request the correct URL
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            // Print the error code to the terminal, if one occurs
            if error != nil {
                //let errString = error as! String
                let errString = error!.localizedDescription
                print("error=\(errString)")
                self.showError(message: errString)
                return
            }
            // Store the raw data returned from the PHP script
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            let urlString = responseString as String
            // Trim off all the unnecessary info from response
            var urlString1 = urlString.dropFirst(9)
            if let dotRange = urlString1.range(of: "\""){
                urlString1.removeSubrange(dotRange.lowerBound..<urlString1.endIndex)
            }
            let urlString2 = String(urlString1)
            // Remove all instances of "/" from the URL string
            let trimmedString = urlString2.replacingOccurrences(of: "\\", with: "")
            // If the URL can be opened, open it using the default browser
            DispatchQueue.main.async {
                if let url = URL(string: trimmedString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    self.showError(message: "Invalid QR code.")
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showError(message: String) {
        DispatchQueue.main.async{
            let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            errorAlertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(errorAlertController, animated: true, completion: nil)
        }
    }
    

    @IBAction func toggleFlashlight(_ sender: Any) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do{
                try device.lockForConfiguration()
                
                if device.torchMode == .on {
                    device.torchMode = .off
                } else {
                    device.torchMode = .on
                }
                
                device.unlockForConfiguration()
            } catch {
                print("Error accessing flashlight")
            }
        } else {
            print("No flashlight available")
        }
    }
}
