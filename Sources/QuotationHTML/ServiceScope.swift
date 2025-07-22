//
//  ServiceScope.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ServiceScope: Component {
    let index: Int
    let title: String
    let heading: String
    let items: [QuotingServiceTerm]?
    
    public var body: any Component{
        ComponentGroup{
            Div{
                let chineseNumber = index.representToChineseString(offset: 1)
                TableRow(TableCell("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                Paragraph(heading).style("text-indent: 2em;")
            }.style("break-inside: avoid-page;")
            
            if let items{
                
                for (offset, item) in items.enumerated() {
                    Div{
                        Div(Text("（\(offset.representToChineseString(offset: 1))）\(item.title)")).style("display: flex; text-indent: 2em; padding-bottom: 1em;")
                        Div{
                            if let term = item.term{
                                Div(term).style("display: flex; text-indent: 2em;")
                            }
                        }.style("display: flex; flex-direction: column; padding-left: 5em;")
                        if let serviceItemTerms = item.serviceItemTerms{
                            Div{
                                List{
                                    for serviceItemTerm in serviceItemTerms {
                                        ListItem{
                                            for line in serviceItemTerm.term.split(separator: "\n"){
                                                Text(String(line)).addLineBreak()
                                            }
                                        }
                                    }
                                }.environmentValue(.ordered, key: .listStyle)
                            }.style("display: flex; padding-left: 3.8em;")
                        }
                    }.style("display: flex; flex-direction: column;  break-inside: avoid-page; ")
                }
            }
        }
    }
    
    public init(title: String, heading: String, items: [QuotingServiceTerm]?) {
        self.index = -1
        self.title = title
        self.heading = heading
        self.items = items
    }
    
    private init(index: Int, title: String, heading: String, items: [QuotingServiceTerm]?) {
        self.index = index
        self.title = title
        self.heading = heading
        self.items = items
    }
    
    internal init(index: Int, title: String, heading: String, items: [QuotingServiceTerm.Model]?) {
        self.index = index
        self.title = title
        self.heading = heading
        self.items = items.map{
            .init($0)
        }
    }
    
    private init(index: Int, model: Model) {
        self.index = index
        self.title = model.title
        self.heading = model.heading
        self.items = model.items.map{
            $0.map{
                .init(model: $0)
            }
        }
    }
    
}


extension ServiceScope {
    public struct Model {
        let title: String
        let heading: String
        let items: [QuotingServiceTerm.Model]?
        
        public init(title: String, heading: String, items: [QuotingServiceTerm.Model]?) {
            self.title = title
            self.heading = heading
            self.items = items
        }
        
        
    }
}
