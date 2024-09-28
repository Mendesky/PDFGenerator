//
//  BusinessClientAssistance.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct BusinessClientAssistance: Component{
    
    let title: String
    let items: [ContentItem]
    
    public var body: any Component{
        ComponentGroup{
            List{
                for item in items{
                    ListItem(item)
                }
            }.environmentValue(.ordered, key: .listStyle)
        }
    }
    
    public init(title: String, items: [ContentItem]) {
        self.title = title
        self.items = items
    }
}
