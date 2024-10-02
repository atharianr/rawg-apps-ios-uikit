//
//  ProfileModel.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 02/10/24.
//

import Foundation

struct ProfileModel {
    static let nameKey = "name"
    static let occupationKey = "occupation"
    static let organizationKey = "organization"
    static let imageKey = "image"

    static var name: String {
        get {
            return UserDefaults.standard.string(forKey: nameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: nameKey)
        }
    }

    static var occupation: String {
        get {
            return UserDefaults.standard.string(forKey: occupationKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: occupationKey)
        }
    }

    static var organization: String {
        get {
            return UserDefaults.standard.string(forKey: organizationKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: organizationKey)
        }
    }

    static var image: Data {
        get {
            return UserDefaults.standard.data(forKey: imageKey) ?? Data()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: imageKey)
        }
    }

    static func synchronize() {
        UserDefaults.standard.synchronize()
    }
}
