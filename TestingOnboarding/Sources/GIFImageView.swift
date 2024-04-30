//
//  GIFImageView.swift
//  TestingOnboarding
//
//  Created by Ravi Heyne on 22/04/24.
//  GIF handling based on SwiftUIGIF Github Package


import SwiftUI
import UIKit

struct GIFImageView: UIViewRepresentable {
    let imageData: Data
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20 //not working currently
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = UIImage.gifImage(data: imageData)
        uiView.layer.cornerRadius = 20
        uiView.clipsToBounds = true
    }
    
}




extension UIImage {
    // Create an animated UIImage from GIF data
    static func gifImage(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Could not create image source with data.")
            return nil
        }
        return UIImage.animatedImageWithSource(source)
    }
    
    static func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: image))
                let delaySeconds = UIImage.delayForImage(at: i, source: source)
                delays.append(Int(delaySeconds * 1000.0)) // Convert to milliseconds
            }
        }
        
        let duration: Int = delays.reduce(0, +)
        let gcd = UIImage.gcdForArray(delays)
        var frames = [UIImage]()
        
        for i in 0..<count {
            let frame = images[i]
            let frameCount = delays[i] / gcd
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        return UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
    }
    
    static func delayForImage(at index: Int, source: CGImageSource) -> Double {
        var delay = 0.1
        guard let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil),
              let gifProperties = (cfProperties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
              let unclampedDelayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double else {
            return delay
        }
        delay = unclampedDelayTime == 0 ? (gifProperties[kCGImagePropertyGIFDelayTime as String] as? Double ?? 0) : unclampedDelayTime
        return delay
    }
    
    static func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty { return 1 }
        return array.reduce(array[0]) { gcdForPair($0, $1) }
    }
    
    static func gcdForPair(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        while b != 0 {
            let remainder = a % b
            a = b
            b = remainder
        }
        return a
    }
}
