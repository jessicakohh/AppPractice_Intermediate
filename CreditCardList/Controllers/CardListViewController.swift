//
//  CardListViewController.swift
//  CreditCardList
//
//  Created by juyeong koh on 2022/10/24.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class CardListViewController: UITableViewController {
    
    // Firebase Realtime Database의 레퍼런스를 가져옴
    var ref: DatabaseReference!
    
    // 전달받은 데이터의 가공된 형태를 지정
    var creditCardList: [CreditCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView Cell Register
        let nibName = UINib(nibName: "CardListCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "CardListCell")
        
        // Firebase가 우리의 데이터베이스를 잡아내고, 앞으로 만든 데이터 흐름들을 주고받게 될 것
        ref = Database.database().reference()
        
        // 실시간 데이터베이스는 snapshot이라는 것을 이용해서 데이터를 불러오는데, 레퍼런스에서 값을 지켜보고 있다가
        // 값을 snapshot이라는 객체로 전달하게 됨 , value는 우리가 이해하고 있는 데이터베이스의 자료구조 형태를 지정해주는데
        // 이러한 타입을 정확하게 지정해 주지 않으면 데이터베이스는 이해하지 못해서 항상 nil을 방출하게 됨
        ref.observe(.value) { snapshot  in
            guard let value = snapshot.value as? [String: [String: Any]] else { return }
            // 제대로 지정해 주었다면 Codable을 통해서 객체 배열로 만들어 줄 수 있음
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value)
                let cardData = try JSONDecoder().decode([String: CreditCard].self, from: jsonData)
                let cardList = Array(cardData.values)
                self.creditCardList = cardList.sorted { $0.rank < $1.rank }
                // 전달이 잘 되었다면 reload를 해주어야 우리가 가져온 데이터를 잘 표현됨
                // 이 메소드는 UI를 표현하는 것으로, main스레드에서 작동해야함
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            } catch let error {
                print("Error Json parsing 과정에서 에러 : \(error.localizedDescription)")
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creditCardList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 우리가 만든 카드리스트셀이 없다면, 그냥 일반적인 테이블 셀을 반환하라 (옵셔널 처리)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardListCell", for: indexPath) as? CardListCell else { return UITableViewCell() }
        
        cell.rankLabel.text = "\(creditCardList[indexPath.row].rank)위"
        cell.promotionLabel.text = "\(creditCardList[indexPath.row].promotionDetail.amount)만원 증정"
        cell.cardNameLabel.text = "\(creditCardList[indexPath.row].name)"
        
        let imageURL = URL(string: creditCardList[indexPath.row].cardImageURL)
        cell.cardImageView.kf.setImage(with: imageURL)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 셀을 클릭했을 때 그 화면으로 갈 수 있도록
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 상세 화면 전달
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "CardDetailViewController") as? CardDetailViewController else { return }
        
        detailViewController.promotionDetail = creditCardList[indexPath.row].promotionDetail
        self.show(detailViewController, sender: nil)
        
        // Firebase Realtime Database에서 실시간으로 무엇이 클릭되었는지 확인 가능
        // Option1
        let cardID = creditCardList[indexPath.row].id
        ref.child("Item\(cardID)/isSeleted").setValue(true)
        
        // Option2
        //        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) {[weak self] snapshot in
        //            guard let self = self,
        //                  let value = snapshot.value as? [String: [String: Any]],
        //                  let key = value.keys.first else { return }
        //
        //            self.ref.child("\(key)/isSeleted").setValue(true)
        //  }
    }
    
    // 스와이프하면 삭제할 수 있는 Delegate
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Option1
        let cardID = creditCardList[indexPath.row].id
        ref.child("Item\(cardID)").removeValue()
        
        // Option2
//        ref.queryOrdered(byChild: "id").queryEqual(toValue: cardID).observe(.value) { [weak self] snapshot in
//            guard let self = self,
//                  let value = snapshot.value as? [String: [String: Any]],
//                  let key = value.keys.first else { return }
//
//            ref.child(key).removeValue()
//        }
    }
}

