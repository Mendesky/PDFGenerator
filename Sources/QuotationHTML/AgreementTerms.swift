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
        /// 條文之後不編號的獨立一段（例：準據法聲明）。nil ＝ 沒有。
        let closing: String?

        public init(title: String, heading: String, terms: [String], closing: String? = nil) {
            self.title = title
            self.heading = heading
            self.terms = terms
            self.closing = closing
        }
    }
}
