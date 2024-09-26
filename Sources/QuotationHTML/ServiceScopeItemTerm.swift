//
//  ServiceScopeItemTerm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct ServiceScopeItemTerm: Component {
    let term: String
    
    public var body: any Component{
        ComponentGroup{
            ListItem(term)
        }
    }
    
    public init(term: String) {
        self.term = term
    }
}
