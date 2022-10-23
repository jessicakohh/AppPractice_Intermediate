//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by juyeong koh on 2022/10/23.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        
        // 처음에는 <다음> 버튼 비활성화
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // 텍스트필드에 커서가 바로 위치하도록
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 네비게이션 바 보이기
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
    // 계정 정보를 FirebaseAuto에 전달하는 때 > 모든 필드가 입력되어서 다음 버튼을 누르는 순간
    // Firebase 이메일 / 비밀번호 인증
    let email = emailTextField.text ?? ""
    let password = passwordTextField.text ?? ""
        
        // 신규 사용자 생성
        Auth.auth().createUser(withEmail: email, password: password) {[weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                let code = (error as NSError).code
                switch code {
                case 17001: //이미 가입한 계정일 때
                    // 로그인하기
                    self.loginUser(withEmail: email, password: password)
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            } else {
                // 에러가 없을 때 로그인이 제대로 끝났을 때 화면을 보여줌
                self.showMainViewController()
            }
        }
    }
    
    // 계정 생성이 잘 되었다면, 메인 뷰컨으로 이동시켜주어야 함
    private func showMainViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.show(mainViewController, sender: nil)
    }
    
    // FirebaseAuth를 통해 로그인을 할 수 있는 사이니 클롲 ㅓ추가
    private func loginUser(withEmail email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessageLabel.text = error.localizedDescription
            } else {
                self.showMainViewController()
            }
        }
    }
    
}

// MARK: - extension

extension EnterEmailViewController: UITextFieldDelegate {
    
    // 1. 이메일, 비밀번호 입력이 끝나고 나서 리턴 버튼을 눌렀을 때 키보드가 내려가도록
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    // 2. <다음> 버튼 활성화
    func textFieldDidEndEditing(_ textField: UITextField) {
        let isEmailEmpty = self.emailTextField.text == ""
        let isPasswordEmpty = self.passwordTextField.text == ""
        self.nextButton.isEnabled = !isEmailEmpty && !isPasswordEmpty
    }
}

