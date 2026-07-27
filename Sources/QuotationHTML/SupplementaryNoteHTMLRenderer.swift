//
//  SupplementaryNoteHTMLRenderer.swift
//  PDFGenerator
//
//  把酬金補充說明的 markdown 渲染成 PDF 用 HTML — presentation 歸 PDFGenerator。
//

import Foundation
import Markdown

/// 把補充說明 markdown 轉成 HTML 字串（含 scoped style）。
///
/// **職責邊界**：caller（OC）只負責「領域 / 安全」前處理 —— template variable 替換成實際值、
/// 內嵌圖片 fetch + ownership 驗證後 inline 成 `<img data:...>`。markdown → HTML 的渲染與所有
/// 版面樣式（換行規則、表格框線、圖片縮放、block 間距）都在這裡，屬 PDFGenerator 的 presentation。
///
/// 渲染規則：
/// - **soft break → `<br>`**：段落內單一 `\n` 轉硬換行，讓「多句各佔一行」確實換行；`\n\n` 仍是段落。
/// - **scoped `<style>`**：`.rich-supplementaryNote` class scope，不污染 PDF 其他 section。
///   表格補框線（weasyprint 預設無框）、圖片限寬避免爆版、block element（`<p>`/`<h*>`/`<ul>`/`<ol>`）
///   margin 歸零讓標題與一般段落行距一致。
enum SupplementaryNoteHTMLRenderer {

    static func render(markdown: String) -> String {
        let document = Document(parsing: markdown)
        var rewriter = SoftBreakToLineBreakRewriter()
        let rewritten = rewriter.visit(document) ?? document
        let body = HTMLFormatter.format(rewritten)
        return scopedStyleBlock + "<div class=\"rich-supplementaryNote\">\(body)</div>"
    }

    static let scopedStyleBlock: String = """
    <style>
    .rich-supplementaryNote table { border-collapse: collapse; }
    .rich-supplementaryNote table td,
    .rich-supplementaryNote table th { border: 1px solid #999; padding: 0.15em 0.5em; }
    .rich-supplementaryNote img { max-width: 200px; height: auto; }
    .rich-supplementaryNote p,
    .rich-supplementaryNote h1, .rich-supplementaryNote h2, .rich-supplementaryNote h3,
    .rich-supplementaryNote h4, .rich-supplementaryNote h5, .rich-supplementaryNote h6,
    .rich-supplementaryNote ul, .rich-supplementaryNote ol { margin: 0; }
    </style>
    """
}

/// 把 markdown AST 的 `SoftBreak`（段落內單一 `\n`）改寫成 `LineBreak`（HTML `<br>`）。
/// `\n\n`（段落分隔）是 paragraph boundary、不是 SoftBreak node，不受影響。
private struct SoftBreakToLineBreakRewriter: MarkupRewriter {
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Markup? {
        LineBreak()
    }
}
