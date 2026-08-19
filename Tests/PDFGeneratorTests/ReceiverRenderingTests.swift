import Foundation
import Testing
@testable import QuotationHTML


/// 受文者與同意函簽名區的**版面**行為。
///
/// 本 package 不含任何組字規則 —— 兩個欄位都收「呼叫端已組好的字串」。
/// 「怎麼把多家公司組成文字」（頓號／換行／共N家／自訂集團名優先）是 OC 的業務規則，
/// 測試在 OC 的 `ConglomerateCompanyNamesTests` 與接縫測試。
///
/// 這裡只驗兩件事：公文樣板有沒有正確附加、`\n` 有沒有正確切成多行。
@Suite("受文者 / 簽名區的版面渲染")
struct ReceiverRenderingTests {

    @Test("受文者原樣印出並附上公文樣板")
    func contractHeaderAppendsBoilerplate() {
        let header = ContractHeader(receiver: "光泉、味全、台鳳共3家", sender: "88183980", subject: "主旨", content: "說明")
        #expect(header.render().contains("<td style=\"font-size: 1rem;\">光泉、味全、台鳳共3家（以下簡稱 貴公司）</td>"))
    }

    /// 受文者是單行欄位：即使字串含 `\n` 也不切行（切行是簽名區的事）。
    @Test("受文者不切行")
    func contractHeaderDoesNotSplitLines() {
        let header = ContractHeader(receiver: "甲\n乙", sender: "88183980", subject: "主旨", content: "說明")
        #expect(!header.render().contains("<br/>甲"))
    }

    @Test("簽名區以 \\n 切成多行，用 br 分隔")
    func replyFormSplitsOnNewline() {
        let replyForm = ReplyForm(
            receiver: "甲\n乙\n丙",
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>甲<br/>乙<br/>丙</td>"))
    }

    /// 單一行不得產生 `<br/>` 或額外包裝 —— 保證既有單一公司報價單的版面零變化。
    @Test("單一行不產生 br（既有版面不變）")
    func replyFormSingleLineHasNoLineBreak() {
        let replyForm = ReplyForm(
            receiver: "光泉牧場股份有限公司",
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉牧場股份有限公司</td>"))
    }

    /// 兩處刻意可以是不同內容（受文者附家數、簽名區不附）。
    @Test("受文者與簽名區各自獨立")
    func receiverAndReplyFormReceiverAreIndependent() {
        let quotation = AuditQuotation(
            no: nil,
            receiver: "甲、乙共2家",
            replyFormReceiver: "甲\n乙",
            sender: .jw,
            purpose: nil,
            payments: [],
            serviceScope: .init(title: "", heading: "", items: []),
            letterHeader: .init(to: "", from: "", content: "", date: Date(timeIntervalSince1970: 0), blessings: ""),
            assistance: nil,
            notes: [],
            replyForm: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true),
            contractHeader: .init(subject: "主旨", content: "說明")
        )
        let html = quotation.render()
        #expect(html.contains("甲、乙共2家（以下簡稱 貴公司）"))
        #expect(html.contains("<td>甲<br/>乙</td>"))
    }
}
