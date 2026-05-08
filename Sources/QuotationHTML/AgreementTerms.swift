//
//  AgreementTerms.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2026/5/8.
//

public struct AgreementTerms {

}

extension AgreementTerms {
    public struct Model {
        let title: String
        let heading: String
        let terms: [String]

        public init(title: String, heading: String, terms: [String]) {
            self.title = title
            self.heading = heading
            self.terms = terms
        }
    }
}
