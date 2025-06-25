//
//  ServiceScopeItem 2.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Plot

public struct QuotingServiceTerm {
    let title: String
    let term: String?
    let serviceItemTerms: [ServiceItemTerm]?
    
    public init(title: String, term: String?, serviceItemTerms: [ServiceItemTerm]?) {
        self.title = title
        self.term = term
        self.serviceItemTerms = serviceItemTerms
    }
    
    public init(title: String, term: String?, termStrings: [String]) {
        self.init(title: title, term: term, serviceItemTerms: termStrings.map{ ServiceItemTerm(term: $0)})
    }
}
