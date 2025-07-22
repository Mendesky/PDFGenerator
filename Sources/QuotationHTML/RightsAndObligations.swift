//
//  RightsAndObligations.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

public struct RightsAndObligation {
    
}

extension RightsAndObligation {
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
