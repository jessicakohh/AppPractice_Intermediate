//
//  ViewController.swift
//  Notice
//
//  Created by juyeong koh on 2022/10/25.
//

import UIKit
import FirebaseRemoteConfig
import FirebaseAnalytics

class ViewController: UIViewController {
    
    // 원격구성으로 팝업 제어하기 _ Key:Value 형식으로 작성, 뷰컨에서 원격 구성 값을 불러와서 noticeVC에 전달하고 제어
    // 원격 구성 플랫폼 가져오기
    var remoteConfig: RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        remoteConfig = RemoteConfig.remoteConfig()
        let setting = RemoteConfigSettings()
        // 테스트를 위해서 새로운 값을 패치하는 인터벌을 최소화하여 최대한 자주 데이터를 가져올 수 있도록
        setting.minimumFetchInterval = 0
        
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNotice()
    }
}

// RemoteConfig
extension ViewController {
    func getNotice() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch { [weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("error: config not fetched(구성을 가져오지 못했습니다.)")
            }
            
            guard let self = self else { return }
            
            if !self.isNoticeHidden(remoteConfig) {
                let noticeVC = NoticeViewController(nibName: "", bundle: nil)
                
                noticeVC.modalPresentationStyle = .custom
                noticeVC.modalTransitionStyle = .crossDissolve
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let date = (remoteConfig["date"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                noticeVC.noticeContents = (title: title, detail: detail, date: date)
                self.present(noticeVC, animated: true, completion: nil)

            } else {
                self.showEventAlert()
            }
        }
    }
    
    func isNoticeHidden(_ remoteConfig: RemoteConfig) -> Bool {
        return remoteConfig["isHidden"].boolValue
    }
}


// A/B Testing
extension ViewController {
    func showEventAlert() {
        guard let remoteConfig = remoteConfig else { return }
        
        remoteConfig.fetch() { [weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            } else {
                print("config not fetched")
            }
            let message = remoteConfig["message"].stringValue ?? ""
            
            let confirmAction = UIAlertAction(title: "확인하기", style: .default) { _ in
                // Google Analytics
                Analytics.logEvent("promotion_alert", parameters: nil)
            }
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let alertController = UIAlertController(title: "깜짝이벤트", message: message, preferredStyle: .alert)
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}

