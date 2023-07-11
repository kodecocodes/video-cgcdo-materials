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

import SwiftUI

struct DownloadedImage: Identifiable {
  let id: Int
  let url: URL
  var image: UIImage
}

class ImageStore: ObservableObject {
  @Published var images: [DownloadedImage] = []
  var urls: [URL] = []
  private let queue = OperationQueue()

  func getUrls() {
    guard
      let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
      let serialUrls = serial as? [String] else {
      print("Something went horribly wrong!")
      return
    }
    urls = serialUrls.compactMap { URL(string: $0) }
  }

  func createImagesArray() {
    getUrls()
    for (index, url) in urls.enumerated() {
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        self.images.append(
          DownloadedImage(
            id: index,
            url: url,
            image: UIImage(systemName: "questionmark.square") ?? UIImage()))
      }
    }
  }

  func downloadImageOp(index: Int) {
    let operation = NetworkImageOperation(url: images[index].url)
    operation.completionBlock = {
      guard let image = operation.image else { return }
      DispatchQueue.main.async {
        self.images[index].image = image
      }
    }
    queue.addOperation(operation)
  }
}
