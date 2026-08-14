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
        let client = QuotationClient.single(name: "光泉牧場股份有限公司")
        #expect(client.inlineJoinedText == "光泉牧場股份有限公司")
        #expect(client.displayLines == ["光泉牧場股份有限公司"])
    }

    @Test func groupInlineTextJoinsWithIdeographicCommaAndAppendsCount() {
        let client = QuotationClient.group(names: ["光泉", "味全", "台鳳"], mergedDisplayName: nil)
        #expect(client.inlineJoinedText == "光泉、味全、台鳳共3家")
    }

    @Test func groupDisplayLinesKeepsEachCompanySeparate() {
        let client = QuotationClient.group(names: ["光泉", "味全", "台鳳"], mergedDisplayName: nil)
        #expect(client.displayLines == ["光泉", "味全", "台鳳"])
    }

    /// 使用者填了集團合併顯示名稱 → 兩種格式都只用它，且**不附「共N家」**
    /// （自訂名本身即代表整體，再加家數是贅述）。
    @Test func mergedDisplayNameOverridesBothFormats() {
        let client = QuotationClient.group(names: ["光泉", "味全", "台鳳"], mergedDisplayName: "光泉集團")
        #expect(client.inlineJoinedText == "光泉集團")
        #expect(client.displayLines == ["光泉集團"])
    }

    /// 單一家的 group 仍附「共1家」——是否為集團由呼叫端決定，component 不自行推導。
    @Test func groupWithOneNameStillAppendsCount() {
        let client = QuotationClient.group(names: ["光泉"], mergedDisplayName: nil)
        #expect(client.inlineJoinedText == "光泉共1家")
    }

    // MARK: - ContractHeader（受文者）

    @Test func contractHeaderRendersGroupWithCountAndBoilerplate() {
        let header = ContractHeader(
            client: .group(names: ["光泉", "味全", "台鳳"], mergedDisplayName: nil),
            sender: "88183980",
            subject: "主旨",
            content: "說明"
        )
        #expect(header.render().contains("<td style=\"font-size: 1rem;\">光泉、味全、台鳳共3家（以下簡稱 貴公司）</td>"))
    }

    @Test func contractHeaderRendersMergedDisplayName() {
        let header = ContractHeader(
            client: .group(names: ["光泉", "味全"], mergedDisplayName: "光泉集團"),
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
            client: .group(names: ["光泉", "味全", "台鳳"], mergedDisplayName: nil),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉<br/>味全<br/>台鳳</td>"))
    }

    /// 單一公司不得產生 `<br/>` 或額外包裝——保證既有版面零變化。
    @Test func replyFormSingleCompanyRendersWithoutLineBreak() {
        let replyForm = ReplyForm(
            client: .single(name: "光泉牧場股份有限公司"),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉牧場股份有限公司</td>"))
    }

    @Test func replyFormRendersMergedDisplayNameAsSingleLine() {
        let replyForm = ReplyForm(
            client: .group(names: ["光泉", "味全"], mergedDisplayName: "光泉集團"),
            sender: .jw,
            quotationNo: "111112101",
            model: .init(subject: "主旨", payments: [], additionalServices: [], showCompanyStamp: true)
        )
        #expect(replyForm.render().contains("<td>光泉集團</td>"))
    }
}

/// 型別層面的保證：`mergedDisplayName` 住在 `.group` 內，所以
/// 「單一公司卻帶集團名」這個矛盾狀態**寫不出來**（改版前它可被表達，且會真的印出集團名）。
///
/// 這組測試不是驗行為，是把設計意圖釘住：若日後有人把 `mergedDisplayName` 搬回頂層，
/// 下面這行會編不過（`.single` 沒有第二個 associated value），改動者就會被迫面對這個決策。
@Suite("QuotationClient — 非法狀態不可表達")
struct QuotationClientIllegalStateTests {

    @Test func singleCompanyCannotCarryMergedDisplayName() {
        let client = QuotationClient.single(name: "光泉牧場股份有限公司")
        // .single 只有 name；沒有任何管道讓它帶集團名
        #expect(client.inlineJoinedText == "光泉牧場股份有限公司")
        #expect(client.displayLines == ["光泉牧場股份有限公司"])
    }

    /// ⚠️ 空 `names` 仍可被表達（enum case 無法帶 invariant）——記錄目前的實際行為，
    /// 讓呼叫端知道沒擋的後果。OC 的 `resolveClientParty` 以 guard 擋掉。
    @Test func emptyGroupDegradesToZeroCountWhichCallersMustPrevent() {
        let client = QuotationClient.group(names: [], mergedDisplayName: nil)
        #expect(client.inlineJoinedText == "共0家")
        #expect(client.displayLines.isEmpty)
    }
}
