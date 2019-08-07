//
//  ViewController.swift
//  LA
//
//  Created by Nguyen Thi Lan Anh on 7/31/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import Koloda
import AVFoundation


class ViewController: UIViewController {


    @IBOutlet weak var kolodaView: KolodaView!
    @IBOutlet var cardView: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var friendAvatar: UIImageView!
    @IBOutlet weak var friendCard: UIView!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var labelText: UILabel!
    fileprivate var dataSource: [[String: String]] = [["name": "2", "avatar": "friendAvatar"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.friendCard.isHidden = true
        self.labelText.isHidden = true
    }
 
    @IBAction func reloadData(_ sender: Any) {
        let position = kolodaView.currentCardIndex
        dataSource.append(["name": "2", "avatar": "friendAvatar"])

        kolodaView.insertCardAtIndexRange(position..<position + 1, animated: true)
        self.friendCard.isHidden = true
        self.labelText.isHidden = true
    }
}

/*
 * Convert inputText to NSData and send to the speakers.
 * Check volume is turned up enough before doing so.
 */


extension ViewController: KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        print("lan anh")
        self.sendInput()
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] { return [.up] }
    
    func sendInput() {
        if AVAudioSession.sharedInstance().outputVolume < 0.1 {
            let errmsg = "Please turn the volume up to send messages"
            let alert = UIAlertController(title: "Alert", message: errmsg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let sdk = appDelegate.sdk {
                let text : String = "2  "
                if let data = text.data(using: .utf8) {
                    if let error = sdk.send(data) {
                        print(error.localizedDescription)
                        
                    }
                }
            }
        }
    }
}

// MARK: KolodaViewDataSource

extension ViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 1
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        print(dataSource[index]["avatar"]!)
        self.avatar.image = UIImage(named: dataSource[index]["avatar"]!)
        self.name.text = "userID: " + dataSource[index]["name"]!
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let sdk = appDelegate.sdk {
            sdk.sendingBlock = {
                (data : Data?, channel: UInt?) -> () in
                print("sending Block")
                return;
            }
            
            sdk.sentBlock = {
                (data : Data?, channel: UInt?) -> () in
                print("send Block")
                return;
            }
        }
        
        if let sdk2 = appDelegate.sdk2 {
            DispatchQueue.global(qos: .userInitiated).async {
                print("run in background")
                let multiTask = DispatchGroup()
                multiTask.enter()
                sdk2.receivingBlock = {
                    (channel: UInt?) -> () in
                    print("rêceving Block")
                    return;
                }
                
                sdk2.receivedBlock = {
                    (data : Data?, channel: UInt?) -> () in
                    print("rêcev Block")
                    if let data = data {
                        if let payload = String(data: data, encoding: .utf8) {
                            self.friendCard.isHidden = false
                            self.labelText.isHidden = false
                            
                            if payload == "1" {
                                self.friendAvatar.image = UIImage(named: "avatar")
                            } else {
                                self.friendAvatar.image = UIImage(named: "friendAvatar")
                            }
                            
                            if payload == self.dataSource[index]["name"] {
                                self.friendName.text = "It's you!!!!"
                            } else {
                                self.friendName.text = "FriendID: " + payload
                            }
                            

                            print(String(format: "Received: %@", payload))
                        } else {
                            print("Failed to decode payload!")
                        }
                    } else {
                        print("Decode failed!")
                    }
                    return;
                }
                
                multiTask.wait()
                
            }
        }
        return cardView
    }
  
}

