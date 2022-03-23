//
//  NewViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 22.03.2022.
//

import UIKit

class NewViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var openGalleryButton: UIButton!
    
    var imageViewDetail: UIImage?
    var descriptionImage: String?
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func openGalleryButtonAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Фотография"
        
        imageView.image = imageViewDetail
        descriptionTextField.text = descriptionImage
        
        
        DispatchQueue.main.async {
            self.openGalleryButton.addTarget(self, action: #selector(self.openImage), for: .touchDown)
        }
        
    }
    
    @objc func openImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        }

}

extension NewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = (info[.editedImage]) as? UIImage else {return}
        imageView.contentMode = .scaleToFill
        imageView.image = image

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
