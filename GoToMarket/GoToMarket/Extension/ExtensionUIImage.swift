//
//  ExtensionUIImage.swift
//  GoToMarket
//
//  Created by 許庭瑋 on 2018/5/21.
//  Copyright © 2018年 許庭瑋. All rights reserved.
//

import UIKit

extension UIImage {
    
    //Resize
    func resizeImage(newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        
        self.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

}
