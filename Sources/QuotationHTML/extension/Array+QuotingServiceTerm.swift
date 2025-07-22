//
//  Array+QuotingServiceTerm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//
extension Array where Element == QuotingServiceTerm{
    public init(_ models: [QuotingServiceTerm.Model]){
        self = models.map{
            .init(model: $0)
        }
    }
}
