// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// DONE: Create queues with high and low qos values
let high = DispatchQueue.global(qos: .userInteractive)
let medium = DispatchQueue.global(qos: .userInitiated)
let low = DispatchQueue.global(qos: .background)
// DONE: Create semaphore with value 1
let semaphore = DispatchSemaphore(value: 1)

// DONE: Dispatch task that sleeps before calling semaphore.wait()
high.async {
  // Wait 2 seconds to ensure all the other tasks have enqueued
  Thread.sleep(forTimeInterval: 2)
  print("High priority task is now waiting")
  semaphore.wait()
  defer { semaphore.signal() }

  print("High priority task is now running")
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
  Thread.sleep(forTimeInterval: 5)
}
