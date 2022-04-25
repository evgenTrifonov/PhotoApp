//
//  saveFileManager.swift
//  PhotoApp
//
//  Created by Evgeny Trifonov on 24.03.2022.
//

import Foundation
import UIKit


class SaveFileManager {

    static let instance = SaveFileManager()

    func save(image: UIImage?, name: String, comment: String) {
        guard let image = image else { return }
        guard let data = image.jpegData(compressionQuality: 1.0),
        let path = getPathForStruct(name: name) else {
            print("Error getting data.")
            return
        }
        let newPhoto = NewPhoto(imageData: data, comment: comment)
        
        let propertyListEncoder = PropertyListEncoder()
        if let encodeNewPhoto = try? propertyListEncoder.encode(newPhoto) {
            do {
                try encodeNewPhoto.write(to: path)
                print("Success")
                print(path)
            } catch let error {
                print("Error saving. \(error)")
            }
        }
    }
    
    
    func getPathForStruct(name: String) -> URL? {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("\(name)").appendingPathExtension("plist") else {
            print("Error getting path.")
            return nil
        }
        return path
    }
    
    func load(name: String) -> NewPhoto? {
        let propetyListDecoder = PropertyListDecoder()
         guard let path = getPathForStruct(name: name) else {
             print("Error getting path.")
             return nil
         }
        
        guard let retrivData = try? Data(contentsOf: path) else { return nil }
        guard let decodedData = try? propetyListDecoder.decode(NewPhoto.self, from: retrivData) else { return nil }
        return decodedData
    }
}
