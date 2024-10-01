//
//  ViewController.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 22/09/24.
//

import Kingfisher
import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet private var gameTableView: UITableView!

    @IBOutlet weak var emptyStateStackView: UIStackView!

    private var gameList: [GameModel] = []

    private var databaseService: DatabaseService?

    override func viewDidLoad() {
        super.viewDidLoad()
        databaseService = DatabaseService()
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.register(
            UINib(nibName: "GameTableViewCell", bundle: nil),
            forCellReuseIdentifier: "gameTableViewCell"
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllFavoriteGames()
    }

    func getAllFavoriteGames() {
        Task(priority: .background) {
            let favoriteGames = await databaseService?.getAllFavorites() ?? []
            let hasFavorites = !favoriteGames.isEmpty

            self.gameList = favoriteGames
            self.gameTableView.isHidden = !hasFavorites
            self.emptyStateStackView.isHidden = hasFavorites

            if hasFavorites {
                self.gameTableView.reloadData()
            } else {
                debugPrint("No favorite games found.")
            }
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        gameList.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "gameTableViewCell",
            for: indexPath
        ) as? GameTableViewCell {
            let game = gameList[indexPath.row]
            return setupCellView(cell: cell, game: game)
        }
        return UITableViewCell()
    }

    func setupCellView(cell: GameTableViewCell, game: GameModel) -> GameTableViewCell {
        cell.imageLoadingIndicator.isHidden = false
        cell.imageLoadingIndicator.startAnimating()

        cell.titleLabel.text = game.title
        cell.ratingLabel.text = "\(game.rating)"
        cell.releaseDateLabel.text = game.releaseDate

        cell.cardView.layer.cornerRadius = 16
        cell.cardView.layer.shadowColor = UIColor.black.cgColor
        cell.cardView.layer.shadowOpacity = 0.25
        cell.cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.cardView.layer.shadowRadius = 4
        cell.cardView.layer.masksToBounds = false
        cell.cardView.layer.backgroundColor = UIColor.white.cgColor

        cell.gameImage.layer.borderWidth = 0.5
        cell.gameImage.layer.masksToBounds = false
        cell.gameImage.layer.borderColor = UIColor.colorSecondary.cgColor
        cell.gameImage.layer.cornerRadius = 8
        cell.gameImage.clipsToBounds = true
        cell.gameImage.kf.setImage(
            with: URL(string: game.imageUrl),
            completionHandler: { _ in
                cell.imageLoadingIndicator.stopAnimating()
                cell.imageLoadingIndicator.isHidden = true
            }
        )
        return cell
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "moveToDetail", sender: gameList[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToDetail" {
            if let detaiViewController = segue.destination as? DetailViewController {
                detaiViewController.gameModel = sender as? GameModel
            }
        }
    }
}
