// Copyright (c) 2023 Kodeco Inc.
// For full license & permission details, see LICENSE.markdown.

import UIKit
import PlaygroundSupport
//: # Downloading Images in an OperationQueue
//: Subclass `AsyncOperation` to create an operation that
//: uses `URLSession` `dataTask(with:)` to download an image.
//: Then use this in an `OperationQueue` to download the images
//: represented by the `ids` array.
class ImageLoadOperation: AsyncOperation {
  private let url: URL
  var image: UIImage?

  init(url: URL) {
    self.url = url
    super.init()
  }
  
  // DONE: Call dataTask with url and save image
  override func main() {
    URLSession.shared.dataTask(with: url) {
      [weak self] data, response, error in
      guard let self else { return }
      defer { self.state = .finished }
      guard error == nil, let data else { return }
      image = UIImage(data: data)
    }
    .resume()
  }
}
//: For each `id`, create a `url`.
//: Then, for each url, create an `ImageLoadOperation`,
//: and add it to an `OperationQueue`.
//: When each operation completes, add its output `image` to the `images` array.
let base = "https://cdn.kodeco.com/books/con/image-from-rawpixel-id-"
let ids = [466881, 466910, 466925, 466931, 466978, 467028, 467032, 467042, 467052]
var images: [UIImage] = []
let queue = OperationQueue()

for id in ids {
  guard let url = URL(string: "\(base)\(id)-jpeg.jpg") else { continue }
  // DONE: Create operation with completionBlock and add to queue
  let op = ImageLoadOperation(url: url)
  op.completionBlock = {
    if let image = op.image { images.append(image) }
  }
  queue.addOperation(op)
}

duration {
  queue.waitUntilAllOperationsAreFinished()
}
sleep(1)  // give playground time to finish counting

images[8]

PlaygroundPage.current.finishExecution()
