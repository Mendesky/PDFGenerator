//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct Payment: Component {
    let title: String
    let items: [PaymentItem]
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(title)
            Table{
                TableRow{
                    TableCell()
                    TableCell("服務項目")
                    TableCell{
                        Div("公費金額").style("white-space: nowrap; text-align: right; padding-right: 1em;")
                    }
                }.style("border-bottom: 1px solid black;")
                
                for (index, item) in items.enumerated(){
                    TableRow{
                        TableCell("(\(index+1))").style("padding-right: 0.5em; padding-bottom: 0.5em;")
                        item.style("padding-bottom: 0.5em; width: 100%;")
                    }
                }
                
            }.style("border-collapse: collapse; width: 100%;")
        }
    }
    
    public init(title: String, items: [PaymentItem]) {
        self.title = title
        self.items = items
    }
}

public struct ReplyFormPayment: Component {

    let paymentItems: [PaymentItem]

    public var body: any Component {
        ComponentGroup {
            Table {
                for (index, item) in paymentItems.enumerated() {
                    TableRow {
                        TableCell("(\(index+1))").style("vertical-align: middle; padding-right: 0.5em;")
                        TableCell {
                            for line in item.lines {
                                Div(line)
                            }
                        }.style("vertical-align: middle; width: 100%;")
                        TableCell{
                            Div("\(item.price) \(item.billingPeriod.description)").style("text-align: right; white-space: nowrap;")
                        }
                    }
                }
            }.style("font-size: 14px; width: 100%; border-collapse: separate; border-spacing: 0.2em;")
        }
    }
    
    public init(paymentItems: [PaymentItem]) {
        self.paymentItems = paymentItems
    }
}
