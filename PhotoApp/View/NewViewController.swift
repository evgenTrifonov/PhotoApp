//
//  NewViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 22.03.2022.
//

import UIKit

class NewViewController: UIViewController {
    
    let manager = SaveFileManager.instance
    var identifiersArray: [String] = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
    
    let button = UIButton()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var openGalleryButton: UIButton!
    
    var imageViewDetail: UIImage?
    var descriptionImage: String?
    
    
    @IBAction func addButtonAction(_ sender: Any) {
        
    }
    
    
    @IBAction func openGalleryButtonAction(_ sender: Any) {
        
    }
    
    @IBAction func exitToGalleryButton(_ sender: Any) {
        button.addTarget(self, action: #selector(exitGallery), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Фотография"
        
        imageView.image = imageViewDetail
        descriptionTextField.text = descriptionImage
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(goBack))
        navigationItem.rightBarButtonItem = addButton
        
        DispatchQueue.main.async {
            self.openGalleryButton.addTarget(self, action: #selector(self.openImage), for: .touchDown)
        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
        print(identifiersArray.count)
    }
    
    @objc func saveImage() {
        let identifier = UUID()
        identifiersArray.append("\(identifier)")
        UserDefaults.standard.set(self.identifiersArray, forKey: "keyList")
        print(identifiersArray.count)
        manager.save(image: imageView.image, name: "\(identifier)", comment: descriptionTextField.text ?? "")
      
    }
    
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    

    @objc func openImage() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    
    @objc func exitGallery() {
        let Controller = UIStoryboard(name: "Main", bundle: nil)
        let newtStoryboard = Controller.instantiateViewController(withIdentifier: "viewController") as! ViewController
        newtStoryboard.modalPresentationStyle = .fullScreen
        present(newtStoryboard, animated: true, completion: nil)
        
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




//MARK: - Keyboard

extension NewViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
