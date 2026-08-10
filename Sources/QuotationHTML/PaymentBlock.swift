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
            // 以公司（case）為單位：每家公司各自一張表，各帶自己的「服務項目／公費金額」表頭，
            // 並包在 break-inside: avoid-page 的區塊，避免同一家公司被分頁從中間切開。
            for (runIndex, run) in PaymentCaseGrouping.runs(payments).enumerated() {
                Div{
                    Table{
                        TableRow{
                            TableCell("服務項目").attribute(named: "colspan", value: "2").style("text-align: center ;")
                            TableCell{
                                Div("公費金額").style("white-space: nowrap; text-align: right; padding-right: 1em;")
                            }
                        }.style("border-bottom: 1px solid black;")

                        if showCaseNames {
                            TableRow{
                                TableCell{
                                    Text(run.caseName ?? "").bold().style("font-size: 1.05em;")
                                }.attribute(named: "colspan", value: "3")
                            }.style("padding-top: 0.5em;")
                        }
                        for payment in run.payments {
                            payment.style("font-size: 1rem; padding-bottom: 0.5em; width: 100%;")
                        }
                    }.style("border-collapse: collapse; width: 100%;")
                }.style("break-inside: avoid-page;" + (runIndex > 0 ? " margin-top: 1em;" : ""))
            }
        }
    }

    public init(title: String, payments: [Payment]) {
        self.title = title
        self.payments = PaymentCaseGrouping.hidingSingleBundleNames(payments)
    }
    
    public init(title: String = "酬金", payments models: [Payment.Model]) {
        self.init(title: title, payments: .init(models))
    }
}


