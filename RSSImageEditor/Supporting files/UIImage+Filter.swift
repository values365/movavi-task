//
//  UIImage+Filter.swift
//  RSSImageEditor
//
//  Created by Владислав Банков on 30.01.2021.
//

import UIKit

extension UIImage {
	func addFilter(filter: FilterType) -> UIImage {
		guard filter.rawValue != FilterType.Default.rawValue else { return self }
		let filter = CIFilter(name: filter.rawValue)
		let input = CIImage(image: self)
		filter?.setValue(input, forKey: "inputImage")
		let output = filter?.outputImage
		let context = CIContext()
		let CGImage = context.createCGImage(output!, from: (output?.extent)!)
		return UIImage(cgImage: CGImage!)
	}
}
