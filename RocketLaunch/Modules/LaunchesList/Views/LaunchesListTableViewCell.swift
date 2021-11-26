//
//  LaunchesListTableViewCell.swift
//  RocketLaunch
//
//  Created by Django on 2021/11/26.
//

import UIKit
import Kingfisher

public final class LaunchesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var _imageV: UIImageView!
    @IBOutlet private weak var _nameLabel: UILabel!
    @IBOutlet private weak var _statusLabel: UILabel!
    @IBOutlet private weak var _launchNumberLabel: UILabel!
    @IBOutlet private weak var _detailsLabel: UILabel!
    @IBOutlet private weak var _dateLabel: UILabel!

    public var model: ServerLaunchesListModelRes? {
        didSet {
            _imageV.kf.indicatorType = .activity
            _imageV.kf.setImage(with: model?.links.patch.small?.urlValue) { _ in }
            _nameLabel.text = model?.name
            let status: String
            if model?.success == true {
                status = "Success"
            } else if model?.upcoming == true {
                status = "Upcoming"
            } else {
                status = "Error status"
            }
            _statusLabel.text = status
            _launchNumberLabel.text = model?.flight_number.stringValue
            _detailsLabel.text = model?.details
            _dateLabel.text = model?.date_local
        }
    }
    public var isEven: Bool = false {
        didSet {
            backgroundColor = isEven ? .lightGray : .white
        }
    }
}
