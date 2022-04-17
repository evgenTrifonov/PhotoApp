//
//  RegisterViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 02.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("password", comment: "")
        textField.textAlignment = .center
        return textField
    }()
    
    private lazy var regesterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Verification", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemYellow
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(regesterDone), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Registration", comment: "")
        
        fonImageStartView.contentMode = .scaleAspectFill
        fonImageStartView.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.frame.width, height: view.frame.height)
        view.addSubview(fonImageStartView)
        view.sendSubviewToBack(fonImageStartView)
        
        setConstraint()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tap))
        view.addGestureRecognizer(recognizer)
    }

}

//MARK: - Alert
private extension RegisterViewController {
    
    func showAlertSuccess() {
        let alert = UIAlertController(title: NSLocalizedString("Successfully", comment: ""), message: NSLocalizedString("Registration", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func showAlertError() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Unable to register", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: ""), style: .destructive, handler: nil))
        present(alert, animated: true)
    }
}

//MARK: - Register
private extension RegisterViewController {
    func register(userName: String, password: String) {
        if userName == "" || password == "" {
            showAlertError()
            return
        }
        guard let password = password.data(using: .utf8) else { return }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
            kSecValueData as String: password,
            ]
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User registered")
        } else {
            print("Error")
        }
    }
    
}

//MARK: - Action
private extension RegisterViewController {
    
    @objc func tap() {
        view.endEditing(true)
    }

    @objc func regesterDone() {
        register(userName: usernameTextField.text ?? "", password: passwordTextFiled.text ?? "")
        let viewController = ViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - Constrains
private extension RegisterViewController {
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([usernameTextField, passwordTextFiled, regesterButton])
        
        NSLayoutConstraint.activate([
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            usernameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            passwordTextFiled.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            passwordTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 40),
            
            regesterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            regesterButton.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 20),
            regesterButton.widthAnchor.constraint(equalToConstant: 120),
            regesterButton.heightAnchor.constraint(equalToConstant: 40)
            
        ])
    }

}
