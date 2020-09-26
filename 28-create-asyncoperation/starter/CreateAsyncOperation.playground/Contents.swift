// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import Foundation
//: # Create AsyncOperation
extension AsyncOperation {
  // TODO: Create State enum and keyPath
}

class AsyncOperation: Operation {
  // TODO: Create state management
  
  // TODO: Override properties
  
  // TODO: Override start
}
/*:
 `AsyncSumOperation` simply adds two numbers together asynchronously and assigns the result. It sleeps for two seconds just so that you can
 see the random ordering of the operation.  Nothing guarantees that an operation will complete in the order it was added.
 */
class AsyncSumOperation: AsyncOperation {
  let rhs: Int
  let lhs: Int
  var result: Int?
  
  init(lhs: Int, rhs: Int) {
    self.lhs = lhs
    self.rhs = rhs
    
    super.init()
  }
  
  override func main() {
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 2)
      self.result = self.lhs + self.rhs
      // TODO: Set state to finished
    }
  }
}
/*:
- important:
What would happen if you forgot to set `state` to `.finished`?
*/
//:
//: Now that you have an `AsyncOperation` base class and an `AsyncSumOperation` subclass, run it through a small test.
let queue = OperationQueue()
let pairs = [(2, 3), (5, 3), (1, 7), (12, 34), (99, 99)]

pairs.forEach { pair in
  // TODO: Create an AsyncSumOperation for pair


  // TODO: Add the operation to queue

}

// This prevents the playground from finishing prematurely.
// Never do this on a main UI thread!
queue.waitUntilAllOperationsAreFinished()
PlaygroundPage.current.finishExecution()
