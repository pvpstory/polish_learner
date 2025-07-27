//
//  NotificationSettings.swift
//  polish_learner
//
//  Created by Микола Ясінський on 27/07/2025.
//

import Foundation
import SwiftUI





class NotificationSettings: ObservableObject {
    @AppStorage("isNotificationsEnabled") var isNotificationsEnabled: Bool = true
    @AppStorage("notificationIntervalInDays") var notificationIntervalInDays: Int = 1
    @AppStorage("notificationTime") var notificationTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
}
