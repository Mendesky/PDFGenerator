//
//  BusinessClientAssistance.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct BusinessClientAssistance: Component {
    
    let title: String
    let items: [BusinessClientAssistanceItem]
    
    public var body: any Component{
        ComponentGroup{
            List{
                for item in items{
                    ListItem(item).style("break-inside: avoid-page;")
                }
            }.environmentValue(.ordered, key: .listStyle)
        }
    }
    
    public init(title: String, items: [BusinessClientAssistanceItem]) {
        self.title = title
        self.items = items
    }

    public init(title: String, items: [ContentItem]) {
        self.title = title
        self.items = items.map { BusinessClientAssistanceItem(title: $0.title, content: $0.content) }
    }
}
