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
        ComponentGroup {
            Table {
                for payment in payments {
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
                                Div("\(item.fee)").style("text-align: right; white-space: nowrap;")
                            }
                        }
                    }
                }
            }.style("font-size: 0.875rem; width: 100%; border-collapse: separate; border-spacing: 0.2em;")
        }
    }
    
    public init(payments: [Payment]) {        
        self.payments = if payments.count == 1 {
            payments.map{
                $0.hideName()
            }
        }else{
            payments
        }
    }
}
