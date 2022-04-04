//
//  ViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 08.02.2022.
//

import UIKit
import Foundation

private let reuseIdentifier = "MyCollectionView"



class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let manager = SaveFileManager.instance
    var identifiersArray: [String] = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
    
    var newPhotoArray: [NewPhoto] = []

    let addButton = UIButton()
    
//    var imagesArray = ["image0",
//                  "image1",
//                  "image2",
//                  "image3",
//                  "image4",
//                  "image5",
//                  "image6"
//    ]
    
    private let galleryPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Мой альбом"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addImage))
        navigationItem.rightBarButtonItem = addButton
       
   
            
        }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        identifiersArray = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
        fillingArrayPhoto()
        print(identifiersArray.count)
        print(newPhotoArray.count)
        galleryPhotoCollectionView.reloadData()
    }
    
    @objc func pressPlusButton() {
       
        
    }
    
    func fillingArrayPhoto() {
        newPhotoArray = []
        for identifier in identifiersArray {
            guard let newPhoto = manager.load(name: "\(identifier)") else { return }
            newPhotoArray.append(newPhoto)
        }
    }
    
    
    @objc func addImage(_ sender: UIButton) {
        let Controller = UIStoryboard(name: "Main", bundle: nil)
        let newStoryboard = Controller.instantiateViewController(withIdentifier: "newViewController") as! NewViewController
        newStoryboard.modalPresentationStyle = .fullScreen
        present(newStoryboard, animated: true, completion: nil)
    }

    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newPhotoArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        let imageData = newPhotoArray[indexPath.row].imageData
        let uiImage = UIImage(data: imageData)
        cell.backgroundView = UIImageView(image: uiImage)
        return cell
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOnePhoto" {
            let newViewController = segue.destination as! NewViewController
            let cell = sender as! MyCollectionViewCell
            newViewController.imageViewDetail = cell.imageView.image

            return
        }
    }    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let minimumInteritemSpacing = layout.minimumInteritemSpacing
        
        let itemsPerRow = 3
        let itemWidth = (collectionView.frame.width - CGFloat(itemsPerRow - 1) * minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        collectionView.isPagingEnabled = true
    }
 
}


