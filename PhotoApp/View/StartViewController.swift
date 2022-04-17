//
//  StartViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 22.03.2022.
//

import UIKit
import Foundation

class StartViewController: UIViewController {

    let fonImageStartView = UIImageView(image: UIImage(named: "old_fon"))
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("name", comment: "")
        textField.textAlignment = .center
        return textField
    }()
    
    private let passwordTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("password", comment: "")
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToGallery), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Registration", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(goToRegister), for: .touchUpInside)
        return button
    }()
   

        override func viewDidLoad() {
            super.viewDidLoad()

            title = NSLocalizedString("Gallery entrance", comment: "")
            
            fonImageStartView.contentMode = .scaleAspectFill
            fonImageStartView.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.frame.width, height: view.frame.height)
            view.addSubview(fonImageStartView)
            view.sendSubviewToBack(fonImageStartView)
            
            setConstraint()
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
            view.addGestureRecognizer(recognizer)
            
        }
}

//MARK: - func action
private extension StartViewController {
    
    @objc func goToGallery() {
        login(userName: usernameTextField.text ?? "", password: passwordTextFiled.text ?? "") {
            let viewController = ViewController()
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func goToRegister() {
        let registerViewController = RegisterViewController()
        navigationController?.pushViewController(registerViewController, animated: true)
        
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
}

//MARK: - Alert
private extension StartViewController {
    
    func showAlertError() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Unable to login", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: ""), style: .destructive, handler: nil))
        present(alert, animated: true)
    }
}

//MARK: - Login
extension StartViewController {
    
    func login(userName: String, password: String, completion: () -> Void) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let pass = String(data: passwordData, encoding: .utf8),
               password == pass {
                print("Login verified")
                print(username)
                print(password)
                completion()
            } else {
                showAlertError()
            }
        } else {
            showAlertError()
            print("Error")
        }
    }
}

//MARK: - Constrains
private extension StartViewController {
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([usernameTextField, passwordTextFiled, galleryButton, registerButton])
        
        NSLayoutConstraint.activate([
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            passwordTextFiled.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            galleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            galleryButton.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 20),
            galleryButton.widthAnchor.constraint(equalToConstant: 120),
            galleryButton.heightAnchor.constraint(equalToConstant: 40),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: galleryButton.bottomAnchor, constant: 20),
            registerButton.widthAnchor.constraint(equalToConstant: 120),
            registerButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }
}
