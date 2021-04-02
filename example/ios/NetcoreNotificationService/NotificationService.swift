//
//  NotificationService.swift
//  NetcoreNotificationService
//
//  Created by webwerks1 on 3/16/21.
//

import UserNotifications
import Smartech
class NotificationService: UNNotificationServiceExtension {
    
    
    let smartechServiceExtension = SMTNotificationServiceExtension()
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        if Smartech.sharedInstance().isNotification(fromSmartech: request.content.userInfo) {
            smartechServiceExtension.didReceive(request, withContentHandler: contentHandler)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        smartechServiceExtension.serviceExtensionTimeWillExpire()
    }
    
}
