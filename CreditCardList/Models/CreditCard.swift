//
//  CreditCard.swift
//  CreditCardList
//
//  Created by juyeong koh on 2022/10/24.
//

import Foundation

struct CreditCard: Codable {
    
    let id: Int
    let rank: Int
    let name: String
    let cardImageURL: String
    let promotionDetail: PromotionDetail
    // 추후 사용자가 카드를 선택했을 때 사용
    let isSelected: Bool?
    
}

struct PromotionDetail: Codable {
    let companyName: String
    let period: String
    let amount: Int
    let condition: String
    let benefitCondition: String
    let benefitDetail: String
    let benefitDate: String
    
}
