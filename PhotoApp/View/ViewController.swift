//
//  ViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 08.02.2022.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    let manager = SaveFileManager.instance
    
    var identifiersArray: [String] = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
    
    var newPhotoArray: [NewPhoto] = []
    
    private let galleryCollectionView: UICollectionView = {
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
        
        title = NSLocalizedString("Gallery", comment: "")
        view.backgroundColor = .white
        
        galleryCollectionView.dataSource = self
        galleryCollectionView.delegate = self
        setupView()
        setConstraint()
        fillingArrayPhoto()
        galleryCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        identifiersArray = UserDefaults.standard.stringArray(forKey: "keyList") ?? [String]()
        fillingArrayPhoto()
        galleryCollectionView.reloadData()
    }
    
    func fillingArrayPhoto() {
        newPhotoArray = []
        for identifier in identifiersArray {
            guard let newPhoto = manager.load(name: "\(identifier)") else { return }
            newPhotoArray.append(newPhoto)
        }
    }

}

//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        newPhotoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        let imageData = newPhotoArray[indexPath.row].imageData
        let uiImage = UIImage(data: imageData)
        cell.backgroundView = UIImageView(image: uiImage)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        
        let itemsPerRow = 3
        let itemWidth = (collectionView.frame.width - (layout.minimumLineSpacing * CGFloat(itemsPerRow-1))) / CGFloat(itemsPerRow)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let scrollViewController = ScrollViewController()
        scrollViewController.photoArray = newPhotoArray
        scrollViewController.indexPath = IndexPath(item: indexPath.row, section: 0)
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(scrollViewController, animated: true)
    }
 
}

//MARK: - func action
extension ViewController {
    
    @objc func pressPlusButton() {
        let newViewController = NewViewController()
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true, completion: nil)
    }
    
    @objc func backToRootView() {
        navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - barItem + Constrain
private extension ViewController {
    
    func setupView() {
        
        let addPhotoButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressPlusButton))
        navigationItem.rightBarButtonItem = addPhotoButton
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backToRootView))
        backButton.image = UIImage(systemName: "chevron.backward")
        navigationItem.leftBarButtonItem = backButton
    }
    
    func setConstraint() {
        view.addSubviewsForAutoLayout([galleryCollectionView])
        
        NSLayoutConstraint.activate([
            galleryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            galleryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            galleryCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            galleryCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
