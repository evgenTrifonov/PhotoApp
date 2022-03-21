//
//  ViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 08.02.2022.
//

import UIKit

class ViewController: UIViewController {

    var images = ["image0.jpg",
                  "image1.jpg",
                  "image2.jpg",
                  "image3.jpg",
                  "image4.jpg",
                  "image5.jpg",
                  "image6.jpg"
                  
    ]
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Мой альбом"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: .plain, target: self, action: #selector(showNewController))
            
        }
    
    @objc func showNewController() {
        navigationController?.pushViewController(NewViewController(), animated: true)
    }
}


extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCollectionViewCell
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.imageView.image = UIImage(systemName: images[indexPath.row])
        return cell
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
