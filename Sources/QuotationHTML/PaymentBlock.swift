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
        ComponentGroup{
            Paragraph(title).style("font-size: 1.1rem;")
            Table{
                TableRow{
                    TableCell("服務項目").attribute(named: "colspan", value: "2").style("text-align: center ;")
                    TableCell{
                        Div("公費金額").style("white-space: nowrap; text-align: right; padding-right: 1em;")
                    }
                }.style("border-bottom: 1px solid black;")
                
                for payment in payments {
                    payment.style("font-size: 1rem; padding-bottom: 0.5em; width: 100%;")
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


