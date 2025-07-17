//
//  ServiceScope.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot



func toChineseNumber(index: Int)->String{
    switch index + 1{
    case 1: return "一"
    case 2: return "二"
    case 3: return "三"
    case 4: return "四"
    case 5: return "五"
    case 6: return "六"
    case 7: return "七"
    case 8: return "八"
    case 9: return "九"
    case 10: return "十"
    default:
        return ""
    }
    
}

public struct ServiceScope: Component {
    let index: Int?
    let title: String
    let heading: String
    let items: [QuotingServiceTerm]?
    
    public var body: any Component{
        ComponentGroup{
            Div{
                if let index {
                    let chineseNumber = toChineseNumber(index: index)
                    TableRow(TableCell("\(chineseNumber)、\(title)")).style("font-size: 1.1em;")
                }else{
                    TableRow(TableCell("\(title)")).style("font-size: 1.1em;")
                }
                Paragraph(heading).style("text-indent: 2em;")
            }.style("break-inside: avoid-page;")
            
            if let items{
                
                for (offset, item) in items.enumerated() {
                    Div{
                        Div(Text("（\(toChineseNumber(index: offset))）\(item.title)")).style("display: flex; text-indent: 2em; padding-bottom: 1em;")
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
        self.index = nil
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
    
    func set(index: Int)->Self{
        return .init(index: index, title: title, heading: heading, items: items)
    }
}
