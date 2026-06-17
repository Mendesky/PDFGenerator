//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct PaymentBlock: Component {
    package let title: String
    package let payments: [Payment]
    
    public var body: any Component{
        // ≥2 個不同 case 時，在每個 case 第一個 bundle 上方插入 case 名稱標題（bundle 名標題落在其下）。
        let showCaseNames = PaymentCaseGrouping.showsCaseNames(payments)
        return ComponentGroup{
            Paragraph(title).style("font-size: 1.1rem;")
            Table{
                TableRow{
                    TableCell("服務項目").attribute(named: "colspan", value: "2").style("text-align: center ;")
                    TableCell{
                        Div("公費金額").style("white-space: nowrap; text-align: right; padding-right: 1em;")
                    }
                }.style("border-bottom: 1px solid black;")

                for run in PaymentCaseGrouping.runs(payments) {
                    if showCaseNames {
                        TableRow{
                            TableCell{
                                Text(run.caseName ?? "").bold().style("font-size: 1.2em;")
                            }.attribute(named: "colspan", value: "3")
                        }.style("padding-top: 0.5em;")
                    }
                    for payment in run.payments {
                        payment.style("font-size: 1rem; padding-bottom: 0.5em; width: 100%;")
                    }
                }

            }.style("border-collapse: collapse; width: 100%;")
        }
    }

    public init(title: String, payments: [Payment]) {
        self.title = title
        // 「單 bundle 不顯示 bundle 名」規則 per-case 套用：每個 case 只有 1 個 bundle 時隱藏 bundle 名
        // （該 case 的 case 標題已足夠識別），兩種情境一致：
        // - 多 case（合併顯示）：各 case 名標題照渲染；其中只有 1 個 bundle 的 case 隱藏其 bundle 名，
        //   只有 ≥2 bundle 的 case 才逐一顯示 bundle 名。
        // - 單一 case（分開顯示 / case 名標題不渲染）：單 bundle 同樣隱藏 bundle 名。
        self.payments = PaymentCaseGrouping.runs(payments).flatMap { run in
            run.payments.count == 1 ? run.payments.map { $0.hideName() } : run.payments
        }
    }
    
    public init(title: String = "酬金", payments models: [Payment.Model]) {
        self.init(title: title, payments: .init(models))
    }
}


