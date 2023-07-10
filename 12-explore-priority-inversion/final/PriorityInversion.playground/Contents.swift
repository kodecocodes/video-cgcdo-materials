// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import Foundation
import PlaygroundSupport
//: # Priority Inversion
// DONE: Create queues with high and low qos values
let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)
// DONE: Create semaphore with value 1
let semaphore = DispatchSemaphore(value: 1)

// DONE: Dispatch task that sleeps before calling semaphore.wait()
high.async {
  sleep(2)
  print("High priority task is now waiting")
  semaphore.wait()
  defer { semaphore.signal() }
  print("High priority task is now running")
  sleep(1)
  PlaygroundPage.current.finishExecution()
}

for i in 1 ... 10 {
  medium.async {
    print("Running medium task \(i)")
    let waitTime = Double(Int.random(in: 0..<7))
    Thread.sleep(forTimeInterval: waitTime)
  }
}

// DONE: Dispatch task that takes a long time
low.async {
  semaphore.wait()
  defer { semaphore.signal() }
  print("Low priority task is now running")
  sleep(5)
}





