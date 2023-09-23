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
    
    func compressPNGImage(image: UIImage, targetFileSizeInMB: CGFloat) -> Data? {
        guard let cgImage = image.cgImage else {
            return nil
        }

        // 将目标文件大小从 MB 转换为字节
        let targetFileSize = Int(targetFileSizeInMB * 1024 * 1024)

        var compressionQuality: CGFloat = 1.0
        let maxCompressionQuality: CGFloat = 0.1

        while compressionQuality > maxCompressionQuality {
            guard let imageData = NSMutableData() as CFMutableData? else {
                return nil
            }

            guard let destination = CGImageDestinationCreateWithData(imageData, kUTTypePNG, 1, nil) else {
                return nil
            }

            let options: NSDictionary = [
                kCGImageDestinationLossyCompressionQuality: compressionQuality
            ]

            CGImageDestinationAddImage(destination, cgImage, options)
            CGImageDestinationFinalize(destination)

            if let data = imageData as Data? {
                if data.count <= targetFileSize {
                    return data
                }
            }

            compressionQuality -= 0.1
        }

        return nil
    }
    
}



