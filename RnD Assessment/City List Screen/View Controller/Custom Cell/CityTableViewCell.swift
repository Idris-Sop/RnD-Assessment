//
//  CityTableViewCell.swift
//  RnD Assessment
//
//  Created by Idris Sop on 2021/05/17.
//

import UIKit

class CityTableViewCell: UITableViewCell {

    @IBOutlet private var cityNameLabel: UILabel?
    @IBOutlet private var countryCodeLabel: UILabel?
    @IBOutlet private var cityLatitudeLabel: UILabel?
    @IBOutlet private var cityLongitudeLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populateCellWith(cityName: String, countryCode: String, latitude: Double, longitude: Double) {
        cityNameLabel?.text = String(format: "City: %@", cityName)
        countryCodeLabel?.text = String(format: "Country: %@", countryCode)
        cityLatitudeLabel?.text = String(format: "Latitude: %.6f", latitude)
        cityLongitudeLabel?.text = String(format: "Longitude: %.6f", longitude)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

