//
//  QuotationContentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ContentItem: Component{
    let index: Int?
    let title: String
    let content: String
    
    public init(title: String, content: String) {
        self.index = nil
        self.title = title
        self.content = content
    }
    
    private init(index: Int, title: String, content: String) {
        self.index = index
        self.title = title
        self.content = content
    }
    
    public var body: any Component {
        ComponentGroup{
            Table{
                if let index {
                    let chineseNumber = toChineseNumber(index: index)
                    TableRow(TableCell("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                }else{
                    TableRow(TableCell("\(title)")).style("font-size: 1.1em;")
                }
                TableRow(TableCell{
                    Paragraph(content).style("text-indent: 2em;")
                })
            }.style("break-inside: avoid-page;")
            
        }
    }
    
    
    
    func set(index: Int)->Self{
        return .init(index: index, title: title, content: content)
    }
}
