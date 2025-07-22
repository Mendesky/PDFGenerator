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
    let serviceItemTerms: [ContractProvision]?
    
    public init(title: String, term: String?, serviceItemTerms: [ContractProvision]?) {
        self.title = title
        self.term = term
        self.serviceItemTerms = serviceItemTerms
    }
    
    public init(title: String, term: String?, termStrings: [String]) {
        self.init(title: title, term: term, serviceItemTerms: termStrings.map{ ContractProvision(term: $0)})
    }
    
    public init(model: Model) {
        self.init(title: model.title, term: model.term, serviceItemTerms: model.serviceItemTerms.map{
            $0.map{
                ContractProvision(term: $0.content)}
        })
            
    }
}


extension QuotingServiceTerm {
    public struct Model {
        let title: String
        let term: String?
        let serviceItemTerms: [ServiceItemTerm.Model]?
        
        public init(title: String, term: String?, serviceItemTerms: [ServiceItemTerm.Model]?) {
            self.title = title
            self.term = term
            self.serviceItemTerms = serviceItemTerms
        }
    }
}
