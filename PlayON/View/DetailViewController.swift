//
//  DetailViewController.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import UIKit
import UIView_Shimmer

extension UILabel: @retroactive ShimmeringViewProtocol {}

class DetailViewController: UIViewController {
    
    @IBOutlet weak var gameImage: UIImageView!
    
    @IBOutlet weak var smallGameImage: UIImageView!
    
    @IBOutlet weak var imageOverlayView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    
    @IBOutlet weak var gamePublisherLabel: UILabel!
    
    @IBOutlet weak var gamePlatformLabel: UILabel!
    
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    @IBOutlet weak var gameReleaseDateLabel: UILabel!
    
    @IBOutlet weak var gameEsrbRatingLabel: UILabel!
    
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    var gameModel: GameModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getGameDetail()
    }
    
    func getGameDetail() {
        let network = NetworkService()
        network.getGameDetail(id: gameModel?.id ?? 0, completion: { game in
            self.bindData(gameDetailModel: game)
        })
    }
    
    private func setupView() {
        view.setTemplateWithSubviews(true, viewBackgroundColor: UIColor.gray)
        
        smallGameImage.layer.masksToBounds = false
        smallGameImage.layer.cornerRadius = 8
        smallGameImage.clipsToBounds = true
        
        gameImage.layer.masksToBounds = false
        gameImage.layer.cornerRadius = 16
        gameImage.clipsToBounds = true
        
        imageOverlayView.layer.masksToBounds = false
        imageOverlayView.layer.cornerRadius = 16
        imageOverlayView.clipsToBounds = true
    }
    
    private func bindData(gameDetailModel: GameDetailModel?) {
        if let game = gameDetailModel {
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            
            gameTitleLabel.text = game.title
            gamePublisherLabel.text = game.publisher
            gamePlatformLabel.text = game.platform
            gameRatingLabel.text = "\(game.rating)/\(game.ratingTop)"
            gameReleaseDateLabel.text = game.releaseDate
            gameEsrbRatingLabel.text = game.esrbRating
            gameDescriptionLabel.text = game.description
            
            smallGameImage.kf.setImage(
                with: URL(string: game.imageUrl),
                completionHandler: { _ in
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                }
            )
            
            gameImage.kf.setImage(
                with: URL(string: game.imageAdditionalUrl),
                completionHandler: { _ in
                    self.loadingIndicator.stopAnimating()
                    self.loadingIndicator.isHidden = true
                }
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.view.setTemplateWithSubviews(false)
            }
        }
    }
}
