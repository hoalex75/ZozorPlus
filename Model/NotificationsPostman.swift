//
//  NotificationsPostman.swift
//  CountOnMe
//
//  Created by Alex on 09/02/2019.
//  Copyright © 2019 Ambroise Collon. All rights reserved.
//

import Foundation

public class NotificationsPostman {
    func createAndPostNotifications(_ NotificationName: String) {
        let name = Notification.Name(NotificationName)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
    
    func createAndPostNotificationsWithText(_ NotificationName: String,_ text : String) {
        let textToSend: [String : String] = ["text" : text]
        let name = Notification.Name(NotificationName)
        NotificationCenter.default.post(name: name, object: nil, userInfo: textToSend)
    }
    
    func createAndPostNotificationsWithInt(_ NotificationName: String,_ number : Int) {
        let numberToSend: [String : Int] = ["total" : number]
        let name = Notification.Name(NotificationName)
        NotificationCenter.default.post(name: name, object: nil, userInfo: numberToSend)
    }
}
