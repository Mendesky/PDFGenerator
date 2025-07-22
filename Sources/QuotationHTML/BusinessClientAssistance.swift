//
//  BusinessClientAssistance.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct BusinessClientAssistance: Component {
    let index: Int
    let title: String
    let items: [BusinessClientAssistanceItem]
    
    public var body: any Component{
        ComponentGroup{
            Div{
                let chineseNumber = index.representToChineseString(offset: 1)
                TableRow(TableCell("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                
                for (offset, item) in items.enumerated() {
                    Div{
                        Div(Text("（\(offset.representToChineseString(offset: 1))）\(item.title)")).style("display: flex; text-indent: 2em; padding-bottom: 1em;")
                        Div{
                            Div(item.content).style("display: flex; text-indent: 2em;")
                        }.style("display: flex; flex-direction: column; padding-left: 5em;")
                    }.style("display: flex; flex-direction: column;  break-inside: avoid-page; ")
                }
            }
        }
    }
    
    public init(title: String, items: [BusinessClientAssistanceItem]) {
        self.index = -1
        self.title = title
        self.items = items
    }
    
    public init(title: String, items: [ContentItem]) {
        self.index = -1
        self.title = title
        self.items = items.map { BusinessClientAssistanceItem(title: $0.title, content: $0.content) }
    }
    
    internal init(index: Int, title: String, items: [BusinessClientAssistanceItem.Model]) {
        self.index = index
        self.title = title
        self.items = items.map { BusinessClientAssistanceItem(title: $0.title, content: $0.content) }
    }
    
}


extension BusinessClientAssistance {
    public struct Model {
        let title: String
        let items: [BusinessClientAssistanceItem.Model]
        
        public init(title: String, items: [BusinessClientAssistanceItem.Model]) {
            self.title = title
            self.items = items
        }
    }
}
