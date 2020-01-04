//
//  ViewController.swift
//  QRreader
//
//  Created by maiko morisaki on 2019/12/17.
//  Copyright © 2019 _asa08_. All rights reserved.
//

import UIKit
import AVFoundation

class LoginViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    private let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                mediaType: .video,
                                                                position: .back)
        
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                if session.canAddInput(deviceInput) {
                    session.addInput(deviceInput)
                    
                    let metadataOutput = AVCaptureMetadataOutput()
                    
                    if session.canAddOutput(metadataOutput) {
                        session.addOutput(metadataOutput)
                        
                        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                        metadataOutput.metadataObjectTypes = [.qr]
                        
                        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                        previewLayer.frame = view.bounds
                        previewLayer.videoGravity = .resizeAspectFill
                        view.layer.addSublayer(previewLayer)
                        
                        session.startRunning()
                    }
                }
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRのtype： metadata.type
            // QRの中身： metadata.stringValue
            guard let value = metadata.stringValue else { return }
            print(value)
            session.stopRunning()

            view.layer.sublayers?.removeAll()
        }
    }
}


