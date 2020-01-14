//
//  NearbyUserTableViewCell.swift
//  MeetU
//
//  Created by Alexandre dos Santos Rodrigues on 14/01/2020.
//  Copyright © 2020 MeetU Inc. All rights reserved.
//

import UIKit

class NearbyUserTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
