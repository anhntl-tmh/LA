//
//  QRCodeViewController.swift
//  LA
//
//  Created by Okita Subaru on 9/4/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var readQRCodeButton: UIButton!
    @IBOutlet weak var QRCodeImage: UIImageView!
    
    let userID = "123456"
    let session = AVCaptureSession()
    var video = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readQRCodeButton.layer.cornerRadius = 5
        downloadButton.layer.cornerRadius = 5
        
        let qrCodeImage = self.generateQRCode(from: userID)
        self.QRCodeImage.image = qrCodeImage
        
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Save QR Code Image successfully!", message: "", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func dowloadQRCode(_ sender: Any) {
        UIGraphicsBeginImageContext(self.QRCodeImage.frame.size)
        self.QRCodeImage.layer.render(in: UIGraphicsGetCurrentContext()!)
        let output = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(output, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @IBAction func readQRCode(_ sender: Any) {
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
        video.frame = view.layer.bounds
        view.layer.addSublayer(video)
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
}
