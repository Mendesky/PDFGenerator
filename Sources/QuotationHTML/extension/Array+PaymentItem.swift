//
//  Array+PaymentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

extension Array where Element == PaymentItem{
    public init(_ models: [Element.Model]){
        self = models.map{
            .init(names: $0.names, fee: $0.fee)
        }
    }
}
