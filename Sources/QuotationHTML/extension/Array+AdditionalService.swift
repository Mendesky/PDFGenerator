//
//  Array+AdditionalService.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

extension Array where Element == AdditionalService{
    public init(_ models: [AdditionalService.Model]){
        self = models.map{
            .init(name: $0.name, isSelected: $0.isSelected)
        }
    }
}
