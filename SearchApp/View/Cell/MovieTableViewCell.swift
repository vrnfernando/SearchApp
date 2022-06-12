//
//  MovieTableViewCell.swift
//  SearchApp
//
//  Created by Vishwa Fernando on 6/12/22.
//  Copyright © 2022 ncs. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lb_title: UILabel!
    @IBOutlet weak var lb_genre: UILabel!
    @IBOutlet weak var lb_adventure: UILabel!
    @IBOutlet weak var img_view: UIImageView!
    
    var representedIdentifier: String = ""
    
    var img: UIImage? {
        didSet{
            img_view.image = img
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
