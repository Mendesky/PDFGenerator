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
                    TableRow(TableCell("\(chineseNumber)、\(title)"))
                }else{
                    TableRow(TableCell("\(title)"))
                }
                
                if let firstItem = items.first {
                    Table{
                        TableRow{
                            TableCell{
                                Div(Text("1.")).style("text-indent: 1.25em;")
                            }.style("vertical-align: top; padding-top: 1.05em;")
                            TableCell{
                                firstItem
                            }
                        }
                    }
                }
            }.style("break-inside: avoid-page;")
            if items.count > 1 {
                Table{
                    for (index, item) in items[1..<items.endIndex].enumerated(){
                        TableRow{
                            TableCell{
                                Div(Text("\(index+2).")).style("text-indent: 1.25em;")
                            }.style("vertical-align: top; padding-top: 1.05em;")
                            TableCell{
                                item
                            }
                        }.style("break-inside: avoid-page;")
                    }
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
