//
//  DetailViewController.swift
//  TheDevConf2019
//
//  Created by Marlon Burnett on 27/11/19.
//  Copyright © 2019 Marlon Burnett. All rights reserved.
//

import UIKit
import YouTubePlayerSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var player: YouTubePlayerView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var loadingActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDate: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var viewModel: DetailViewModelContract!
    
    static func instantiate(viewModel: DetailViewModelContract) -> DetailViewController {
        let viewController = DetailViewController(nibName: "DetailViewController", bundle: nil)
        
        viewController.viewModel = viewModel
        
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            fatalError("ViewModel não especificada para DetailViewController")
        }
        
        setupContent()
        setupVideoPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupContent() {
        self.coverImageView.kf.setImage(with: viewModel.largeThumbnailUrl)
        self.titleLabel.text = viewModel.title
        self.publishDate.text = viewModel.publishDate
        self.descriptionLabel.text = viewModel.description
    }
    
    private func setupVideoPlayer() {
        NotificationCenter.default.addObserver(self, selector: #selector(videoDidLoad(_:)), name: .avPlayerViewControllerDidChangePlayerController, object: nil)
        
        self.player.play(videoID: viewModel.videoId)
    }
    
    @objc private func videoDidLoad(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self, name: .avPlayerViewControllerDidChangePlayerController, object: nil)
        DispatchQueue.main.async {
            self.coverImageView.isHidden = true
            self.loadingActivityIndicator.stopAnimating()
        }
    }
}
