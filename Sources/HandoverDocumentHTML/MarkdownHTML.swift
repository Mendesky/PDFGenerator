//
//  MarkdownHTML.swift
//  PDFGenerator
//
//  訪談紀錄等欄位的 markdown → HTML 渲染。做法對齊 QuotationHTML 的
//  SupplementaryNoteHTMLRenderer：用 swift-markdown 內建的 HTMLFormatter，
//  並把段落內單一 `\n`（SoftBreak）改寫成 `<br>`（LineBreak），讓「多句各佔一行」確實換行。
//

import Foundation
import Markdown

enum MarkdownHTML {
    static func render(_ markdown: String) -> String {
        let document = Document(parsing: markdown)
        var rewriter = SoftBreakToLineBreakRewriter()
        let rewritten = rewriter.visit(document) ?? document
        return HTMLFormatter.format(rewritten)
    }
}

/// 段落內單一 `\n`（SoftBreak）→ `LineBreak`（HTML `<br>`）；`\n\n`（段落分隔）不受影響。
private struct SoftBreakToLineBreakRewriter: MarkupRewriter {
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Markup? {
        LineBreak()
    }
}
