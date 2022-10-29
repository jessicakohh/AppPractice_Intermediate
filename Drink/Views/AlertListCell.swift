//
//  AlertListCell.swift
//  Drink
//
//  Created by juyeong koh on 2022/10/25.
//

import UIKit
import UserNotifications


class AlertListCell: UITableViewCell {
    let userNotificationCenter = UNUserNotificationCenter.current()

    
    @IBOutlet weak var meridiemLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alertSwitch: UISwitch!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    
    @IBAction func alertSwitchValueChanged(_ sender: UISwitch) {
        guard let data = UserDefaults.standard.value(forKey: "alerts") as? Data,
              var alerts = try? PropertyListDecoder().decode([Alert].self, from: data) else { return }
        
        alerts[sender.tag].isOn = sender.isOn
        UserDefaults.standard.set(try? PropertyListEncoder().encode(alerts), forKey: "alerts")
        
        // 스위치가 처음에는 온 상태이고, 추가된 직후에는 알럿리스트뷰컨에서 알림을 추가할 것이라 해당되지 않지만
        // 껐다가 다시 켠 경우에는 추가해주어야 함
        if sender.isOn {
            userNotificationCenter.addNotificationRequest(by: alerts[sender.tag])
        } else {
            userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [alerts[sender.tag].id])
        }
    }
}



