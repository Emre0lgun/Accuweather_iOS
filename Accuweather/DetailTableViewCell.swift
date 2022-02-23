//
//  DetailTableViewCell.swift
//  Accuweather
//
//  Created by Emre OLGUN on 22.02.2022.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var dateTxt: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var cTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
