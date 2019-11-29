//
//  ReserveFileTableViewCell.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class MostPopularMovieTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var yearOfReleaseLabel: UILabel?
    @IBOutlet weak var posterImageView: UIImageView?
    @IBOutlet weak var overviewLabel: UILabel?
    @IBOutlet weak var shadowView: UIView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.shadowView?.addShadow(to: [.top, .bottom, .left, .right], radius: 100)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
