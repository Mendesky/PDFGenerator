//
//  PaymentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Foundation
import Plot

public struct PaymentItem: Component{
    let names: [String]
    let fee: Fee

    /// 酬金金額表達。
    ///
    /// `amount`（各 case 的關聯值）是**領域值**：caller（OC）只給「月收 / 年收 / 一次性 + 金額」，
    /// 其中 monthly 金額已由 caller 正規化為前 12 月一致的單月金額（業務算法）。
    ///
    /// 顯示成什麼樣子——千分位、`/次` `/月` `/年` 後綴、金額 0 顯示「優惠免收」——全由 `displayText`
    /// 決定，**屬 presentation、歸 PDFGenerator**；caller 不應自行組顯示字串。
    public enum Fee: Sendable, Equatable {
        case oneTime(Decimal)
        case yearly(Decimal)
        case monthly(Decimal)

        /// PDF 顯示字串：`amount == 0` → 「優惠免收」；否則「{千分位金額} 元{/次|/月|/年}」。
        public var displayText: String {
            let amount: Decimal
            let suffix: String
            switch self {
            case .oneTime(let value): amount = value; suffix = "/次"
            case .yearly(let value): amount = value; suffix = "/年"
            case .monthly(let value): amount = value; suffix = "/月"
            }
            if amount == 0 { return "優惠免收" }
            return "\(Self.formatAmount(amount)) 元\(suffix)"
        }

        /// 千分位、無小數（金額為整數元）。
        private static func formatAmount(_ amount: Decimal) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 0
            formatter.groupingSeparator = ","
            formatter.groupingSize = 3
            return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
        }
    }

    var lines: [String] {
        get {
            names.flatMap {
                $0.split(separator: "\n").map{ "\($0)" }
            }
        }
    }

    public var body: any Component{
        ComponentGroup{
            TableCell{
                for line in lines{
                    Div{
                        Text(line)
                    }
                }
            }
            TableCell{
                Text(fee.displayText)
            }.style("text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;")
        }
    }

    public init(names: [String], fee: Fee) {
        self.names = names
        self.fee = fee
    }
}

extension PaymentItem {
    public struct Model {
        let names: [String]
        let fee: Fee

        public init(names: [String], fee: Fee) {
            self.names = names
            self.fee = fee
        }
    }
}
