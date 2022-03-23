//
//  ViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 08.02.2022.
//

import UIKit

private let reuseIdentifier = "MyCollectionView"

class ViewController: UIViewController {

    var images = ["image0",
                  "image1",
                  "image2",
                  "image3",
                  "image4",
                  "image5",
                  "image6"
    ]
    
    var FavoritImage = ["suit.heart",
                        "suit.heart.fill"
    ]
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Мой альбом"
       
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
       // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(showNewController))
            
        }

    
    @objc func addImage() {
            navigationController?.pushViewController(NewViewController(), animated: true)
        }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToOnePhoto", sender: self)
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
            newViewController.titleImage = cell.titleImage

  
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
