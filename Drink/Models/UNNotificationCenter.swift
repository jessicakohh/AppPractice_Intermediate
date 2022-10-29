//
//  UNNotificationCenter.swift
//  Drink
//
//  Created by juyeong koh on 2022/10/28.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    
    func addNotificationRequest(by alert: Alert) {
        let content = UNMutableNotificationContent()
        content.title = "물 마실 시간이예요!"
        content.body = "세계 보건 기구(WHO)가 권장하는 하루 물 섭취량은 1.5~2L 입니다."
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.hour, .minute], from: alert.date)
        // 날짜는 알럿 객체가 가지고 있으니까 해당 데이트를 시간 분 형태의 데이트 컴포넌트로 만들어 주면 됨 
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: alert.isOn)
        
        let request = UNNotificationRequest(identifier: alert.id, content: content, trigger: trigger)
        
        self.add(request, withCompletionHandler: nil)
    }
}
