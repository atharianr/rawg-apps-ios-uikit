//
//  ProfileDummyData.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 02/10/24.
//

import Foundation
import UIKit

class ProfileDummyData {
    func addDummyData(completion: @escaping () -> Void) {
        ProfileModel.name = "Atharian Rahmadani"
        ProfileModel.occupation = "Android Developer"
        ProfileModel.organization = "XL Axiata Tbk"
        ProfileModel.image = imageToData("ProfilePicture") ?? Data()
        completion()
    }

    private func imageToData(_ title: String) -> Data? {
        guard let img = UIImage(named: title) else { return nil }
        return img.jpegData(compressionQuality: 1)
    }
}
