//
//  SettingsView.swift
//  polish_learner
//
//  Created by Микола Ясінський on 27/07/2025.
//

import Foundation
import SwiftUI


struct SettingsView: View {
    @StateObject var settings = NotificationSettings()
    var body: some View{
        VStack(alignment: .leading, spacing: 15){
            Toggle("Allow Notifications", isOn: settings.$isNotificationsEnabled)
            Picker("Interval is Days of your regular notification", selection: settings.$notificationIntervalInDays){
                ForEach(1...8, id: \.self){ day in
                    Text(" every \(day) days")
                }
            }
            DatePicker("The time of your regular notification", selection: settings.$notificationTime, displayedComponents: .hourAndMinute)
            Button("print settings"){
                print(settings.isNotificationsEnabled)
                print(settings.notificationTime)
                print(settings.notificationIntervalInDays)
            }
            Spacer()

        }.frame(maxWidth: .infinity, maxHeight: .infinity).padding(25)
        
    }
}
