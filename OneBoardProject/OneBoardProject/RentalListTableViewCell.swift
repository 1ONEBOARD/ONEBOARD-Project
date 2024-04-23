//
//  RentalListTableViewCell.swift
//  OneBoardProject
//
//  Created by 배지해 on 4/23/24.
//

import UIKit

class RentalListTableViewCell: UITableViewCell {

    @IBOutlet weak var rentalStartTimeLabel: UILabel!
    @IBOutlet weak var kickBoardIDLabel: UILabel!
    @IBOutlet weak var kickBoardNumberLabel: UILabel!
    @IBOutlet weak var rentalTimeLabel: UILabel!
    @IBOutlet weak var rentalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
