//
//  Purpose.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/7/22.
//

public struct Purpose {
    
}


extension Purpose {
    public struct Model {
        let title: String
        let content: String
        
        public init(title: String, content: String) {
            self.title = title
            self.content = content
        }
    }
}
