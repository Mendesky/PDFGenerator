//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct PaymentBlock: Component {
    let title: String
    let payments: [Payment]
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(title)
            Table{
                TableRow{
                    TableCell("服務項目").attribute(named: "colspan", value: "2").style("text-align: center ;")
                    TableCell{
                        Div("公費金額").style("white-space: nowrap; text-align: right; padding-right: 1em;")
                    }
                }.style("border-bottom: 1px solid black;")
                
                for payment in payments {
                    payment.style("padding-bottom: 0.5em; width: 100%;")
                }
                
            }.style("border-collapse: collapse; width: 100%;")
        }
    }
    
    public init(title: String, payments: [Payment]) {
        self.title = title
        self.payments = if payments.count == 1 {
            payments.map{
                $0.hideName()
            }
        }else{
            payments
        }
    }
}

public struct ReplyFormPayment: Component {

    let paymentItems: [PaymentItem]

    public var body: any Component {
        ComponentGroup {
            Table {
                for (index, item) in paymentItems.enumerated() {
                    TableRow {
                        TableCell("(\(index+1))").style("vertical-align: middle;")
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
