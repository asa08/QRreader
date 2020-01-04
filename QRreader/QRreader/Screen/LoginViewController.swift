//
//  ViewController.swift
//  QRreader
//
//  Created by maiko morisaki on 2019/12/17.
//  Copyright © 2019 _asa08_. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension LoginViewController: AVCaptureMetadataOutputObjectsDelegate {

    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        self.captureSession.stopRunning()
        guard let objects = metadataObjects as? [AVMetadataObject] else { return }
        var detectionString: String? = nil
        let barcodeTypes = [AVMetadataObject.ObjectType.ean8, AVMetadataObject.ObjectType.ean13]
        for metadataObject in objects {
            loop: for type in barcodeTypes {
                guard metadataObject.type == type else { continue }
                guard self.capturePreviewLayer.transformedMetadataObjectForMetadataObject(metadataObject) is AVMetadataMachineReadableCodeObject else { continue }
                if let object = metadataObject as? AVMetadataMachineReadableCodeObject {
                    detectionString = object.stringValue
                    break loop
                }
            }
            var text = ""
            guard let value = detectionString else { continue }
            text += "読み込んだ値:\t\(value)"
            text += "\n"
//            guard let isbn = convartISBN(value) else { continue }
//            text += "ISBN:\t\(isbn)"
//            resultTextLabel?.text = text
            let URLString = String(format: "http://amazon.co.jp/dp/%@", isbn)
            guard let URL = NSURL(string: URLString) else { continue }
            UIApplication.sharedApplication().openURL(URL)
        }
        self.captureSession.startRunning()
    }
}

