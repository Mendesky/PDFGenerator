//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/4/23.
//
import Plot

public struct Payment: Component {
    public let name: String
    public let items: [PaymentItem]
    public let needShowName: Bool
    
    public var body: any Component{
        ComponentGroup{
            if needShowName {
                TableRow{
                    TableCell{
                        Text(name).bold().style("font-size: 1.1em;")
                    }.attribute(named: "colspan", value: "3")
                }
            }
            for (index, item) in items.enumerated(){
                TableRow{
                    TableCell("(\(index+1))").style("align-items: top; width: 1rem;")
                    item
                }.style("padding-bottom: 0.5em; width: 100%; padding-top: 0.5em;")
            }
        }
    }
    
    public init(name: String, items: [PaymentItem], needShowName: Bool = true) {
        self.name = name
        self.items = items
        self.needShowName = needShowName
    }
    
    package func hideName() -> Self {
        .init(name: name, items: items, needShowName: false)
    }
}
