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
    
    
    @IBOutlet weak var friendCard: UIView!
    @IBOutlet weak var sendID: UILabel!
    @IBOutlet weak var RecieveID: UILabel!
    @IBOutlet weak var status: UILabel!
    
    fileprivate var dataSource: [[String: String]] = [["name": "2", "avatar": "friendAvatar"]]
    let n = 777777
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        kolodaView.dataSource = self
        kolodaView.delegate = self
        self.sendID.text = "\(n)"
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
 
    @IBAction func reloadData(_ sender: Any) {
        
        self.RecieveID.text = ""
        self.status.text = ""
        
        let position = kolodaView.currentCardIndex
        dataSource.append(["name": "2", "avatar": "friendAvatar"])

        kolodaView.insertCardAtIndexRange(position..<position + 1, animated: true)
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
                //get second of current time
//                let date = Date()
//                var calendar = Calendar.current
//                calendar.timeZone = TimeZone(identifier: "UTC")!
//                let seconds = calendar.component(.second, from: date)

            
                //conver to hexa
//                var st = String(format:"%02X", n)
//                if seconds < 10 {
//                    let tmp = "0" + String(seconds)
//                    st.append(String(tmp))
//                } else {
//                    st.append(String(seconds))
//                }
//
//                print("hexa of id \(st) and type of object is : \(type(of: st))")
                
                let st = Converter.encode(number: n)
                if let data = st.data(using: .utf8) {
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
        self.name.text = "Swipe to send card"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let sdk = appDelegate.sdk {
            sdk.sendingBlock = {
                (data : Data?, channel: UInt?) -> () in
                print("sending Block")
                self.status.text = "Sending Card"
                self.status.textColor = .green
                return;
            }
            
            sdk.sentBlock = {
                (data : Data?, channel: UInt?) -> () in
                print("send Block")
                self.status.text = "Send Card"
                self.status.textColor = .red
                return;
            }
        }
        
        if let sdk2 = appDelegate.sdk2 {
            DispatchQueue.global(qos: .userInitiated).async {
                print("run in background")
               
                sdk2.receivingBlock = {
                    (channel: UInt?) -> () in
                    print("rêceving Block")
                    self.status.text = "Recieving Card"
                    self.status.textColor = .blue
                    return;
                }
                
                sdk2.receivedBlock = {
                    (data : Data?, channel: UInt?) -> () in
                    print("rêcev Block")
                    self.status.text = "Recieved Card"
                    self.status.textColor = .red
                    if let data = data {
                        if let payload = String(data: data, encoding: .utf8) {
                            //decode hexa
//                            let start = String.Index.init(utf16Offset: 0, in: payload)
//                            let end = String.Index.init(utf16Offset: payload.count-2, in: payload)
//                            let substr : String
//                            substr = String(payload[start..<end])
//
                            print("day so nhan duoc la \(payload)")
//
//                             let anh = Int(substr, radix: 16)!
                            
                            //decode using COnverter
                            let anh = Converter.decode(encoded: payload)
                      
                            self.RecieveID.text = "\(String(describing: anh))"
                            
                            print("id gui la \(String(describing: anh))")
                            

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
        return cardView
    }
  
}

