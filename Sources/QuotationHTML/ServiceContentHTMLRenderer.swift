//
//  ServiceContentHTMLRenderer.swift
//  PDFGenerator
//
//  把服務範圍裡「服務內容」（自訂服務項目的自由文字）的 markdown 渲染成 PDF 用 HTML。
//

import Foundation
import Markdown

/// 服務內容（`QuotingServiceTerm.term`）的 markdown → HTML。
///
/// **為什麼不直接用 `SupplementaryNoteHTMLRenderer`**（酬金補充說明那支）：
/// 1. 它的 scoped class 是 `.rich-supplementaryNote`，用在服務範圍語意錯位；
/// 2. 它只把 `ul`/`ol` 的 `margin` 歸零、**沒有設 `padding-left`** —— 服務內容外層已有
///    `padding-left: 3em` + `text-indent: 2em`，再吃 weasyprint 的清單預設縮排（約 40px）會歪掉；
/// 3. **escape 行為必須相反**：那支刻意讓 raw HTML 透出（有測試明文鎖住，因為補充說明會嵌
///    `<img data:...>`）；服務內容是使用者自由輸入、會印進報價單，不該能注入標記。
///
/// 渲染規則：
/// - **以 sentinel 繞過 CommonMark 的 entity 解碼再轉實體**：`swift-markdown` 的
///   `HTMLFormatter.visitText` 不做 escape（與 Plot 的 `text.escaped()` 相反），所以使用者打的
///   `<script>` 會原樣進 HTML。但**不能先轉成 `&lt;` 再 parse** —— entity reference 是 CommonMark
///   的合法語法，parser 會把 `&lt;` 解碼回 `<`，escape 等於白做（實測如此）。故先把三個字元換成
///   Unicode 私用區 sentinel（對 markdown 而言就是普通文字），渲染完再換成實體；formatter 自己
///   產生的標籤不含 sentinel，因此不受影響。markdown 語法字元（`-`、`*`、`#`）全程不動。
/// - **soft break → `<br>`**：段落內單一 `\n` 轉硬換行。原本的 `Div(term)` 完全不處理 `\n`，
///   多行服務內容在 PDF 會連成一行；這裡一併修掉。
/// - **scoped `<style>`**：`.rich-serviceContent` scope，清單縮排明確指定、不吃 weasyprint 預設。
///   `list-style-position: inside` + `padding-left: 0`：標記排在文字流內，左緣與其他段落對齊。
///   用 `outside` + padding 會讓圓點凸出外層容器（外層已有 `padding-left: 3em` / `text-indent: 2em`），
///   前端實測就是這個症狀，兩端必須採同一個決定，否則畫面對齊、印出來不對齊。
enum ServiceContentHTMLRenderer {

    static func render(markdown: String) -> String {
        let document = Document(parsing: shieldHTMLCharacters(markdown))
        var rewriter = ServiceContentSoftBreakRewriter()
        let rewritten = rewriter.visit(document) ?? document
        let body = unshieldToEntities(HTMLFormatter.format(rewritten))
        return scopedStyleBlock + "<div class=\"rich-serviceContent\">\(body)</div>"
    }

    // Unicode 私用區（U+E000–U+F8FF）：不會出現在正常輸入，markdown 視為普通文字。
    private static let ampShield = "\u{E000}"
    private static let ltShield = "\u{E001}"
    private static let gtShield = "\u{E002}"

    /// parse 前：把 HTML 特殊字元換成 sentinel，避開 CommonMark 的 entity 解碼。
    static func shieldHTMLCharacters(_ raw: String) -> String {
        raw
            .replacingOccurrences(of: "&", with: ampShield)
            .replacingOccurrences(of: "<", with: ltShield)
            .replacingOccurrences(of: ">", with: gtShield)
    }

    /// 渲染後：sentinel → HTML 實體。此時 formatter 產生的標籤已就位，不會被誤傷。
    static func unshieldToEntities(_ html: String) -> String {
        html
            .replacingOccurrences(of: ampShield, with: "&amp;")
            .replacingOccurrences(of: ltShield, with: "&lt;")
            .replacingOccurrences(of: gtShield, with: "&gt;")
    }

    /// 服務內容嵌在既有 `padding-left: 3em` / `text-indent: 2em` 的容器內：
    /// block margin 歸零避免多餘上下留白，清單自帶縮排（不吃 weasyprint 預設的 40px），
    /// 且 `text-indent: 0` 讓 `<li>` 不被外層的首行縮排推歪。
    static let scopedStyleBlock: String = """
    <style>
    .rich-serviceContent p,
    .rich-serviceContent ul,
    .rich-serviceContent ol { margin: 0; }
    /* 多段落／段落與清單之間要有呼吸空間；單段落時不受影響（相鄰選擇器） */
    .rich-serviceContent p + p,
    .rich-serviceContent p + ul,
    .rich-serviceContent p + ol,
    .rich-serviceContent ul + p,
    .rich-serviceContent ol + p { margin-top: 0.5em; }
    .rich-serviceContent ul,
    .rich-serviceContent ol { list-style-position: inside; padding-left: 0; text-indent: 0; }
    .rich-serviceContent li { text-indent: 0; }
    </style>
    """
}

/// 段落內單一 `\n`（SoftBreak）→ `LineBreak`（`<br />`）。`\n\n` 是段落邊界、不受影響。
private struct ServiceContentSoftBreakRewriter: MarkupRewriter {
    mutating func visitSoftBreak(_ softBreak: SoftBreak) -> Markup? {
        LineBreak()
    }
}
