//
//  NewViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 22.03.2022.
//

import UIKit

class NewViewController: UIViewController {

//    var article: Article!
    //var detail: Detail!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var imageViewDetail: UIImage?
    var titleImage: String?
    var descriptionImage: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Фотография"
        view.backgroundColor = .gray
        
        imageView.image = imageViewDetail
        titleLabel.text = titleImage
        titleLabel.numberOfLines = 0
        descriptionTextField.text = descriptionImage
        
        
        
    }
    



}
