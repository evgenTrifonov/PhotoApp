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
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = addButton
        
        DispatchQueue.main.async {
            self.openGalleryButton.addTarget(self, action: #selector(self.openImage), for: .touchDown)
        }
        
        addKeyboardObserver()
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
//        bottomButtonConstraint?.constant -= (keyboardFrame.height - 20)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
//            self.bottomButtonConstraint?.constant = -5 - keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
//        bottomButtonConstraint?.constant = -80
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openImage(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        }

    @objc func downloadPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func close(_ sender: UIButton) {
        let Controller = UIStoryboard(name: "Main", bundle: nil)
        let newStoryboard = Controller.instantiateViewController(withIdentifier: "viewController") as! ViewController
        newStoryboard.modalPresentationStyle = .fullScreen
        present(newStoryboard, animated: true, completion: nil)
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

extension NewViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
}

extension NewViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
