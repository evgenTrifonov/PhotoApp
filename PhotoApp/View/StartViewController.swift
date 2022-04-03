//
//  StartViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 22.03.2022.
//

import UIKit
import Foundation

class StartViewController: UIViewController {

   
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var comeInButton: UIButton!
    
    
    
    let fonImageStartView = UIImageView(image: UIImage(named: "old_fon"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //create Road
        fonImageStartView.contentMode = .scaleAspectFill
        fonImageStartView.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.frame.width, height: view.frame.height)
        view.addSubview(fonImageStartView)
        view.sendSubviewToBack(fonImageStartView)
        
       
        
    }
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
                print("Вход подвержден")
                print(username)
                print(password)
                completion()
            }
        } else {
            showAlertError()
            print("Error")
        }
        
    }
    
    @objc func tap() {
        view.endEditing(true)
    }

    
    func showAlertError() {
        let alert = UIAlertController(title: "Ошибка", message: "Неверный логин или пароль!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Назад", style: .destructive, handler: nil))
        present(alert, animated: true)
    }

//    @IBAction func comeInButtonAction(_ sender: Any) {
//
//        let user = "123"
//        let pass = "123"
//
//        if usernameTextField.text == user && passwordTextField.text == pass {
//
//            DispatchQueue.main.async {
//                self.comeInButton.addTarget(self, action: #selector(self.nextGalery), for: .touchDown)
//            }
//
//            warningLabel.text = "Данные введены верно!"
//            warningLabel.textColor = UIColor.green
//            warningLabel.shadowColor = UIColor.black
//            warningLabel.layer.opacity = 1
//
//        } else {
//            warningLabel.text = "Неверный логин или пароль!"
//            warningLabel.textColor = UIColor.red
//            warningLabel.shadowColor = UIColor.black
//            warningLabel.layer.opacity = 1
//
//        }
//
//        usernameTextField.resignFirstResponder()
//        passwordTextField.resignFirstResponder()
//
//    }
    
    @objc func nextGalery(_ sender: UIButton) {
        let Controller = UIStoryboard(name: "Main", bundle: nil)
        let newtStoryboard = Controller.instantiateViewController(withIdentifier: "viewController") as! ViewController
        newtStoryboard.modalPresentationStyle = .fullScreen
        present(newtStoryboard, animated: true, completion: nil)
    }
    
    
    @objc func goToRegister() {
        let registerViewController = RegisterViewController()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(registerViewController, animated: true)
        
    }

}



