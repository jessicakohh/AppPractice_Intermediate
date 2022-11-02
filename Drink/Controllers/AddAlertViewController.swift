//
//  AddAlertViewController.swift
//  Drink
//
//  Created by juyeong koh on 2022/10/26.
//

import UIKit

class AddAlertViewController: UIViewController {
    
    // 확인버튼 누르면 부모뷰에 전달할 수 있도록
    var pickedDate: ((_ date: Date) -> Void)?

    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func dismissButtonTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        pickedDate?(datePicker.date)
        self.dismiss(animated: true, completion: nil)
    }
    
}
