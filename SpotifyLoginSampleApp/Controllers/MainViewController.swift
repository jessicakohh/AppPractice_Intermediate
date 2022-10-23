//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by juyeong koh on 2022/10/23.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
        
        // 로그인 한 이메일이 메일에 들어섰을 때 표현
        // 로그인을 했을 때 Firebase 인증을 통해서 로그인 한 사용자의 이메일을 가져오기
        // 만약 정보가 없다면, "고객" 이라고 표시
        let email = Auth.auth().currentUser?.email ?? "고객"
        welcomeLabel.text = """
        환영합니다.
        \(email)님
        """
        
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            // 실제로 버튼을 누르면 로그인 뷰 컨트롤러로 넘어감 (오류가 없을 때, 즉 제대로 로그아웃이 되었을 때 실행)
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error: Signout \(signOutError.localizedDescription)")
        }

    }
}
