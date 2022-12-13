//
//  ForecastTableViewCell.swift
//  Weather
//
//  Created by Robert Lin on 2022/12/13.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
