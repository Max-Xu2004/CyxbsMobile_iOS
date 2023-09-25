//
//  CompressImages.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import ImageIO
import MobileCoreServices

class CompressImages: NSObject {
    
    static let shared = CompressImages()
    
    private override init() {
        
    }
    
    func compressImage(image: UIImage, maxSizeInBytes: Int) -> Data? {
        var compressionQuality: CGFloat = 0.5  // 初始压缩质量
        
        guard var imageData = image.jpegData(compressionQuality: compressionQuality) else {
            return nil
        }
        
        // 循环调整压缩质量，直到满足最大文件大小为止
        while imageData.count > maxSizeInBytes && compressionQuality > 0 {
            compressionQuality -= 0.1
            guard let newImageData = image.jpegData(compressionQuality: compressionQuality) else {
                return nil
            }
            imageData = newImageData
        }
        
        // 将 JPEG 数据转换为 PNG 数据
        if let pngData = UIImage(data: imageData)?.pngData() {
            return pngData
        } else {
            return nil
        }
    }
}





