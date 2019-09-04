//
//  ScanQRCodeViewController.swift
//  LA
//
//  Created by Okita Subaru on 9/4/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
   
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var libraryButton: UIButton!
    @IBOutlet weak var displayQRCodeButton: UIButton!
    
    let session = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var yourViewBorder = CAShapeLayer()
//        yourViewBorder.strokeColor = UIColor.black.cgColor
//        yourViewBorder.lineWidth = 5
//        let a  = scanView.frame.width - 10
//        yourViewBorder.lineDashPattern = [0, a] as [NSNumber]
//        yourViewBorder.frame = scanView.bounds
//        yourViewBorder.fillColor = nil
//        yourViewBorder.path = UIBezierPath(rect: scanView.bounds).cgPath
//        scanView.layer.addSublayer(yourViewBorder)
        
        self.openScanVideo()        
    }
    
    func openScanVideo() {
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            if let inputs = session.inputs as? [AVCaptureDeviceInput] {
                for input in inputs {
                    session.removeInput(input)
                }
            }
            
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session.addInput(input)
        }
        catch
        {
            print("ERROR")
        }
        
        if let outputs = session.outputs as? [AVCaptureMetadataOutput] {
            for output in outputs {
                session.removeOutput(output)
            }
        }
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.videoGravity = AVLayerVideoGravity.resizeAspectFill
        video.frame = scanView.layer.bounds
        
//        print(video.frame.width)
//        print(scanView.frame.width)
        scanView.layer.addSublayer(video)
        session.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count != 0 {
            if let object = metadataObjects[0] as? AVMetadataMachineReadableCodeObject{
                if object.type == AVMetadataObject.ObjectType.qr{
                    if let userId = object.stringValue {
                        session.stopRunning()
                        video.removeFromSuperlayer()
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let ReceiveViewController = storyBoard.instantiateViewController(withIdentifier: "receive") as! ReceiveViewController
                        ReceiveViewController.userID = Int(userId)
                        self.present(ReceiveViewController, animated: true, completion: nil)
                        
                    }
                }
            }
        }
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        
    }
    
    @IBAction func displayQRCode(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let QRCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qrcode") as! QRCodeViewController
        self.present(QRCodeViewController, animated: true, completion: nil)
    }
}
