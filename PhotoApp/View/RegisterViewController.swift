//
//  RegisterViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 02.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {

    let button = UIButton()
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var saveRegistrationButtonAction: UIButton!
    @IBAction func saveRegistrationButtonAction(_ sender: Any) {
        let saveRegistrationButtonAction = UIButton()
        saveRegistrationButtonAction.addTarget(self, action: #selector(regesterDone), for: .touchUpInside)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
        
    }
    
    func register(userName: String, password: String) {
        guard let password = password.data(using: .utf8) else { return }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecValueData as String: password,
        ]
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("Пользователь зарегистрирован")
        } else {
            print("Error")
        }
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    func showAlertSuccess() {
        let alert = UIAlertController(title: "Поздравляем", message: "Вы зарегестрированы. Вернитесь на главный экран для входа", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
    
  
private extension RegisterViewController {
    @objc func regesterDone() {
        register(userName: usernameTextField.text ?? "", password: passwordTextField.text ?? "")
        saveRegistrationButtonAction.isEnabled = false
        showAlertSuccess()
    }
}
