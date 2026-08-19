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
    /// 酬金的**顯示字串**（如「12,000 元/月」、「優惠免收」）—— 呼叫端已組好。
    ///
    /// 千分位、`/次` `/月` `/年` 後綴、`0 → 優惠免收` 皆屬**業務呈現規則**（「優惠免收」更是
    /// 業務文案而非排版），由呼叫端決定。本 package 只負責把字串放進表格。
    ///
    /// 這也是 QuotingContext 時代的分工（其 `QuotationHTMLConverter` 就是在 caller 端組
    /// `displayFee` 字串）；OC 重寫時曾搬進本 package，現已回復。
    let fee: String

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
                Text(fee)
            }.style("text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;")
        }
    }

    public init(names: [String], fee: String) {
        self.names = names
        self.fee = fee
    }
}

extension PaymentItem {
    public struct Model {
        let names: [String]
        /// 已組好的顯示字串（見 `PaymentItem.fee`）。
        let fee: String

        public init(names: [String], fee: String) {
            self.names = names
            self.fee = fee
        }
    }
}
