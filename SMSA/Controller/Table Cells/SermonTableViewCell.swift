//
//  SermonTableViewCell.swift
//  SMSA
//
//  Created by Matthew Androus on 9/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit

class SermonTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        titleLabel.text = "blah"
//        descriptionLabel.text = "blah"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
