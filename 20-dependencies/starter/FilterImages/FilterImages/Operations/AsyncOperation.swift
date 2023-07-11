/// Copyright (c) 2023 Kodeco Inc.
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

extension AsyncOperation {
  enum State: String {
    case ready, executing, finished

    // swiftlint:disable:next strict_fileprivate
    fileprivate var keyPath: String {
      "is\(rawValue.capitalized)"
    }
  }
}

class AsyncOperation: Operation {
  // Create thread-safe state management
  private let stateQueue = DispatchQueue(label: "AsyncOperationState",
                                         attributes: .concurrent)
  private var stateValue: State = .ready
  var state: State {
    get {
      stateQueue.sync { return stateValue }
    }
    set {
      let oldValue = state
      willChangeValue(forKey: newValue.keyPath)
      willChangeValue(forKey: state.keyPath)
      stateQueue.sync(flags: .barrier) {
        stateValue = newValue
      }
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

  override var isAsynchronous: Bool {
    true
  }

  // Override methods
  override func start() {
    if isCancelled {
      state = .finished
      return
    }
    main()
    state = .executing
  }

  override func cancel() {
    super.cancel()
    state = .finished
  }
}
