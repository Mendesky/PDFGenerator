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
    
    var lines: [String] {
        get {
            names.flatMap {
                $0.split(separator: "\n").map{ "\($0)" }
            }
        }
    }
    
    public var body: any Component{
        ComponentGroup{
            TableCell{
                for line in lines{
                    Div{
                        Text(line)
                    }
                }
            }
            TableCell{
                Div{
                    Text("\(price) \(billingPeriod.description)")
                }.style("text-align: right; white-space: nowrap; padding-right: 0.5em;")
            }
        }
    }
    
    public init(names: [String], price: String, billingPeriod: String) {
        self.names = names
        self.price = price
        self.billingPeriod = billingPeriod
    }
}
