// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Explore OperationQueue
//: `OperationQueue` is responsible for scheduling and running a set of operations, somewhere in the background.
//: ## Creating a queue
//: Creating a queue is simple, using the default initializer; you can also set the maximum number of queued operations that can execute at the same time:
// TODO: Create printerQueue

// TODO later: Set maximum to 2
//: ## Adding `Operations` to Queues
/*: `Operation`s can be added to queues directly as closures
 - important:
 Adding operations to a queue is really "cheap"; although the operations can start executing as soon as they arrive on the queue, adding them is completely asynchronous.
 \
 You can see that here, with the result of the `duration` function:
 */
// TODO: Add 5 operations to printerQueue



// TODO: Measure duration of all operations

PlaygroundPage.current.finishExecution()
