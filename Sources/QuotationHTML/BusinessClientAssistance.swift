//
//  BusinessClientAssistance.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//

import Plot

public struct BusinessClientAssistance: Component {
    let index: Int?
    let title: String
    let items: [BusinessClientAssistanceItem]
    
    public var body: any Component{
        ComponentGroup{
            Div{
                if let index {
                    let chineseNumber = toChineseNumber(index: index)
                    TableRow(TableCell("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                }else{
                    TableRow(TableCell("\(title)")).style("font-size: 1.1em;")
                }
                
                for (offset, item) in items.enumerated() {
                    Div{
                        Div(Text("（\(toChineseNumber(index: offset))）\(item.title)")).style("display: flex; text-indent: 2em; padding-bottom: 1em;")
                        Div{
                            Div(item.content).style("display: flex; text-indent: 2em;")
                        }.style("display: flex; flex-direction: column; padding-left: 5em;")
                    }.style("display: flex; flex-direction: column;  break-inside: avoid-page; ")
                }
            }
        }
    }
    
    public init(title: String, items: [BusinessClientAssistanceItem]) {
        self.index = nil
        self.title = title
        self.items = items
    }
    
    public init(title: String, items: [ContentItem]) {
        self.index = nil
        self.title = title
        self.items = items.map { BusinessClientAssistanceItem(title: $0.title, content: $0.content) }
    }
    
    private init(index: Int, title: String, items: [BusinessClientAssistanceItem]) {
        self.index = index
        self.title = title
        self.items = items.map { BusinessClientAssistanceItem(title: $0.title, content: $0.content) }
    }
    
    
    func set(index: Int)->Self{
        return .init(index: index, title: title, items: items)
    }
    
}
