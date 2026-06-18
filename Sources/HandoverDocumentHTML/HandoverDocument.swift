//
//  HandoverDocument.swift
//  PDFGenerator
//
//  客戶訪談紀錄表主組裝器 — 對應 Frontend print-page.component。
//  沿用 Frontend 雙欄 A4 版面：header → focus 重點列 → 雙欄內容。
//  左/右欄各接收一組 section（任意 Component），section 之間自動插入分隔線。
//  conform Plot.Renderable，交給 PDFGenerator → WeasyPrint 產 PDF。
//

import Foundation
// 對外 re-export Plot：消費端 `import HandoverDocumentHTML` 即可取得 Component / Renderable，
// 不必另外宣告 Plot 相依。
@_exported import Plot

public struct HandoverDocument: Renderable {
    let header: DocumentHeader.Model
    let focusItems: [FocusItemBar.FocusItem]
    let leftSections: [any Component]
    let rightSections: [any Component]
    let fontSize: Float

    public init(
        header: DocumentHeader.Model,
        focusItems: [FocusItemBar.FocusItem] = [],
        leftSections: [any Component] = [],
        rightSections: [any Component] = [],
        fontSize: Float = 12
    ) {
        self.header = header
        self.focusItems = focusItems
        self.leftSections = leftSections
        self.rightSections = rightSections
        self.fontSize = fontSize
    }

    public func render(indentedBy indentationKind: Plot.Indentation.Kind?) -> String {
        let fontSizeCSS = fontSize.truncatingRemainder(dividingBy: 1) == 0
            ? String(Int(fontSize))
            : String(fontSize)
        let html = HTML {
            Node<String>.element(named: "style", text: Stylesheet.css)
            Div {
                DocumentHeader(model: header)
                Divider()
                FocusItemBar(items: focusItems)
                Divider()
                // 雙欄用 table（WeasyPrint table-layout 比巢狀 flex 穩）
                Table {
                    TableRow {
                        TableCell {
                            column(leftSections)
                        }.class("info left")
                        TableCell {
                            column(rightSections)
                        }.class("info right")
                    }
                }.class("contentContainer")
            }.class("handover")
        }.node.style("font-family: 華康標楷體,標楷體-繁,標楷體; width: 100%; line-height: 1.5em; font-size: \(fontSizeCSS)px;")
        return html.render(indentedBy: indentationKind)
    }

    /// 把一組 section 依序排入欄位，section 之間插入分隔線。
    private func column(_ sections: [any Component]) -> Component {
        ComponentGroup {
            for (index, section) in sections.enumerated() {
                if index > 0 { Divider() }
                section
            }
        }
    }
}
