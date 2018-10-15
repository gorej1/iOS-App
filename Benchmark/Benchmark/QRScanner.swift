//
//  QRScanner.swift
//  Benchmark
//
//  Created by Elizabeth LoPresti on 10/1/18.
//  Copyright © 2018 Benchmark Systems, LLC. All rights reserved.
//

import Foundation
//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession!
    var videoPreviewLayer:AVCaptureVideoPreviewLayer!
    //var qrCodeFrameView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view.
        // Get the back-facing camera for capturing videos
        captureSession = AVCaptureSession()
        //let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        let videoInput: AVCaptureDeviceInput
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        if (captureSession.canAddInput(videoInput)){
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)){
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.frame = view.layer.bounds
        videoPreviewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(videoPreviewLayer, at: 0)
        //view.layer.addSublayer(videoPreviewLayer, at)
        //view.subl
        /*var backButton = UIButton()
        view.addSubview(backButton)
        view.bringSubview(toFront: backButton)*/
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title:"Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            }
        dismiss(animated: true)
        }
    

    func found(code: String) {
        let url: NSURL = NSURL(string: "https://flyinghistory.com/geturl.php")!
        let request:NSMutableURLRequest = NSMutableURLRequest(url:url as URL)
        let bodyData = "code=\(code)"
    
        request.httpMethod = "POST"
        request.httpBody = bodyData.data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            var urlString = responseString as String
            var urlString1 = urlString.dropFirst(9)
            if let dotRange = urlString1.range(of: "\""){
                urlString1.removeSubrange(dotRange.lowerBound..<urlString1.endIndex)
            }
            var urlString2 = String(urlString1)
            // need to remove all instances of "/"
            let trimmedString = urlString2.replacingOccurrences(of: "\\", with: "")
            print(trimmedString)
            if let url = URL(string: trimmedString),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
            //UIApplication.shared.open(URL(string:trimmedString)! as URL)

        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
