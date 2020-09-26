// Copyright (c) 2020 Razeware LLC
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # DispatchSemaphore
let group = DispatchGroup()
let queue = DispatchQueue.global(qos: .userInteractive)
// TODO: Create a semaphore that allows four concurrent accesses

// TODO: Simulate downloading group of images






// Really download group of images
let base = "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images: [UIImage] = []

// TODO: Add semaphore argument to dataTask_Group
func dataTask_Group_Semaphore(with url: URL,
  group: DispatchGroup,
  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
  // TODO: wait for semaphore before entering group

  group.enter()
  URLSession.shared.dataTask(with: url) { data, response, error in
    defer {
      group.leave()
      // TODO: signal the semaphore after leaving the group
      
    }
    completionHandler(data, response, error)
  }.resume()
}

for id in ids {
  guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
  // TODO: Call dataTask_Group_Semaphore

  
  
  
}

group.notify(queue: queue) {
  print("All done!")
  images[0]
  PlaygroundPage.current.finishExecution()
}
