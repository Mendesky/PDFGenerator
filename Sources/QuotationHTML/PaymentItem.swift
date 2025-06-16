//
//  PaymentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct PaymentItem: Component{
    let names: [String]
    let fee: String
    
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
                    Text(fee)
                }.style("text-align: right; white-space: nowrap; padding-right: 0.5em;")
            }.style("display: flex; align-items: top;")
        }
    }
    
    @available(*, deprecated, message: "use init(names:fee:) instead.")
    public init(names: [String], price: String, billingPeriod: String) {
        self.names = names
        self.fee = "\(price) \(billingPeriod.description)"
    }
    
    public init(names: [String], fee: String) {
        self.names = names
        self.fee = fee
    }
}
