//
//  ExchangeCardViewController.swift
//  LA
//
//  Created by Okita Subaru on 8/22/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import AVFoundation

class ExchangeCardViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var displayQRButton: UIButton!
    @IBOutlet weak var readQRButton: UIButton!
    
    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayQRButton.layer.cornerRadius = 5
        readQRButton.layer.cornerRadius = 5
        
//        self.view.backgroundColor = UIColorFromHex(0xf2f2f2ff, alpha: 1)
    }

    @IBAction func send(_ sender: Any) {
        
        let SendCardViewController = storyBoard.instantiateViewController(withIdentifier: "sendCard") as! SendCardViewController
        self.present(SendCardViewController, animated: true, completion: nil)
    }
    
    @IBAction func receive(_ sender: Any) {
        let SplashViewController = storyBoard.instantiateViewController(withIdentifier: "splash") as! SplashViewController
        self.present(SplashViewController, animated: true, completion: nil)
    }
    
    @IBAction func displayQRCode(_ sender: Any) {
        let QRCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qrcode") as! QRCodeViewController
        self.present(QRCodeViewController, animated: true, completion: nil)
    }
    
    @IBAction func readQRCode(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ScanQRCodeViewController = storyBoard.instantiateViewController(withIdentifier: "scanqrcode") as! ScanQRCodeViewController
        self.present(ScanQRCodeViewController, animated: true, completion: nil)
    }
    
}

