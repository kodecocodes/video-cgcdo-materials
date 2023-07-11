// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import Foundation

extension AsyncOperation {
  public enum State: String {
    case ready, executing, finished

    fileprivate var keyPath: String {
      "is\(rawValue.capitalized)"
    }
  }
}

open class AsyncOperation: Operation {
  // Create thread-safe state management
  private let stateQueue = DispatchQueue(label: "AsyncOperationState",
                                 attributes: .concurrent)
  private var stateValue: State = .ready
  public var state: State {
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
  override open var isReady: Bool {
    super.isReady && state == .ready
  }

  override open var isExecuting: Bool {
    state == .executing
  }

  override open var isFinished: Bool {
    state == .finished
  }

  override open var isAsynchronous: Bool {
    true
  }

  // Override methods
  override open func start() {
    if isCancelled {
      state = .finished
      return
    }
    main()
    state = .executing
  }

  override open func cancel() {
    super.cancel()
    state = .finished
  }
}
