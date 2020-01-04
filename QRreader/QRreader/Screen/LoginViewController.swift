//
//  ViewController.swift
//  QRreader
//
//  Created by maiko morisaki on 2019/12/17.
//  Copyright © 2019 _asa08_. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var caputureView: UIView!
    @IBOutlet weak var textLavel: UILabel!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    private let session = AVCaptureSession()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        initDeviceCamera()
        intiButton()
    }
    
    private func intiButton() {
        readButton.rx.tap
        .subscribe { [weak self] _ in self?.reRead() }
        .disposed(by: disposeBag)
    }
    
    private func reRead() {
        caputureView.isHidden = false
        session.startRunning()
    }
    
    private func initDeviceCamera() {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back)
        
        let devices = discoverySession.devices
        if let backCamera = devices.first {
            do {
                let deviceInput = try AVCaptureDeviceInput(device: backCamera)
                doInit(deviceInput: deviceInput)
            } catch {
                print("Error occured while creating video device input: \(error)")
            }
        }
    }
    
    private func doInit(deviceInput: AVCaptureDeviceInput) {
        if !session.canAddInput(deviceInput) { return }
        session.addInput(deviceInput)
        let metadataOutput = AVCaptureMetadataOutput()
        
        if !session.canAddOutput(metadataOutput) { return }
        session.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        caputureView.layer.addSublayer(previewLayer)
        
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        for metadata in metadataObjects as! [AVMetadataMachineReadableCodeObject] {
            // QRのtype： metadata.type
            // QRの中身： metadata.stringValue
            guard let value = metadata.stringValue else { return }
            
            session.stopRunning()
            textLavel.text = value
            caputureView.isHidden = true
        }
    }
}


