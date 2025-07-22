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
                }.style("dislpay: flex; font-size: 1.1em;")
                
                Paragraph(heading).style("display: flex; text-indent: 2em;")
                
                for (offset, item) in provisions.enumerated() {
                    Div{
                        Div(Text("（\(offset.representToChineseString(offset: 1))）\(item.term)")).style("display: flex; text-indent: -3em;")
                    }.style("display: flex; flex-direction: column; padding-left: 5em;")
                }
            }.style("break-inside: avoid-page; ")
        }
    }
    
    public init(title: String, heading: String, provisions: [ContractProvision]) {
        self.index = nil
        self.title = title
        self.heading = heading
        self.provisions = provisions
    }
    
    internal init(index: Int, title: String, heading: String, provisions: [ContractProvision]) {
        self.index = index
        self.title = title
        self.heading = heading
        self.provisions = provisions
    }
    
    func set(index: Int)->Self{
        return .init(index: index, title: title, heading: heading, provisions: provisions)
    }
}


