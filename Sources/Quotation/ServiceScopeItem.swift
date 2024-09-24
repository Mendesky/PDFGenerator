//
//  ServiceScopeItem 2.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct ServiceScopeItem: Component {
    let title: String
    let content: String
    let terms: [ServiceScopeItemTerm]?
    
    public var body: any Component{
        ComponentGroup{
            Paragraph(title)
            Paragraph(content)
            if let terms {
                List{
                    for term in terms {
                        term
                    }
                }.environmentValue(HTMLListStyle.ordered, key: .listStyle)
            }
        }
    }
    
    public init(title: String, content: String, terms: [ServiceScopeItemTerm]?) {
        self.title = title
        self.content = content
        self.terms = terms
    }
    
    public init(title: String, content: String, termStrings: [String]?) {
        self.init(title: title, content: content, terms: termStrings?.map{ ServiceScopeItemTerm(term: $0)})
    }
}
