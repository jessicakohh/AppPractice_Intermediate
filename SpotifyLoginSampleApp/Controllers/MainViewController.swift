//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by juyeong koh on 2022/10/23.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.navigationBar.isHidden = false
    }

    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        
        // 실제로 버튼을 누르면 로그인 뷰 컨트롤러로 넘어감
        self.navigationController?.popToRootViewController(animated: true)
    }
}
