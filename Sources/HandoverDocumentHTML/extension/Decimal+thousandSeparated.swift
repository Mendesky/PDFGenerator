//
//  Decimal+thousandSeparated.swift
//  PDFGenerator
//
//  金額千分位顯示 — 對應 Frontend `| number:'1.0-0'`（無小數、千分位）。
//

import Foundation

extension Decimal {
    var thousandSeparated: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: self as NSDecimalNumber) ?? "\(self)"
    }
}
