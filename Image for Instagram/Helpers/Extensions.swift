//
//  Extensions.swift
//  Image for Instagram
//
//  Created by Saud Almutlaq on 16/05/2020.
//  Copyright © 2020 Saud Soft. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension UIImage {
    // MARK: - UIImage+Resize
    
    func scaleImageWithAspectToWidth(toWidth:CGFloat) -> UIImage {
        let oldWidth:CGFloat = size.width
        let scaleFactor:CGFloat = toWidth / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
