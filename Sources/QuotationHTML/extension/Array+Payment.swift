//
//  Array+Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

extension Array where Element == Payment {
    public init(_ models: [Element.Model]){
        self = models.map{
            .init(
                name: $0.name,
                items: .init($0.items),
                needShowName: $0.needShowName)
        }
    }
}
