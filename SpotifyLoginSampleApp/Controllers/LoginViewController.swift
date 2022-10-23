//
//  LoginViewControllers.swift
//  SpotifyLoginSampleApp
//
//  Created by juyeong koh on 2022/10/23.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailLoginButton, googleLoginButton, appleLoginButton].forEach {
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    
    // 첫 화면이기 때문에 네비게이션 바를 보여주지 않을 것
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 숨기기
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func googleLoginButtonTapped(_ sender: UIButton) {
        // Firebase 인증코드
    }
    
    @IBAction func appleLoginButtonTapped(_ sender: Any) {
        // Firebase 인증코드
    }
    
    
}

