import Testing
import Foundation
@testable import HandoverDocumentHTML

// 訪談表第 1 頁要壓在一頁內（2026-11-03）：HTML 標出要落在第 1 頁的表單與可縮短的客戶狀況，
// 由 pdf_generator.py 依實際排版結果縮短（約定見 ShrinkableText.swift）。

private func decoded(_ html: String, _ attribute: String) -> String? {
    guard let range = html.range(of: #"\#(attribute)="([^"]*)""#, options: .regularExpression) else { return nil }
    let value = html[range].dropFirst(attribute.count + 2).dropLast()
    return Data(base64Encoded: String(value)).flatMap { String(data: $0, encoding: .utf8) }
}

@Test func classicFormPage1MarksFormAsSinglePageContainer() {
    let html = ClassicFormPage1(model: .init(companyName: "範例股份有限公司")).render()

    #expect(html.contains("data-fit-single-page"))
}

@Test func classicFormPage1MarksShrinkableClientNotesWithBase64Attributes() {
    // 原文含引號與 & —— Plot 不跳脫屬性值，所以要 base64，否則會弄壞 HTML
    let text = "客戶說：\"每月營收\" & 成本\n第二段"
    let html = ClassicFormPage1(model: .init(
        companyName: "範例股份有限公司",
        clientNotesSummary: text,
        clientNotesShrinkable: .init(text: text, suffix: "…(詳見補充頁)", fallback: "詳補充頁")
    )).render()

    #expect(decoded(html, "data-fit-text") == text)
    #expect(decoded(html, "data-fit-suffix") == "…(詳見補充頁)")
    #expect(decoded(html, "data-fit-fallback") == "詳補充頁")
}

@Test func classicFormPage1OmitsShrinkMarkersWhenNotShrinkable() {
    let html = ClassicFormPage1(model: .init(companyName: "範例股份有限公司", clientNotesSummary: "詳補充頁")).render()

    #expect(!html.contains("data-fit-text"))
}

#if canImport(PDFKit)
import PDFKit
import PDFGenerator

// 實際跑 weasyprint 排版（只在本機有 PYTHON_PATH 時跑；CI 是 Linux、沒有 PDFKit）。
private func classicDocument(contactCount: Int, note: String, products: String = "電子零件買賣、進出口貿易") -> ClassicHandoverDocument {
    let contacts = (1...contactCount).map { index in
        ClassicFormPage1.Contact(name: "聯絡人\(index)", relationship: "會計", phone: "(02)2345678\(index)", mobile: "0912-345-67\(index)", email: "c\(index)@example.com")
    }
    let text = String(note.prefix(200))
    return ClassicHandoverDocument(
        page1: .init(
            confirmDate: "115.10.16", companyName: "範例股份有限公司", representative: "王大明", contacts: contacts,
            registeredAddress: "新北市新店區北新路3段207號10樓", communicationAddress: "新北市新店區北新路3段207號10樓",
            products: products, source: "員工介紹（王小明）", sourceDetail: "原本是王小明的大學同學",
            previousFirmServices: "財務簽證、稅務簽證、記帳", previousFirmChangeReason: "退休",
            clientNotesSummary: text + "…(詳見補充頁)",
            clientNotesShrinkable: .init(text: text, suffix: "…(詳見補充頁)", fallback: "詳補充頁"),
            relatedBusinessSummary: "無"
        ),
        page2Sections: [.init(label: "前手", rows: [.field("前所名稱", "-")])]
    )
}

private func generatedPDF(_ document: ClassicHandoverDocument) throws -> PDFDocument {
    let data = try #require(try PDFGenerator(mainHtml: document, headerHtml: document.headerHTML).generate(sideMargin: 1.2, extraVerticalMargin: 12))
    return try #require(PDFDocument(data: data))
}

private let notePhrase = "客戶目前營運穩定，每月營收約三百萬元，主要客戶集中在北部。"
private let longNote = String(repeating: notePhrase, count: 8)
/// 營業項目寫到三行，讓 weasyprint 61（正式機 Docker、CI）與 66（本機）都會擠出第 1 頁、又能靠縮短客戶狀況救回來。
private let longProducts = String(repeating: "電子零件、半導體設備、精密機械零組件之買賣與進出口貿易；", count: 5)

/// PDF 抽出的文字：去掉空白換行，並做相容字正規化（weasyprint 61 的字型對應會抽出相容區的漢字，看起來一樣但比對不到）。
private func normalizedText(_ page: PDFPage?) -> String {
    (page?.string ?? "").precomposedStringWithCompatibilityMapping.filter { !$0.isWhitespace }
}

@Test(.enabled(if: ProcessInfo.processInfo.environment["PYTHON_PATH"] != nil))
func classicPage1ShrinksClientNotesToFitOnePage() throws {
    // 兩位聯絡人、營業項目三行＋200 字客戶狀況會擠出第 1 頁 → 縮短客戶狀況，第 1 頁＋補充頁共兩頁
    let pdf = try generatedPDF(classicDocument(contactCount: 2, note: longNote, products: longProducts))

    #expect(pdf.pageCount == 2)
    let firstPage = normalizedText(pdf.page(at: 0))
    #expect(firstPage.contains("詳見補充頁"))
    #expect(firstPage.contains("開始服務時間"))   // 第 1 頁最後的備註區還在第 1 頁
    // 200 字原文含 7 段（最後一段不完整）；有縮短才會少於 7 段
    #expect(firstPage.components(separatedBy: "客戶目前營運穩定").count - 1 < 7)
}

@Test(.enabled(if: ProcessInfo.processInfo.environment["PYTHON_PATH"] != nil))
func classicPage1KeepsOriginalWhenEvenFallbackDoesNotFit() throws {
    // 聯絡人多到客戶狀況縮成「詳補充頁」也放不下 → 維持原內容、接受第 1 頁超過一頁
    let pdf = try generatedPDF(classicDocument(contactCount: 6, note: longNote, products: longProducts))

    #expect(pdf.pageCount == 3)
}
#endif
