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
            TableCell(billingPeriod.description).style("width: 5rem;")
        }
    }
    
    public init(names: [String], price: String, billingPeriod: String) {
        self.names = names
        self.price = price
        self.billingPeriod = billingPeriod
    }
}
