//
//  ProfileViewController.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 26/09/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.colorPrimary.cgColor
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
    }
}
