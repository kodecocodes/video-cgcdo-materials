// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # TiltShiftOperations in OperationQueue
//: ## Filtering an Array of Images
let images = ["city", "dark_road", "train_day", "train_dusk", "train_night"].map { UIImage(named: "\($0).jpg") }
var filteredImages = [UIImage]()
//: A serial queue to handle additions to the array:
let appendQueue = OperationQueue()
appendQueue.maxConcurrentOperationCount = 1
//: `TiltShiftOperation` from episode 3
class TiltShiftOperation: Operation {
  private let inputImage: UIImage?
  var outputImage: UIImage?
  private static let context = CIContext()

  init(image: UIImage?) {
    inputImage = image
    super.init()
  }

  override func main() {
    guard let inputImage = inputImage,
      let filter = TiltShiftFilter(image: inputImage),
      let output = filter.outputImage else {
        print("Failed to generate tilt shift image")
        return
    }

    let fromRect = CGRect(origin: .zero, size: inputImage.size)
    guard let cgImage = TiltShiftOperation.context.createCGImage(
      output, from: fromRect) else {
      print("No image generated")
      return
    }

    outputImage = UIImage(cgImage: cgImage)
  }
}
//: Create an `OperationQueue` for the filter operations:
// TODO: Create filterQueue

//: For each of the images, create a filter operation,
//: and add it to your `OperationQueue`:
for image in images {
  // TODO: as above
  
  // Completion block appends each filtered image to filteredImages array

}

//: Wait for the `OperationQueue` to finish before checking the results
// TODO: wait

//: Inspect the filtered images
filteredImages
// In case the playground won't display the array of images:
filteredImages[0]
filteredImages[1]
filteredImages[2]
filteredImages[3]
filteredImages[4]

PlaygroundPage.current.finishExecution()
