//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct Payment: Component {
    let title: String
    let items: [PaymentItem]
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(title)
            Table{
                TableRow{
                    TableCell()
                    TableCell("服務項目")
                    TableCell("公費金額")
                    TableCell()
                }.style("border-bottom: 1pt solid black;")
                
                for (index, item) in items.enumerated(){
                    TableRow{
                        TableCell("(\(index+1))")
                        item
                    }
                }
                
            }.style("border-collapse: collapse; font-size: 12px; width: 100%;")
        }
    }
    
    public init(title: String, items: [PaymentItem]) {
        self.title = title
        self.items = items
    }
}
