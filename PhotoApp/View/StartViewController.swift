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
    var bottomButtonConstraint: NSLayoutConstraint?
    let scrollView = UIScrollView()
    
    
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
        usernameTextField.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
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
        usernameTextField.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
        return button
    }()
   

        override func viewDidLoad() {
            super.viewDidLoad()

            title = NSLocalizedString("Gallery entrance", comment: "")
            
            scrollView.frame = view.bounds
            view.addSubview(scrollView)
            
            fonImageStartView.contentMode = .scaleAspectFill
            fonImageStartView.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.frame.width, height: view.frame.height)
            view.addSubview(fonImageStartView)
            view.sendSubviewToBack(fonImageStartView)

            addKeyboardObserver()
            
            setConstraint()
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
            view.addGestureRecognizer(recognizer)
            
        }
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   view.frame.origin.y -= keyboardSize.size.height / 4
               
               }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        scrollView.contentOffset = CGPoint.zero
            view.frame.origin.y = 0
    }
    
    deinit {
        removeKeyboardObserver()
    
    }
 
}

//MARK: - Keyboard
extension StartViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
  
    
}

extension StartViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
