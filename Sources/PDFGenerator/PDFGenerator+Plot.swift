//
//  PDFGenerator+Plot.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/24.
//
import Foundation
import Plot

@available(macOS 10.15, *)
extension PDFGenerator {
    public convenience init(mainHtml: Renderable, headerHtml: Renderable? = nil, footerHtml: Renderable? = nil, baseUrl: String? = nil, stylesheets: [String] = []){
        self.init(
            mainHtml: mainHtml.render(),
            headerHtml: headerHtml?.render(),
            footerHtml: footerHtml?.render(),
            stylesheets: stylesheets,
            baseUrl: baseUrl
        )
    }
}
