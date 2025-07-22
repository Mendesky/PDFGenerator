//
//  File.swift
//  QuotingContext
//
//  Created by Grady Zhuo on 2025/7/9.
//


extension Int {

    func representToChineseString(offset: Int = 0) -> String {
        // 中文數字映射
        let digits = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
        let units = ["", "十", "百"]
        
        
        let number = self + offset
        // 將數字分解為陣列（百位、十位、個位）
        let hundred = Int(number / 100)
        let ten = Int((number % 100) / 10)
        let one = Int(number % 10)
        
        var result = ""
        
        // 處理百位
        if hundred > 0 {
            result += digits[hundred] + units[2]
        }
        
        // 處理十位
        if ten > 0 {
            // 如果十位是1且百位為0，省略「一」直接寫「十」
            if ten == 1 && hundred == 0 {
                result += units[1]
            } else {
                result += digits[ten] + units[1]
            }
        } else if hundred > 0 && (ten > 0 || one > 0) {
            // 百位有值且十位為0，需補「零」
            result += digits[0]
        }
        
        // 處理個位
        if one > 0 {
            result += digits[one]
        } else if self == 0 {
            // 特殊情況：輸入為0時返回「零」
            result = digits[0]
        }
        
        return result
    }
}
