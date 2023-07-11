// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
//: # Operations
//: An `Operation` represents a 'unit of work', and can be constructed as a `BlockOperation` or as a custom subclass of `Operation`.
//: ## BlockOperation
//: Create a `BlockOperation` to add two numbers
var result: Int?
// TODO: Create and run sumOperation




//: Run a `BlockOperation` with multiple blocks:
let multiPrinter = BlockOperation()
multiPrinter.addExecutionBlock {  print("Hello"); sleep(2) }
multiPrinter.addExecutionBlock {  print("my"); sleep(2) }
multiPrinter.addExecutionBlock {  print("name"); sleep(2) }
multiPrinter.addExecutionBlock {  print("is"); sleep(2) }
multiPrinter.addExecutionBlock {  print("Audrey"); sleep(2) }

//multiPrinter.completionBlock = {
//  print("Finished multiPrinting!")
//}

duration {
  multiPrinter.start()
}

//: ## Subclassing `Operation`
//: Allows you more control over precisely what the `Operation` is doing
let inputImage = UIImage(named: "dark_road_small.jpg")
// TODO: Create TiltShiftOperation
class TiltShiftOperation: Operation {
  private static let context = CIContext()

  // TODO: Add input & output properties and init



  override func main() {
    // TODO: Filter the input image


    // TODO: Create a CGImage
    // let fromRect = CGRect(origin: .zero, size: inputImage.size)
    
    // TODO: Create and output a UIImage

  }
}

// TODO: Run TiltShiftOperation



PlaygroundPage.current.finishExecution()
