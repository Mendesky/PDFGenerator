//
//  QuotationContentItem.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ContentItem: Component{
    let title: String
    let content: String
    
    public init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    public var body: any Component {
        ComponentGroup{
            Table{
                TableRow{
                    TableCell(title)
                }
                TableRow{
                    TableCell(content)
                }
            }
        }
    }
}
