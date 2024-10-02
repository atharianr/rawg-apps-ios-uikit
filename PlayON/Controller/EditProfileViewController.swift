//
//  EditProfileViewController.swift
//  PlayON
//
//  Created by Atharian Rahmadani on 02/10/24.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var saveButton: UIButton!

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var occupationTextField: UITextField!

    @IBOutlet weak var organizationTextField: UITextField!

    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupForm()
    }

    @IBAction func onSaveClicked(_ sender: UIButton) {
        checkFormCompletion()
    }

    @objc func imageClicked() {
        self.present(imagePicker, animated: true, completion: nil)
    }

    private func setupView() {
        let profileImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageClicked))

        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary

        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.colorPrimary.cgColor
        profileImageView.layer.cornerRadius = 16
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(profileImageTapGesture)

        saveButton.tintColor = .colorPrimary
    }

    private func setupForm() {
        ProfileModel.synchronize()

        profileImageView.image = UIImage(data: ProfileModel.image)
        nameTextField.text = ProfileModel.name
        occupationTextField.text = ProfileModel.occupation
        organizationTextField.text = ProfileModel.organization
    }

    private func checkFormCompletion() {
        guard let name = nameTextField.text, name != "" else {
            alert("Field name is empty")
            return
        }

        guard let occupation = occupationTextField.text, occupation != "" else {
            alert("Field occupation is empty")
            return
        }

        guard let organization = organizationTextField.text, organization != "" else {
            alert("Field organization is empty")
            return
        }

        if let image = profileImageView.image, let data = image.pngData() {
            let alert = UIAlertController(
                title: "Warning",
                message: "Do you want to save your profile changes?",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "Yes", style: .default) { _ in
                self.saveData(name: name, occupation: occupation, organization: organization, image: data)
                self.navigationController?.popViewController(animated: true)
            })

            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }

    private func saveData(name: String, occupation: String, organization: String, image: Data) {
        ProfileModel.name = name
        ProfileModel.occupation = occupation
        ProfileModel.organization = organization
        ProfileModel.image = image
    }

    private func alert(_ message: String) {
        let allertController = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        allertController.addAction(alertAction)
        self.present(allertController, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Failed",
                message: "Image can't be loaded.",
                preferredStyle: .actionSheet
            )
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
