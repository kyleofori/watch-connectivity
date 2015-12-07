/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import WatchKit
import Foundation


class MoviesController: WKInterfaceController {
  
  @IBOutlet var table: WKInterfaceTable!
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    updateDisplay()
  }
  
  private func updateDisplay() {
    let movies = TicketOffice.sharedInstance.allMovies
    
    let numberOfMovies = movies.count
    table.setNumberOfRows(numberOfMovies, withRowType: "MovieRowType")
    
    for index in 0...(numberOfMovies-1) {
      if let controller = table.rowControllerAtIndex(index) as? MovieRowController {
        let movie = movies[index]
        controller.movie = movie
      }
    }
    
  }
  
  // MARK: - Segue
  
  override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
    if let rowController = table.rowControllerAtIndex(rowIndex) as? MovieRowController {
      return rowController.movie
    }
    return nil
  }
}