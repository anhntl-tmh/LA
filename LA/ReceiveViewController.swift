//
//  ReceiveViewController.swift
//  LA
//
//  Created by Okita Subaru on 8/22/19.
//  Copyright © 2019 Nguyen Thi Lan Anh. All rights reserved.
//

import UIKit
import Koloda

class ReceiveViewController: UIViewController {
    @IBOutlet weak var card: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var sendID: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var userID : Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        card.isHidden = false
        //shake card
        let cardviewCenterXOriginal = card.center.x
        let cardviewCenterYOriginal = card.center.y
        
        card.center.x = -500
        card.center.y = -500
        card.transform = CGAffineTransform(rotationAngle: CGFloat.pi)

        UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .transitionCrossDissolve, animations: ({
            self.card.center.x = cardviewCenterXOriginal
            self.card.center.y = cardviewCenterYOriginal
            self.card.transform = CGAffineTransform(rotationAngle: 0)
        }), completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.layer.cornerRadius = 5
        cancelButton.layer.cornerRadius = 5
        
        image.layer.borderWidth = 1
        image.layer.masksToBounds = false
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.cornerRadius = image.frame.height/2
        image.clipsToBounds = true

        card.isHidden = true
        
        if let id = userID {
            self.sendID.text = "\(id)"
            
            if id == 123456 {
                self.image.image = UIImage(named: "image")
                self.card.backgroundColor = .black
            } else if id == 987  {
                self.image.image = UIImage(named: "avatar")
                self.card.backgroundColor = .gray
            } else {
                self.image.image = UIImage(named: "avatar2")
                self.card.backgroundColor = .red
            }
        }
        print("receiceVC : \(String(describing: userID)))")
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let ExchangeCardViewController = storyBoard.instantiateViewController(withIdentifier: "exchangeCard") as! ExchangeCardViewController
        self.present(ExchangeCardViewController, animated: true, completion: nil)
    }
    
}


