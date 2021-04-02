//
//  NotificationViewController.swift
//  NetocoreContentService
//
//  Created by webwerks1 on 3/16/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import Smartech

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var customBgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Smartech.sharedInstance().loadCustomNotificationContentView(customBgView)
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        Smartech.sharedInstance().didReceiveCustomNotification(notification)
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
            Smartech.sharedInstance().didReceiveCustomNotificationResponse(response) { (option) in
                completion(option)
            }
        }
}
