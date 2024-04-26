//
//  RentalModal.swift
//  OneBoardProject
//
//  Created by 김건응 on 4/25/24.
//

import UIKit

class RentalModal: UIView {
    
    
    @IBOutlet weak var rentalView: UIView!
    
    @IBOutlet weak var kickBoardIdLabel: UILabel!
    
    @IBOutlet weak var kickBoardNumberLabel: UILabel!
    
    @IBOutlet weak var kickBoardImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var durationTimeLabel: UILabel!
    
    @IBOutlet weak var durationTimeNumberLabel: UILabel!
    
    @IBOutlet weak var returnBikeButton: UIButton!
    
    @IBOutlet weak var rentButton: UIButton!
    
    
    func viewDidLoad() {
        
        
        let kickboard = Kickboard.init(kickBoardID: "gge", kickBoardNumber: 12, kickBoardLocation: (2.4, 2.5), kickBoardStatus: true, pricePerMinute: 15)
        
        kickBoardIdLabel.text = kickboard.kickBoardID
        kickBoardNumberLabel.text = String(kickboard.kickBoardNumber)
        
        rentalView.layer.maskedCorners = CACornerMask.init(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        rentalView.layer.cornerRadius = 20
        
        cancelButton.layer.borderWidth = 1
        
        cancelButton.isHidden = false
        returnBikeButton.isHidden = true
        durationTimeLabel.isHidden = true
        durationTimeNumberLabel.isHidden = true
        
    }
    
    
    
    
}
