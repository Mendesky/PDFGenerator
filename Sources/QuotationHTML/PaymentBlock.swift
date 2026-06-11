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
        // 單一 case 時沿用「單 bundle 不顯示 bundle 名」；多 case 時各 bundle 名都要顯示在 case 名底下，
        // 故不套用單 bundle 隱藏（body 依 caseName 分組決定是否加 case 標題）。
        self.payments = if PaymentCaseGrouping.showsCaseNames(payments) {
            payments
        } else if payments.count == 1 {
            payments.map{
                $0.hideName()
            }
        }else{
            payments
        }
    }
    
    public init(title: String = "酬金", payments models: [Payment.Model]) {
        self.init(title: title, payments: .init(models))
    }
}


