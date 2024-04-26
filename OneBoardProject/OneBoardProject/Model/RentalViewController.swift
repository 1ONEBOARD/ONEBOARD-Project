//
//  RentalViewController.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/26/24.
//

import UIKit

class RentalViewController: UIViewController {

    var rentalmodal: RentalModal!
    var rentalKickboardData: Kickboard?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupRentalModal()
        
        rentalmodal.cancelAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupRentalModal() {
        rentalmodal = RentalModal()
        
        view.addSubview(rentalmodal)
        rentalmodal.frame = view.bounds
        
        guard let rentalKickboardData = rentalKickboardData else { return }
        
        rentalmodal.kickBoardIdLabel.text = rentalKickboardData.kickBoardID
        rentalmodal.kickBoardNumberLabel.text = "\(rentalKickboardData.kickBoardNumber)"
        rentalmodal.kickboardData = rentalKickboardData
    }
}
