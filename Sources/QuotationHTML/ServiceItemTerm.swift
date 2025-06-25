//
//  ServiceScopeItemTerm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct ServiceItemTerm: Component {
    let term: String
    
    public var body: any Component{
        ComponentGroup{
            ListItem{
                for line in term.split(separator: "\n"){
                    Text(String(line)).addLineBreak()
                }
            }.style("text-indent: -1.5em;")
        }
    }
    
    public init(term: String) {
        self.term = term
    }
}
