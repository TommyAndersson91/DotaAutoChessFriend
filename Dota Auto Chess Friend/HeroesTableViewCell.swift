//
//  HeroesTableViewCell.swift
//  Dota Auto Chess Friend
//
//  Created by Tommy Andersson on 2019-03-25.
//  Copyright © 2019 Tommy Andersson. All rights reserved.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var heroThumb: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroRace: UILabel!
    @IBOutlet weak var heroClass: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
