//
//  PaymentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public enum BillingPeriod: CustomStringConvertible{
    case once
    case monthly12
    case monthly13
    case monthly14
    case yearly
    
    public var description: String{
        return switch self {
        case .once:
            "元/次"
        case .yearly:
            "元/年"
        case .monthly12, .monthly13, .monthly14:
            "元/月"
        }
    }
}

public struct PaymentItem: Component{
    let names: [String]
    let price: String
    let billingPeriod: String
    
    public var body: any Component{
        ComponentGroup{
            TableCell{
                Text(names[0])
                for name in names[1..<names.endIndex]{
                    Node.br()
                    Text(name)
                }
            }
            TableCell(price)
            TableCell(billingPeriod.description).style("width: 2.5em;")
        }
    }
    
    public init(names: [String], price: String, billingPeriod: String) {
        self.names = names
        self.price = price
        self.billingPeriod = billingPeriod
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
                            for name in item.names {
                                Div(name)
                            }
                        }.style("vertical-align: middle;")
                        TableCell(item.price)
                        TableCell(item.billingPeriod.description)
                    }
                }
            }.style("font-size: 14px;")
        }
    }
    
    public init(paymentItems: [PaymentItem]) {
        self.paymentItems = paymentItems
    }
}
