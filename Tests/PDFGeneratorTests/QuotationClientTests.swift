import Testing
@testable import QuotationHTML


/// `QuotationClient` 的格式化規則，以及兩個 component 對同一客戶方的不同呈現。
///
/// 這組測試的存在理由：受文者與同意函簽名區**刻意用不同格式**呈現同一份客戶方資料
/// （頓號串接+共N家 vs 逐家換行）。改版時若有人把兩者統一，這裡會紅。
@Suite("QuotationClient")
struct QuotationClientTests {

    // MARK: - 格式化規則

    @Test func singleCompanyInlineTextIsJustTheName() {
        let client = QuotationClient(name: "光泉牧場股份有限公司")
        #expect(client.inlineJoinedText == "光泉牧場股份有限公司")
        #expect(client.displayLines == ["光泉牧場股份有限公司"])
    }

    @Test func groupInlineTextJoinsWithIdeographicCommaAndAppendsCount() {
        let client = QuotationClient(party: .group(names: ["光泉", "味全", "台鳳"]))
        #expect(client.inlineJoinedText == "光泉、味全、台鳳共3家")
    }

    @Test func groupDisplayLinesKeepsEachCompanySeparate() {
        let client = QuotationClient(party: .group(names: ["光泉", "味全", "台鳳"]))
        #expect(client.displayLines == ["光泉", "味全", "台鳳"])
    }

    /// 使用者填了集團合併顯示名稱 → 兩種格式都只用它，且**不附「共N家」**
    /// （自訂名本身即代表整體，再加家數是贅述）。
    @Test func mergedDisplayNameOverridesBothFormats() {
        let client = QuotationClient(party: .group(names: ["光泉", "味全", "台鳳"]), mergedDisplayName: "光泉集團")
        #expect(client.inlineJoinedText == "光泉集團")
        #expect(client.displayLines == ["光泉集團"])
    }

    /// 單一家的 group 仍附「共1家」——是否為集團由呼叫端決定，component 不自行推導。
    @Test func groupWithOneNameStillAppendsCount() {
        let client = QuotationClient(party: .group(names: ["光泉"]))
        #expect(client.inlineJoinedText == "光泉共1家")
    }

    // MARK: - ContractHeader（受文者）

    @Test func contractHeaderRendersGroupWithCountAndBoilerplate() {
        let header = ContractHeader(
            client: .init(party: .group(names: ["光泉", "味全", "台鳳"])),
            sender: "88183980",
            subject: "主旨",
            content: "說明"
        )
        #expect(header.render().contains("<td style=\"font-size: 1rem;\">光泉、味全、台鳳共3家（以下簡稱 貴公司）</td>"))
    }

    @Test func contractHeaderRendersMergedDisplayName() {
        let header = ContractHeader(
            client: .init(party: .group(names: ["光泉", "味全"]), mergedDisplayName: "光泉集團"),
            sender: "88183980",
            subject: "主旨",
            content: "說明"
        )
        #expect(header.render().contains("光泉集團（以下簡稱 貴公司）"))
        #expect(!header.render().contains("共2家"))
    }

    // MARK: - ReplyForm（同意函簽名區）

    @Test func replyFormRendersEachCompanyOnItsOwnLine() {
        let replyForm = ReplyForm(
            client: .init(party: .group(names: ["光泉", "味全", "台鳳"])),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉<br/>味全<br/>台鳳</td>"))
    }

    /// 單一公司不得產生 `<br/>` 或額外包裝——保證既有版面零變化。
    @Test func replyFormSingleCompanyRendersWithoutLineBreak() {
        let replyForm = ReplyForm(
            client: .init(name: "光泉牧場股份有限公司"),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉牧場股份有限公司</td>"))
    }

    @Test func replyFormRendersMergedDisplayNameAsSingleLine() {
        let replyForm = ReplyForm(
            client: .init(party: .group(names: ["光泉", "味全"]), mergedDisplayName: "光泉集團"),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉集團</td>"))
    }
}
