//
//  ViewController.swift
//  TestHEIC
//
//  Created by Costantino Pistagna on 14/11/2018.
//  Copyright © 2018 sofapps. All rights reserved.
//

import UIKit
import AVFoundation

extension Data {
    static func UImageHEICRepr(image: UIImage, quality: CGFloat) -> Data {
        let imageData = NSMutableData()
        if let destination = CGImageDestinationCreateWithData(imageData as CFMutableData, AVFileType.heic as CFString, 1, nil) {
            let options = [kCGImageDestinationLossyCompressionQuality:quality]
            CGImageDestinationAddImage(destination, image.cgImage!, options as CFDictionary)
            CGImageDestinationFinalize(destination)
        }
        return imageData as Data
    }

    static func UImageJPEGRepr(image: UIImage, quality: CGFloat) -> Data {
        let imageData = NSMutableData()
        if let destination = CGImageDestinationCreateWithData(imageData as CFMutableData, AVFileType.jpg as CFString, 1, nil) {
            let options = [kCGImageDestinationLossyCompressionQuality:quality]
            CGImageDestinationAddImage(destination, image.cgImage!, options as CFDictionary)
            CGImageDestinationFinalize(destination)
        }
        return imageData as Data
    }
}

class ViewController: UIViewController {
    @IBOutlet var displayLabel:UILabel!
    @IBOutlet var segmentedControl:UISegmentedControl!
    @IBOutlet var loopCounterSegmentControl:UISegmentedControl!

    func elapsedWhenRunningCode(title:String, operation:()->()) {
        let startTime = CFAbsoluteTimeGetCurrent()
        operation()
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        displayLabel.text = title + ": \(timeElapsed)"
    }
    
    @IBAction func startEncodingBenchmark() {
        var counter = 0
        switch loopCounterSegmentControl.selectedSegmentIndex {
        case 0:
            counter = 10
        case 1:
            counter = 50
        case 2:
            counter = 100
        case 3:
            counter = 500
        case 4:
            counter = 1000
        default:
            counter = 0
        }
        let anImage = UIImage(named: "DSCF1649.jpg")
        if segmentedControl.selectedSegmentIndex == 0 {
            elapsedWhenRunningCode(title: "Encoding HEIC") {
                for _ in 1...counter {
                    let _ = Data.UImageHEICRepr(image: anImage!, quality: 1.0)
                }
            }
        } else {
            elapsedWhenRunningCode(title: "Encoding JPEG") {
                for _ in 1...counter {
                    let _ = Data.UImageJPEGRepr(image: anImage!, quality: 1.0)
                }
            }
        }
    }

    @IBAction func startDecodingBenchmark() {
        var counter = 0
        switch loopCounterSegmentControl.selectedSegmentIndex {
        case 0:
            counter = 10
        case 1:
            counter = 50
        case 2:
            counter = 100
        case 3:
            counter = 500
        case 4:
            counter = 1000
        default:
            counter = 0
        }
        if segmentedControl.selectedSegmentIndex == 0 {
            elapsedWhenRunningCode(title: "Decoding HEIC") {
                if let anImage = UIImage(named: "DSCF1649.jpg") {
                    let heicImage = Data.UImageHEICRepr(image: anImage, quality: 1.0)
                    for _ in 1...counter {
                        if let decodedImage = UIImage(data: heicImage) {
                            UIGraphicsBeginImageContextWithOptions(decodedImage.size, false, 1.0)
                            decodedImage.draw(at: CGPoint.zero)
                            UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                        }
                    }
                }
            }
        } else {
            elapsedWhenRunningCode(title: "Decoding JPEG") {
                if let anImage = UIImage(named: "DSCF1649.jpg") {
                    let jpgImage = Data.UImageJPEGRepr(image: anImage, quality: 1.0)
                    for _ in 1...counter {
                        if let decodedImage = UIImage(data: jpgImage) {
                            UIGraphicsBeginImageContextWithOptions(decodedImage.size, false, 1.0)
                            decodedImage.draw(at: CGPoint.zero)
                            UIGraphicsGetImageFromCurrentImageContext()
                            UIGraphicsEndImageContext()
                        }
                    }
                }
            }
        }
    }
}

