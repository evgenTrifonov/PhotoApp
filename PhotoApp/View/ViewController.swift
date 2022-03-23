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

    var images = ["image0",
                  "image1",
                  "image2",
                  "image3",
                  "image4",
                  "image5",
                  "image6"
    ]
    
    var favoritImage = ["suit.heart",
                        "suit.heart.fill"
    ]
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Мой альбом"
       
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addImage))
            
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
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        cell.imageView.image = UIImage(named: images[indexPath.row])
        let imageName = images[indexPath.row]
        let titleImage = images[indexPath.row]
        cell.imageView.image = UIImage(named: titleImage)
        cell.titleImage = imageName
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


