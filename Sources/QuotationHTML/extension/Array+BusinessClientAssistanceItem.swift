//
//  Array+BusinessClientAssistanceItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

extension Array where Element == BusinessClientAssistanceItem{
    public init(_ models: [BusinessClientAssistanceItem.Model]){
        self = models.map{
            .init(title: $0.title, content: $0.content)
        }
    }
}
