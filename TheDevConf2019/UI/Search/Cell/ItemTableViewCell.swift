//
//  ItemTableViewCell.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit
import Kingfisher

class ItemTableViewCell: SelectionClearTableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var playIconImageView: UIImageView!
    
    private var downloadTask: DownloadTask? = nil
    
    static let nib = { UINib(nibName: "ItemTableViewCell", bundle: nil) }()
    static let identifier = "ItemTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        
        if #available(iOS 13, *) {
            playIconImageView.image = UIImage(systemName: "play.fill")
        } else {
            playIconImageView.image = UIImage(named: "play-icon")
        }
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        thumbnailImageView.image = nil
    }
    
    func configure(title: String, description: String, thumbnailUrl: URL) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.downloadTask = thumbnailImageView.kf.setImage(with: thumbnailUrl, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (_) in
            self.downloadTask = nil
        })
    }
}
