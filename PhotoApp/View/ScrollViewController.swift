//
//  ScrollViewController.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 02.04.2022.
//

import UIKit

class ScrollViewController: UIViewController {
    
    let scrollView = UIScrollView()
    let manager = SaveFileManager.instance
    var photoArray: [NewPhoto] = []
    var indexPath = IndexPath(item: 0, section: 0)
    
    private let commentTextFiled: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.placeholder = ""
        return textField
    }()

    private let collectionVIew: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionVIew = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVIew.backgroundColor = .white
        collectionVIew.isPagingEnabled = true
        collectionVIew.bounces = false
        collectionVIew.showsHorizontalScrollIndicator = false
        collectionVIew.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "myCell")
        return collectionVIew
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        view.backgroundColor = .white
        
        setConstraint()
        collectionVIew.delegate = self
        collectionVIew.dataSource = self
        collectionVIew.performBatchUpdates(nil) { (_) in
            self.collectionVIew.scrollToItem(at: self.indexPath, at: .centeredHorizontally, animated: false)
            self.commentTextFiled.text = self.photoArray[self.indexPath.row].comment
        }
        
        addKeyboardObserver() 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                   view.frame.origin.y -= keyboardSize.size.height / 3
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

//MARK: - scrollView + Keyboard
private extension ScrollViewController {
 
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
}
extension ScrollViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addKeyboardObserver()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

//MARK: - UICollectionViewDataSource
extension ScrollViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        let imageData = photoArray[indexPath.row].imageData
        let uiImage = UIImage(data: imageData)
        cell.backgroundView = UIImageView(image: uiImage)
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ScrollViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }
        let itemsPerRow = 1
        let itemWidth = (collectionView.frame.width - layout.minimumLineSpacing - layout.minimumInteritemSpacing) / CGFloat(itemsPerRow)
        let itemHeight = itemWidth
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        commentTextFiled.text = photoArray[indexPath.row].comment
    }
}

//MARK: - Constrain
private extension ScrollViewController {

    func setConstraint() {
        view.addSubviewsForAutoLayout([collectionVIew, commentTextFiled])
        
        NSLayoutConstraint.activate([
            
            collectionVIew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionVIew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionVIew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionVIew.bottomAnchor.constraint(equalTo: commentTextFiled.topAnchor),
            
            commentTextFiled.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            commentTextFiled.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            commentTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            commentTextFiled.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}
