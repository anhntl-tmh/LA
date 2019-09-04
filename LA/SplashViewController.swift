//
//  SplashViewController.swift
//  LA
//
//  Created by Okita Subaru on 8/23/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var loadingImage: UIImageView!
    var userID : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingImage.image = UIImage.gif(name: "loading")
        // Do any additional setup after loading the view.
        self.findCard()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
        
    }
    
    func findCard() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if let sdk2 = appDelegate.sdk2 {
            DispatchQueue.global(qos: .userInitiated).async {
                print("run in background")
                
                sdk2.receivingBlock = {
                    (channel: UInt?) -> () in
                    print("rêceving Block")
                    self.status.text = "Listening..."
                    self.status.textColor = .red
                    return;
                }
                
                sdk2.receivedBlock = {
                    (data : Data?, channel: UInt?) -> () in
                    print("rêcev Block")

                    if let data = data {
                        if let payload = String(data: data, encoding: .utf8) {

                            self.userID = Converter.decode(encoded: payload)
  
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let ReceiveViewController = storyBoard.instantiateViewController(withIdentifier: "receive") as! ReceiveViewController
                            ReceiveViewController.userID = self.userID
                            self.present(ReceiveViewController, animated: true, completion: nil)
                            
                        } else {
                            print("Failed to decode payload!")
                        }
                    } else {
                        print("Decode failed!")
                    }
                    return;
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("aaaaaa")
        if segue.destination is ReceiveViewController
        {
            let vc = segue.destination as? ReceiveViewController
            vc?.userID = self.userID
        }
    }

}
