//
//  Alert.swift
//  Drink
//
//  Created by juyeong koh on 2022/10/26.
//

import UIKit


struct Alert: Codable {
    var id: String = UUID().uuidString
    var date: Date
    var isOn: Bool
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        return timeFormatter.string(from: date)
    }
    
    var meridiem: String {
        let merideimFormatter = DateFormatter()
        // 오전오후를 설명하는 데이트포메터
        merideimFormatter.dateFormat = "a"
        merideimFormatter.locale = Locale(identifier: "ko")
        
        return merideimFormatter.string(from: date)
    }
}
