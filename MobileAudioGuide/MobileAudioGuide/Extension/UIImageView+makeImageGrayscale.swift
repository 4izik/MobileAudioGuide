//
//  UIImageView+.swift
//  MobileAudioGuide
//
//  Created by Aleksei Pavlov on 09.06.2022.
//

import UIKit

extension UIImageView {
    
    func grayscaled() {
        
        guard let currentCGImage = self.image?.cgImage else { return }
        let currentCIImage = CIImage(cgImage: currentCGImage)

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        filter?.setValue(CIColor(red: 1, green: 1, blue: 1), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")
        guard let outputImage = filter?.outputImage else { return }

        let context = CIContext()

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.image = processedImage
        }
    }
}
