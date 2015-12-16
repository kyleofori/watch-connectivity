//
//  AppWatchSessionManager.swift
//  cinematime
//
//  Created by Kyle Ofori on 12/14/15.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//

import Foundation
import WatchConnectivity

class AppWatchSessionManager: NSObject, WCSessionDelegate {
  
  lazy var notificationCenter: NSNotificationCenter = {
    return NSNotificationCenter.defaultCenter()
  }()
  
  static let sharedManager = AppWatchSessionManager()
  private override init() {
    super.init()
  }
  
  private let session: WCSession? = WCSession.isSupported() ? WCSession.defaultSession() : nil
  
  func startSession() {
    session?.delegate = self
    session?.activateSession()
  }
  
  // 1
  func session(session: WCSession, didReceiveApplicationContext applicationContext: [String : AnyObject]) {
    print("Watch->Phone Receiving Context: \(applicationContext)")
    // 2
    if let movies = applicationContext["movies"] as? [String] {
      // 3
      TicketOffice.sharedInstance.purchaseTicketsForMovies(movies)
      // 4
      dispatch_async(dispatch_get_main_queue()) { () -> Void in
        self.notificationCenter.postNotificationName(NotificaitonPurchasedMovieOnWatch, object: nil)
      }
    }
  }
  
  // MARK: - Watch Connectivity
  
  private func sendPurchasedMoviesToWatch(notification: NSNotification) {
    // 1
    if WCSession.isSupported() {
      // 2
      if let movies = TicketOffice.sharedInstance.purchasedMovieTicketIDs() {
        // 3
        let session = WCSession.defaultSession()
        if session.watchAppInstalled {
          // 4
          do {
            let dictionary = ["movies": movies]
            try session.updateApplicationContext(dictionary)
          } catch {
            print("ERROR: \(error)")
          }
        }
      }
    }
  }
  
  // MARK: - Notification Center
  
  func setupNotificationCenter() {
    notificationCenter.addObserverForName(NotificationPurchasedMovieOnPhone, object: nil, queue: nil) { (notification:NSNotification) -> Void in
      self.sendPurchasedMoviesToWatch(notification)
    }
  }
  
}