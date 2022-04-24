//
//  RegisterViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 02.04.2022.
//

import UIKit

class RegisterViewController: UIViewController {
    
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
        
        usernameTextField.resignFirstResponder()
        passwordTextFiled.resignFirstResponder()
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("Registration", comment: "")
        
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
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        bottomButtonConstraint?.constant -= (keyboardFrame.height - 20)
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.bottomButtonConstraint?.constant = -5 - keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        bottomButtonConstraint?.constant = -80
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        removeKeyboardObserver()
    
    }
}

//MARK: - scrollView + Keyboard
private extension RegisterViewController {
 
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
}
extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        
        bottomButtonConstraint = regesterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        bottomButtonConstraint?.isActive = true
        
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
