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
    let title: String
    let heading: String
    let items: [QuotingServiceTerm]?
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(heading).style("text-indent: 2em;")
            if let items{
                List{
                    for item in items {
                        ListItem(item)                        
                    }
                }.environmentValue(.ordered, key: .listStyle)
            }
            
        }
    }
    
    public init(title: String, heading: String, items: [QuotingServiceTerm]?) {
        self.title = title
        self.heading = heading
        self.items = items
    }
}
