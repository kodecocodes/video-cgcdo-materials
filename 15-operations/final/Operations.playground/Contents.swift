// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
//: # Operations
//: An `Operation` represents a 'unit of work', and can be constructed as a `BlockOperation` or as a custom subclass of `Operation`.
//: ## BlockOperation
//: Create a `BlockOperation` to add two numbers
var result: Int?
// DONE: Create and run sumOperation
let sumOperation = BlockOperation {
  result = 2 + 3
  sleep(2)
}
duration {
  //  sumOperation.start()
}

result

//: Run a `BlockOperation` with multiple blocks:
let multiPrinter = BlockOperation()
multiPrinter.addExecutionBlock {  print("Hello"); sleep(2) }
multiPrinter.addExecutionBlock {  print("my"); sleep(2) }
multiPrinter.addExecutionBlock {  print("name"); sleep(2) }
multiPrinter.addExecutionBlock {  print("is"); sleep(2) }
multiPrinter.addExecutionBlock {  print("Audrey"); sleep(2) }

multiPrinter.completionBlock = {
  print("Finished multiPrinting!")
}

duration {
  //  multiPrinter.start()
}

//: ## Subclassing `Operation`
//: Allows you more control over precisely what the `Operation` is doing
let inputImage = UIImage(named: "dark_road_small.jpg")
// DONE: Create TiltShiftOperation
class TiltShiftOperation: Operation {
  private static let context = CIContext()

  // DONE: Add input & output properties and init
  private let inputImage: UIImage?
  var outputImage: UIImage?

  init(image: UIImage?) {
    inputImage = image
    super.init()
  }

  override func main() {
    // DONE: Filter the input image
    guard let inputImage,
          let filter = TiltShiftFilter(image: inputImage),
          let output = filter.outputImage else {
      print("Failed to generate tilt shift image")
      return
    }

    // DONE: Create a CGImage
    let fromRect = CGRect(origin: .zero, size: inputImage.size)
    guard let cgImage =
            TiltShiftOperation.context.createCGImage(
              output,
              from: fromRect)
    else {
      print("No image generated")
      return
    }
    // DONE: Create and output a UIImage
    outputImage = UIImage(cgImage: cgImage)
  }
}

// DONE: Run TiltShiftOperation
let tsOp = TiltShiftOperation(image: inputImage)
duration {
  tsOp.start()
}
tsOp.outputImage
PlaygroundPage.current.finishExecution()
