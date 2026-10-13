//
//  ServiceScope.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ContractSection: Component {
    let index: Int?
    let title: String
    let heading: String
    let provisions: [ContractProvision]
    /// 條文之後不編號的獨立一段：與條文內文左緣對齊（`（一）` 之後的位置），上方空一行。
    let closing: String?
    
    public var body: any Component{
        ComponentGroup{
            Div{
                Div{
                    if let index {
                        let chineseNumber = index.representToChineseString(offset: 1)
                        Text("\(chineseNumber)、\(title)")
                    }else{
                        Text("\(title)")
                    }
                }.style("font-size: 1.1em; margin-top: 1em;")
                
                Paragraph(heading).style("display: flex; text-indent: 2em;")
                
                for (offset, item) in provisions.enumerated() {
                    Div{
                        Div(Text("（\(offset.representToChineseString(offset: 1))）\(item.term)")).style("display: flex; text-indent: -3em;")
                    }.style("display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;")
                }

                if let closing {
                    Div(Text(closing)).style("padding-left: 5em; margin-top: 1.5em;")
                }
            }.style("break-inside: avoid-page; ")
        }
    }
    
    public init(title: String, heading: String, provisions: [ContractProvision], closing: String? = nil) {
        self.index = nil
        self.title = title
        self.heading = heading
        self.provisions = provisions
        self.closing = closing
    }
    
    internal init(index: Int, title: String, heading: String, provisions: [ContractProvision], closing: String? = nil) {
        self.index = index
        self.title = title
        self.heading = heading
        self.provisions = provisions
        self.closing = closing
    }
    
    func set(index: Int)->Self{
        return .init(index: index, title: title, heading: heading, provisions: provisions, closing: closing)
    }
}


