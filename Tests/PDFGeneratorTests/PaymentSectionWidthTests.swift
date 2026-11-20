import Foundation
import Testing
@testable import QuotationHTML

/// 報價單「酬金」段的寬度。
///
/// 外層表格（編號欄 + 酬金欄）若不指定寬度，會依內容收縮：只有夠長的補充說明或註記能把它撐到滿版；
/// 沒有備註、或備註很短時，酬金表就縮成一小塊。這裡鎖住「不靠備註撐開也要滿版」。
@Suite("酬金段寬度")
struct PaymentSectionWidthTests {

    @Test("沒有備註或備註很短時，酬金段仍為滿版", arguments: [
        [String](),
        ["短註"],
    ])
    func paymentSectionIsFullWidthRegardlessOfNotes(notes: [String]) throws {
        let quotation = AuditQuotation(
            no: nil,
            receiver: "甲公司",
            replyFormReceiver: "甲公司",
            sender: .jw,
            purpose: nil,
            payments: [.init(name: "代辦", items: [.init(names: ["代辦公司清算流程"], fee: "160,000 元/次")], needShowName: true)],
            serviceScope: .init(title: "服務範圍", heading: "", items: []),
            letterHeader: .init(to: "", from: "", content: "", date: Date(timeIntervalSince1970: 0), blessings: ""),
            assistance: nil,
            notes: notes.map { .init(content: $0) },
            replyForm: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true),
            contractHeader: .init(subject: "主旨", content: "說明")
        )
        let html = quotation.render()

        // 酬金段的編號（本例只有「服務範圍」一節在前，故為「二、」）是定位外層表格的錨點。
        let anchor = try #require(html.range(of: "二、</p>"))
        let before = html[..<anchor.lowerBound]

        // 外層表格滿版；編號欄收到最窄、剩餘寬度全給酬金欄。
        // 只比對宣告是否存在，不鎖宣告順序或其他樣式（例如分頁規則），避免無關改動讓這條誤紅。
        let tableStyle = try #require(styleDeclarations(ofLast: "<table", in: before))
        #expect(tableStyle.contains("width: 100%"))
        let numberCellStyle = try #require(styleDeclarations(ofLast: "<td", in: before))
        #expect(numberCellStyle.contains("width: 1%"))
        #expect(numberCellStyle.contains("white-space: nowrap"))
    }

    /// 酬金表每一列是「編號｜項目名稱｜金額」三格，只有編號格有寬度。名稱格與金額格都不指定時，
    /// 正式環境的 WeasyPrint（Ubuntu 24.04 套件，61.x）把剩餘寬度約對半分：金額格佔半張表，
    /// 名稱稍長就被擠到換行（例：「稅務申報服務(116年1月開始)(無營」／「收)」）。
    /// 金額格收到最窄（`width: 1%` ＋ 不換行），剩餘寬度全給名稱格。
    @Test("酬金項目的金額格收到最窄，寬度留給項目名稱")
    func feeCellShrinksToContent() throws {
        let fee = "1,500 元/月"
        let html = PaymentItem(names: ["稅務申報服務(116年1月開始)(無營收)"], fee: fee).render()

        let feeStart = try #require(html.range(of: fee))
        let feeCellStyle = try #require(styleDeclarations(ofLast: "<td", in: html[..<feeStart.lowerBound]))
        #expect(feeCellStyle.contains("width: 1%"))
        #expect(feeCellStyle.contains("white-space: nowrap"))
    }

    /// 取 `text` 中最後一個 `tagPrefix` 開頭標籤的 style 宣告（以 `;` 切開、去頭尾空白）。
    /// 找不到標籤回 `nil`；標籤沒有 style 屬性回空集合。
    private func styleDeclarations(ofLast tagPrefix: String, in text: Substring) -> Set<String>? {
        guard let tagStart = text.range(of: tagPrefix, options: .backwards),
              let tagEnd = text[tagStart.upperBound...].firstIndex(of: ">") else { return nil }
        let tag = text[tagStart.lowerBound..<tagEnd]
        guard let styleStart = tag.range(of: "style=\""),
              let styleEnd = tag[styleStart.upperBound...].firstIndex(of: "\"") else { return [] }
        return Set(
            tag[styleStart.upperBound..<styleEnd]
                .split(separator: ";")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
        )
    }
}
