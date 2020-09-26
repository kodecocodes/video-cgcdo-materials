// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import Foundation
//: # Create AsyncOperation
extension AsyncOperation {
  enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      "is\(rawValue.capitalized)"
    }
  }
}

class AsyncOperation: Operation {
  // Create state management
  var state = State.ready {
    willSet {
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
    }
    didSet {
      didChangeValue(forKey: oldValue.keyPath)
      didChangeValue(forKey: state.keyPath)
    }
  }

  // Override properties
  override var isReady: Bool {
    super.isReady && state == .ready
  }

  override var isExecuting: Bool {
    state == .executing
  }

  override var isFinished: Bool {
    state == .finished
  }

  override func cancel() {
    state = .finished
  }

  override var isAsynchronous: Bool {
    true
  }

  // Override start
  override func start() {
    if isCancelled {
      state = .finished
      return
    }
    main()
    state = .executing
  }
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
      sleep(2)
      self.result = self.lhs + self.rhs
      // DONE: Set state to finished
      self.state = .finished
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
  // DONE: Create an AsyncSumOperation for pair
  let op = AsyncSumOperation(lhs: pair.0, rhs: pair.1)
  op.completionBlock = {
    guard let result = op.result else { return }
    print("\(pair.0) + \(pair.1) = \(result)")
  }
  // DONE: Add the operation to queue
  queue.addOperation(op)
}

// This prevents the playground from finishing prematurely.
// Never do this on a main UI thread!
queue.waitUntilAllOperationsAreFinished()
PlaygroundPage.current.finishExecution()
