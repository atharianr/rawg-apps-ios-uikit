//
//  DetailViewController.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 25/09/24.
//

import UIKit
import UIView_Shimmer
import Kingfisher

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

    @IBOutlet weak var favoriteButton: UIBarButtonItem!

    var gameModel: GameModel?

    private var databaseService: DatabaseService?

    private var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()

        databaseService = DatabaseService()

        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        checkIsAlreadyFavorite()
        getGameDetail()
    }

    @IBAction func setFavorite(_ sender: UIBarButtonItem) {
        isFavorite.toggle()

        if isFavorite {
            addFavorite()
        } else {
            deleteFavorite()
        }

        favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
    }

    private func addFavorite() {
        Task(priority: .background) {
            let game = GameModel(
                id: gameModel?.id ?? 0,
                title: gameModel?.title ?? "",
                rating: gameModel?.rating ?? 0.0,
                releaseDate: gameModel?.releaseDate ?? "",
                imageUrl: gameModel?.imageUrl ?? ""
            )
            let gameId = await databaseService?.addFavorite(game)
            debugPrint("gameId: \(gameId!)")
        }
    }

    private func deleteFavorite() {
        Task(priority: .background) {
            if let gameId = gameModel?.id {
                let isDeleted = await databaseService?.deleteFavorite(gameId)
                debugPrint("\(gameId) isDeleted: \(isDeleted ?? false)")
            } else {
                debugPrint("gameModel is nil, deletion not attempted.")
            }
        }
    }

    private func checkIsAlreadyFavorite() {
        Task(priority: .background) {
            if let gameId = gameModel?.id {
                isFavorite = await databaseService?.isAlreadyFavorite(gameId) ?? false
                favoriteButton.image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
                debugPrint("\(gameId) isFavorite: \(isFavorite)")
            } else {
                debugPrint("gameModel is nil, check favorite not attempted.")
            }
        }
    }

    private func getGameDetail() {
        let network = NetworkService()
        network.getGameDetail(id: gameModel?.id ?? 0, completion: { game in
            self.bindData(gameDetailModel: game)
        })
    }

    private func setupView() {
        view.setTemplateWithSubviews(true, viewBackgroundColor: .gray)

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
            gameRatingLabel.text = "\(game.rating)/5"
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
