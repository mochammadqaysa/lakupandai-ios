//
//  ImageCache.swift
//  lakupandai
//
//  Created by Digital Amore Kriyanesia on 06/12/23.
//

import Foundation
import UIKit

class ImageCache {
    private let imagesWarehouse = NSCache<NSString, UIImage>()
    
    private static let cache = ImageCache()
    
    class func getInstance() -> ImageCache {
        return cache
    }
    
    func initializeCache() {
        let processInfo = ProcessInfo.processInfo
        let maxMemory = Int(processInfo.physicalMemory / 1024)
        let cacheSize = maxMemory / 8
        print("cache size = \(cacheSize)")
        
        imagesWarehouse.totalCostLimit = cacheSize
    }
    
    func addImageToWarehouse(key: String, value: UIImage) {
        imagesWarehouse.setObject(value, forKey: key as NSString)
    }
    
    func getImageFromWarehouse(key: String) -> UIImage? {
        return imagesWarehouse.object(forKey: key as NSString)
    }
    
    func removeImageFromWarehouse(key: String) {
        imagesWarehouse.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        imagesWarehouse.removeAllObjects()
    }
}
