//
//  UIImageExtension.swift
//  jqSwiftExtensionSDK
//
//  Created by Jefferson Qin on 2018/7/25.
//


#if os(iOS)

import Foundation
import UIKit

public extension UIImage {
    public func mergeImageHorizontally(withImage1 image1 : UIImage, withImage2 image2 : UIImage, ofLength1 length1 : CGFloat, ofLength2 length2 : CGFloat, ofHeight height : CGFloat) -> UIImage {
        let size = CGSize(width: length1 + length2, height: height)
        UIGraphicsBeginImageContext(size)
        let rect1 = CGRect(x: 0, y: 0, width: length1, height: height)
        image1.draw(in: rect1)
        let rect2 = CGRect(x: length1, y: 0, width: length2, height: height)
        image2.draw(in: rect2)
        let mergeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergeImage
    }
    
    public func mergeImageVertically(withImage1 image1 : UIImage, withImage2 image2 : UIImage, ofLength length : CGFloat, ofHeight1 height1 : CGFloat, ofHeight2 height2 : CGFloat) -> UIImage {
        let size = CGSize(width: length, height: height1 + height2)
        UIGraphicsBeginImageContext(size)
        let rect1 = CGRect(x: 0, y: 0, width: length, height: height1)
        image1.draw(in: rect1)
        let rect2 = CGRect(x: 0, y: height1, width: length, height: height2)
        image2.draw(in: rect2)
        let mergeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return mergeImage
    }
    
    public func mergeImageSetHorizontally(withImageSet imageSet : [UIImage], forWidth width : CGFloat, forHeight height : CGFloat) -> UIImage {
        var image1 = imageSet[0]
        var image2 : UIImage
        for i in 1...imageSet.count - 1 {
            image2 = imageSet[i]
            image1 = mergeImageHorizontally(withImage1: image1, withImage2: image2, ofLength1: image1.size.width, ofLength2: width, ofHeight: height)
        }
        return image1
    }
    
    public func mergeImageSetVertically(withImageSet imageSet : [UIImage], forWidth width : CGFloat, forHeight height : CGFloat) -> UIImage {
        var image1 = imageSet[0]
        var image2 : UIImage
        for i in 1...imageSet.count - 1 {
            image2 = imageSet[i]
            image1 = mergeImageVertically(withImage1: image1, withImage2: image2, ofLength: width, ofHeight1: image1.size.height, ofHeight2: height)
        }
        return image1
    }
    
    
    public func resizeImage(resize size : CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale);
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height));
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return image;
    }
    
    public func scaleImage(scaleSize : CGFloat) -> UIImage {
        let resize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return self.resizeImage(resize: resize)
    }
    
    public func GaussianBlurImage(radiusValue : CGFloat) -> UIImage {
        let inputImage =  CIImage(image: self)
        let filter = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(radiusValue, forKey: kCIInputRadiusKey)
        let outputCIImage = filter.outputImage!
        let rect = CGRect(origin: CGPoint.zero, size: self.size)
        let context : CIContext = CIContext(options: nil)
        let cgImage = context.createCGImage(outputCIImage, from: rect)
        return UIImage(cgImage: cgImage!)
    }
    
    //Return : UIImageView, UIBlurView, UIVibrancyView
    public func getBlurViewSet(WithImage image : UIImage, atWhere size : CGRect, withStyle style : UIBlurEffect.Style) -> [Any] {
        let imageView = UIImageView(frame: size)
        imageView.image = image
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = size
        let vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        vibrancyView.frame = size
        blurView.contentView.addSubview(vibrancyView)
        return [imageView, blurView, vibrancyView] as [Any]
    }
}

#endif

