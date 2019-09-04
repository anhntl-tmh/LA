//
//  SendCardViewController.swift
//  LA
//
//  Created by Okita Subaru on 8/22/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import ImageIO
import Koloda
import AVFoundation
import MediaPlayer

class SendCardViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var swipeUp: UIImageView!
    @IBOutlet var card: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var kolodaView: CustomerKolodaView!
    @IBOutlet weak var sendID: UILabel!
    
    @IBOutlet weak var displayQRButton: UIButton!
    @IBOutlet weak var readQRButton: UIButton!
    
    fileprivate var dataSource: [[String: Any]] = [["sendID": 123456, "avatar": "image"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        swipeUp.image = UIImage.gif(name: "gif4")
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        displayQRButton.layer.cornerRadius = 5
        readQRButton.layer.cornerRadius = 5
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func displayQRCode(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let QRCodeViewController = storyBoard.instantiateViewController(withIdentifier: "qrcode") as! QRCodeViewController
        self.present(QRCodeViewController, animated: true, completion: nil)
    }
    
    @IBAction func readQRCode(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ScanQRCodeViewController = storyBoard.instantiateViewController(withIdentifier: "scanqrcode") as! ScanQRCodeViewController
        self.present(ScanQRCodeViewController, animated: true, completion: nil)
    }

}

extension SendCardViewController: KolodaViewDelegate {
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
       self.sendInput(index: index)
    }
    
    func koloda(_ koloda: KolodaView, allowedDirectionsForIndex index: Int) -> [SwipeResultDirection] { return [.up] }
    
    func sendInput(index: Int) {
        if AVAudioSession.sharedInstance().outputVolume < 0.001 {
            let errmsg = "Please turn the volume up to send messages"
            let alert = UIAlertController(title: "Alert", message: errmsg, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { (_) in
                let position = self.kolodaView.currentCardIndex
                self.dataSource.append(["sendID": 123456, "avatar": "image"])
                self.kolodaView.insertCardAtIndexRange(position..<position + 1, animated: true)
                MPVolumeView.setVolume(0.25)
            })
            self.present(alert, animated: true, completion: nil)
        } else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if let sdk = appDelegate.sdk {                
                let st = Converter.encode(number: self.dataSource[index]["sendID"]! as! Int)
                if let data = st.data(using: .utf8) {
                    if let error = sdk.send(data) {
                        print(error.localizedDescription)
                        
                    }
                }
            }
        }
    }
    
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
}

// MARK: KolodaViewDataSource

extension SendCardViewController: KolodaViewDataSource {
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 1
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        self.image.image = UIImage(named: dataSource[index]["avatar"]! as! String)
        
        if let id = dataSource[index]["sendID"] {
            self.sendID.text = "\(id)"
        }

        self.card.backgroundColor = .black
        
        
        
        //send card
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
                
                let alert = UIAlertController(title: "Send card successfully!", message: "", preferredStyle: UIAlertController.Style.alert)
                
                let backAction = UIAlertAction(title: "OK", style: .default) { (_) in
                    self.dismiss(animated: true) 
                }
                alert.addAction(backAction)
                
                let resendAction = UIAlertAction(title: "Resend", style: .default) { (_) in
               
                    
                    let position = self.kolodaView.currentCardIndex
                    self.dataSource.append(["sendID": 123456, "avatar": "image"])
                    self.kolodaView.insertCardAtIndexRange(position..<position + 1, animated: true)
                }
                alert.addAction(resendAction)
                
                self.present(alert, animated: true, completion: nil)

            }
        }
        return card
    }
    
}


extension UIImage {
    
    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("SwiftGif: Source for the image does not exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            print("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        
        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gif(data: imageData)
    }
    
    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            print("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }
        
        return gif(data: dataAsset.data)
    }
    
    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }
        
        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)
        
        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                                                             Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }
        
        return delay
    }
    
    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }
        
        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }
        
        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!
            
            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }
    
    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }
            
            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                                                            source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        // Calculate full duration
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        
        return animation
    }
    
}
