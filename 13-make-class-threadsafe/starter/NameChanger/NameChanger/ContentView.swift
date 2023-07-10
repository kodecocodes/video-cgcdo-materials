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

struct ContentView: View {
  let nameList = [
    ("Charlie", "Cheesecake"), ("Delia", "Dingle"), ("Eva", "Evershed"),
    ("Freddie", "Frost"), ("Gina", "Gregory")
  ]
  let workerQueue = DispatchQueue(label: "com.kodeco.worker", attributes: .concurrent)

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")
    }
    .padding()
    .onAppear {
      changeNameRace()
      // changeNameSafely()
    }
  }

  func changeNameRace() {
    let nameChangingPerson = Person(firstName: "Alison", lastName: "Anderson")
    let nameChangeGroup = DispatchGroup()

    for (idx, name) in nameList.enumerated() {
      workerQueue.async(group: nameChangeGroup) {
        usleep(UInt32(10_000 * idx))
        nameChangingPerson.changeName(firstName: name.0, lastName: name.1)
        print("Current Name: \(nameChangingPerson.name)")
      }
    }

    nameChangeGroup.notify(queue: DispatchQueue.main) {
      print("Final name: \(nameChangingPerson.name)")
    }
    nameChangeGroup.wait()  // ??
  }

  func changeNameSafely() {
    let threadSafeNameGroup = DispatchGroup()
    let threadSafePerson = ThreadSafePerson(firstName: "Anna", lastName: "Adams")

    for (idx, name) in nameList.enumerated() {
      workerQueue.async(group: threadSafeNameGroup) {
        usleep(UInt32(10_000 * idx))
        threadSafePerson.changeName(firstName: name.0, lastName: name.1)
        print("Current threadsafe name: \(threadSafePerson.name)")
      }
    }

    threadSafeNameGroup.notify(queue: DispatchQueue.main) {
      print("Final threadsafe name: \(threadSafePerson.name)")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
