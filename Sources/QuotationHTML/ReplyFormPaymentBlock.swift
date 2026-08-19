//
//  ReplyFormPaymentBlock.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/4/24.
//
import Plot

public struct ReplyFormPaymentBlock: Component {

    let payments: [Payment]

    public var body: any Component {
        // 多 case 時與主酬金一致：每個 case 第一個 bundle 上方加 case 名稱標題。
        let showCaseNames = PaymentCaseGrouping.showsCaseNames(payments)
        return ComponentGroup {
            // 以公司（case）為單位，每個 run 各自成一張表並包在 break-inside: avoid 的區塊，
            // 避免同一家公司的酬金被分頁從中間切開。各表皆 width: 100% 且金額欄靠右，
            // 故跨公司的金額右緣仍對齊。
            for run in PaymentCaseGrouping.runs(payments) {
                Div {
                    Table {
                        if showCaseNames {
                            TableRow{
                                TableCell(Text(run.caseName ?? "").bold().style("font-size: 1.1em;")).attribute(named: "colspan", value: "3").style("vertical-align: middle;")
                            }
                        }
                        for payment in run.payments {
                            if payment.needShowName {
                                TableRow{
                                    TableCell(Text(payment.name).bold()).attribute(named: "colspan", value: "3").style("vertical-align: middle;")
                                }
                            }

                            for (index, item) in payment.items.enumerated() {
                                TableRow {
                                    TableCell("(\(index+1))").style("vertical-align: top;")
                                    TableCell {
                                        for line in item.lines {
                                            Div(line)
                                        }
                                    }.style("vertical-align: top; width: 100%;")
                                    TableCell{
                                        Text(item.fee)
                                    }.style("vertical-align: top; text-align: right; white-space: nowrap;")
                                }
                            }
                        }
                    }.style("font-size: 0.875rem; width: 100%; border-collapse: separate; border-spacing: 0.2em;")
                }.style("break-inside: avoid-page;")
            }
        }
    }
    
    public init(payments: [Payment]) {
        // 與主酬金 PaymentBlock 一致：單 bundle 的 case 隱藏 bundle 名（per-case 判斷，非全域 count）。
        self.payments = PaymentCaseGrouping.hidingSingleBundleNames(payments)
    }
}
