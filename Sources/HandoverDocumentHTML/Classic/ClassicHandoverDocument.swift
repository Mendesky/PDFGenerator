//
//  ClassicHandoverDocument.swift
//  PDFGenerator
//
//  舊版風格訪談紀錄表（框線表單）。策略：
//  - 第 1 頁：復刻舊版單頁表單（ClassicFormPage1）
//  - 第 2 頁起：補充資訊，仿第 1 頁框線表格呈現（ClassicFormPage2）
//  與現有 HandoverDocument（雙欄卡片版）並存，不互相取代。
//

import Foundation
@_exported import Plot

public struct ClassicHandoverDocument: Renderable {
    let page1: ClassicFormPage1.Model
    let page2Sections: [ClassicFormPage2.Section]
    let externalURL: String?
    let internalURL: String?
    let fontSize: Float

    public init(
        page1: ClassicFormPage1.Model,
        page2Sections: [ClassicFormPage2.Section] = [],
        externalURL: String? = nil,
        internalURL: String? = nil,
        fontSize: Float = 14
    ) {
        self.page1 = page1
        self.page2Sections = page2Sections
        self.externalURL = externalURL
        self.internalURL = internalURL
        self.fontSize = fontSize
    }

    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        let fontSizeCSS = fontSize.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(fontSize))
            : String(fontSize)
        let html = HTML {
            Node<String>.element(named: "style", text: ClassicStylesheet.css)
            Div {
                ClassicFormPage1(model: page1)
                if !page2Sections.isEmpty {
                    Div().style("break-before: page;")
                    ClassicFormPage2(sections: page2Sections, externalURL: externalURL, internalURL: internalURL)
                }
            }.class("classic")
        }.node.style("font-family: 華康標楷體,標楷體-繁,標楷體; width: 100%; line-height: 1.5em; font-size: \(fontSizeCSS)px;")
        return html.render(indentedBy: indentationKind)
    }

    /// 每頁固定置頂的事務所 logo header（交給 PDFGenerator 的 headerHtml 參數）。
    public var headerHTML: Component {
        LogoHeader(sideMarginCM: 1.2)
    }
}
