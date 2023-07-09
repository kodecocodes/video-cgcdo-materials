// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
//: # Use a Dispatch Work Item
let mainQueue = DispatchQueue.main
let userQueue = DispatchQueue.global(qos: .userInitiated)
func task1() {
  print("Task 1 started")
  sleep(4)
  print("Task 1 finished")
}
func task2() {
  print("Task 2 started")
  print("Task 2 finished")
}
//: In the previous exercise, this is how you ran task 2 in the background:
print(">> Just run task 2 in the background.")
userQueue.async {
  task2()
}
//: Now create a `DispatchWorkItem`:
// DONE
let workItem = DispatchWorkItem {
  task1()
}


//: And execute it on `userQueue`:
print(">> Run task 1 as a work item.")
// DONE
userQueue.async(execute: workItem)
//: If the current thread really needs `workItem` to finish before it can continue, call `.wait` to tell the system to give it priority. If necessary/possible, the system will increase the priority of other tasks in its queue.
print(">> Waiting for task 1...")
// DONE
if workItem.wait(timeout: .now() + 3) == .timedOut {
  print("I got tired of waiting.")
} else {
  print("Work item completed.")
}



sleep(2)  // give task 1 time to finish
//: Other advantages of work items: You can construct a simple dependency, for example, to update task 1 after it completes, and you can cancel work items.
enum Queues { case main, user }
// DONE later: Set specific key for each queue.
let specificKey = DispatchSpecificKey<Queues>()
mainQueue.setSpecific(key: specificKey, value: .main)
userQueue.setSpecific(key: specificKey, value: .user)
func whichQueue(workItem: String) {
  switch DispatchQueue.getSpecific(key: specificKey) {
  case .main:
    print(">> \(workItem) is running on mainQueue")
  case .user:
    print(">> \(workItem) is running on userQueue")
  case .none:
    break
  }
}
//: Define two work items:
// DONE first: Define work items.
// DONE later: Call whichQueue(workItem:)
let backgroundWorkItem = DispatchWorkItem {
  task1()
  whichQueue(workItem: "backgroundWorkItem")
}
let updateUIWorkItem = DispatchWorkItem {
  task2()
  whichQueue(workItem: "updateUIWorkItem")
}

//: Execute `updateUIWorkItem` after `backgroundWorkItem` finishes:
print(">> Run task 2 work item after task 1 work item finishes.")
// DONE
userQueue.async(execute: backgroundWorkItem)
backgroundWorkItem.notify(queue: mainQueue,
                          execute: updateUIWorkItem)


//: Task 2 runs after task 1, even though task 1 takes longer.
//:
//: Cancel `updateUIWorkItem`:
print(">> Cancel task 2 work item before task 1 work item finishes.")
// DONE
if !updateUIWorkItem.isCancelled {
  updateUIWorkItem.cancel()
}


//: Now task 2 doesn't run at all.
// Stop execution of the playground.
sleep(5)
PlaygroundPage.current.finishExecution()
