import Foundation
import Testing
@testable import QuotationHTML

/// 報價單「酬金」段的寬度。
///
/// 外層表格（編號欄 + 酬金欄）若不指定寬度，會依內容收縮：有長的補充說明或註記時剛好滿版，
/// 沒有時酬金表就縮成一小塊。這裡鎖住「沒有任何備註」的情況也要滿版。
@Suite("酬金段寬度")
struct PaymentSectionWidthTests {

    @Test("沒有補充說明與註記時，酬金段仍為滿版")
    func paymentSectionIsFullWidthWithoutNotes() {
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
            notes: [],
            replyForm: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true),
            contractHeader: .init(subject: "主旨", content: "說明")
        )
        let html = quotation.render()
        // 外層表格滿版，編號欄收到最窄、剩餘寬度全給酬金欄。
        #expect(html.contains("<table style=\"width: 100%;\"><tr style=\"break-inside: avoid-page;\"><td style=\"vertical-align: top; width: 1%; white-space: nowrap;\">"))
    }
}
