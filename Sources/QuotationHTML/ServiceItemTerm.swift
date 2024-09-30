//
//  ServiceScopeItemTerm.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//

import Plot

public struct ServiceItemTerm: Component {
    let term: String?
    
    public var body: any Component{
        ComponentGroup{
            if let term {
                ListItem(term)
            }
        }
    }
    
    public init(term: String?) {
        self.term = term
    }
}
