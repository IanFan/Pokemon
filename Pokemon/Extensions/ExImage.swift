//
//  ExImage.swift
//  Pokemon
//
//  Created by Ian Fan on 2024/6/20.
//

import Foundation
import UIKit

extension UIImage {
    
    func convertImageToBlackWhite() -> UIImage {
        let filter = CIFilter(name: "CIPhotoEffectMono")

        // convert UIImage to CIImage and set as input

        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")

        // get output CIImage, render as CGImage first to retain proper UIImage scale

        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)

        return UIImage(cgImage: cgImage!)
    }
    
    func withSaturationAdjustment(byVal: CGFloat) -> UIImage {
           guard let cgImage = self.cgImage else { return self }
           guard let filter = CIFilter(name: "CIColorControls") else { return self }
           filter.setValue(CIImage(cgImage: cgImage), forKey: kCIInputImageKey)
           filter.setValue(byVal, forKey: kCIInputSaturationKey)
           guard let result = filter.value(forKey: kCIOutputImageKey) as? CIImage else { return self }
           guard let newCgImage = CIContext(options: nil).createCGImage(result, from: result.extent) else { return self }
           return UIImage(cgImage: newCgImage, scale: UIScreen.main.scale, orientation: imageOrientation)
       }
    
    func resized(toSize size: CGSize) -> UIImage? {
        let canvasSize = CGSize(width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    var grayscale_noir: UIImage? {
        return grayscale(cifilter: "CIPhotoEffectNoir")
    }
    
    var grayscale_mono: UIImage? {
        return grayscale(cifilter: "CIPhotoEffectMono")
    }
    
    var grayscale_tonal: UIImage? {
        return grayscale(cifilter: "CIPhotoEffectTonal")
    }
    
    private func grayscale(cifilter: String) -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: cifilter) else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
    
    func cropToSquare() -> UIImage? {
        let targetLength = min(self.size.width, self.size.height)

        let x = (self.size.width - targetLength) / 2
        let y = (self.size.height - targetLength) / 2
        
        let cropRect = CGRect(x: x, y: y, width: targetLength, height: targetLength)
        
        if let cgImage = self.cgImage {
            // CGImage.cropping(to:) is magnitudes faster than UIImage.draw(at:)
            if let cgCroppedImage = cgImage.cropping(to: cropRect) {
                return UIImage(cgImage: cgCroppedImage, scale: self.scale, orientation: self.imageOrientation)
            }
        }
        
        if let ciImage = self.ciImage {
            // Core Image's coordinate system mismatch with UIKit, so rect needs to be mirrored.
            var ciRect = cropRect
            ciRect.origin.y = ciImage.extent.height - ciRect.origin.y - ciRect.height
            let ciCroppedImage = ciImage.cropped(to: ciRect)
            return UIImage(ciImage: ciCroppedImage)
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: cropRect.width, height: cropRect.height), false, 0)
        draw(at:CGPoint(x: -cropRect.minX, y: -cropRect.minY))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
    func scaleImage(scaleSize:CGFloat)->UIImage? {
        let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
        return resized(toSize: reSize)
    }

}

extension UIImage {
    func antiAlias() -> UIImage? {
        let border: CGFloat = 1.0;
        let rect = CGRect(x: border, y: border, width: self.size.width - 2*border, height: self.size.height - 2*border)
       
        var image: UIImage? = nil
        
        UIGraphicsBeginImageContext(CGSize(width: rect.size.width, height: rect.size.height))
        
        self.draw(in: CGRect(x: -1, y: -1, width: self.size.width, height: self.size.height))
       
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       
        UIGraphicsBeginImageContext(self.size);
        image?.draw(in: rect)
        
        let antiImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
       
        return antiImage
    }
}

extension UIImage {
    static func gradientImage(colorStart: UIColor, colorEnd: UIColor, width: CGFloat, height: CGFloat, corner: CGFloat, isLeftToRight: Bool = false) -> UIImage? {

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        gradientLayer.colors = [colorStart.cgColor, colorEnd.cgColor]
        
        if isLeftToRight {
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        } else {
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        if corner > 0 {
            gradientLayer.cornerRadius = corner
        }

        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIImage {
    func imageWithColor(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}

extension UIImage{
    //creates a UIImage given a UIColor
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIImage {
    func toGrayScale() -> UIImage? {
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = Int(self.size.width)
        let height = Int(self.size.height)

        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue)
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }

        context.draw(self.cgImage!, in: imageRect)
        guard let imageRef = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: imageRef)
    }
}

