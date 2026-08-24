import Testing
import Plot
import Foundation
@testable import QuotationHTML

@Test func createLetterHTML() {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let to = "Jane Doe"
    let from = "88183980"
    let content = "This is a testing content."
    
    let taiwanYear = 113
    let month = 9
    let day = 23
    
    let testingDateString = "\(taiwanYear).\(month).\(day)"
    var testingDateComponents: DateComponents = .init()
    testingDateComponents.year = taiwanYear + 1911
    testingDateComponents.month = month
    testingDateComponents.day = day
    
    let testingDate = Calendar.current.date(from: testingDateComponents)
    
    let blessings = "順頌 商祺"
    let letter = LetterHeader(to: to, from: from, quotingOrganization: .jw, content: content, date: testingDate!, blessings: blessings)
    print(letter.render())
    #expect(letter.render() == """
    <div style="width: 100%;padding: 25px 25px 40px 25px;"><table><tr style="height: 3rem;"><td style="font-family: Times New Roman;width: 5rem; font-size: 1.1rem; vertical-align: top;">To</td><td style="text-align: left; font-size: 1.1rem;vertical-align: top;"><div>Jane Doe</div></td></tr><tr><td style="height: 1rem;" colspan="2"></td></tr><tr style="height: 3rem;"><td style="font-family: Times New Roman; font-size: 1.1rem; vertical-align: top;">From</td><td style="text-align: left; font-size: 1.1rem; vertical-align: top;"><div>88183980</div></td></tr></table></div><table><tr><td colspan="2"><hr/><p style="text-indent: 2em;">This is a testing content.</p></td></tr><tr><td style="text-indent: 2em;" colspan="2">順頌 商祺</td></tr><tr><td colspan="2" dir="rtl">嘉威聯合會計師事務所<br/>113.9.23</td></tr></table>
    """)
}


@Test func createContentItemHtml(){
    let title = "Quotation Purpose"
    let content = "This is a description of the Purpose."
    
    let contentItem = ContentItem(title: title, content: content)
    
    #expect(contentItem.render() == """
<table style="break-inside: avoid-page;"><tr style="font-size: 1.1em;"><td>Quotation Purpose</td></tr><tr><td><p style="text-indent: 2em;">This is a description of the Purpose.</p></td></tr></table>
""")
}


// 服務內容（自訂服務項目走 .introOnly → 落在 QuotingServiceTerm.term）改吃 markdown：
// 1. `- ` 要變成真正的 <ul><li>（原本整段是純文字，圓點印不出來）
// 2. 段落內的 \n 要換行 —— 原本 `Div(term)` 完全不處理 \n，多行內容在 PDF 會連成一行
// 3. 使用者輸入的 HTML 必須被 escape：這欄會印進報價單，不該讓自由文字注入標記
//    （酬金補充說明那條路刻意允許 raw HTML，服務內容不比照）
@Test func serviceScopeTermRendersMarkdownBulletList() {
    let term = "本服務包含：\n- 每月帳務處理\n- 稅務申報代辦"
    let model = QuotingServiceTerm.Model(title: "ItemTitle", term: term, serviceItemTerms: nil)
    let html = ServiceScope(index: 0, model: .init(title: "T", heading: "H", items: [model])).render()

    // swift-markdown 的 HTMLFormatter 對 list item 一律包 <p>（不分 tight/loose），
    // 故斷言 `<li><p>…</p>` 而非 `<li>…</li>` —— 寫死後者會誤判成沒渲染。
    #expect(html.contains("<ul>"))
    #expect(html.contains("<li><p>每月帳務處理</p>"))
    #expect(html.contains("<li><p>稅務申報代辦</p>"))
    #expect(html.contains("<p>本服務包含：</p>"))
}

@Test func serviceScopeTermKeepsSingleNewlineAsLineBreak() {
    let model = QuotingServiceTerm.Model(title: "ItemTitle", term: "第一行\n第二行", serviceItemTerms: nil)
    let html = ServiceScope(index: 0, model: .init(title: "T", heading: "H", items: [model])).render()

    #expect(html.contains("<br />"))
    #expect(html.contains("第一行"))
    #expect(html.contains("第二行"))
}

@Test func serviceScopeTermEscapesUserHtml() {
    let model = QuotingServiceTerm.Model(title: "ItemTitle", term: "<script>alert(1)</script> a & b", serviceItemTerms: nil)
    let html = ServiceScope(index: 0, model: .init(title: "T", heading: "H", items: [model])).render()

    #expect(!html.contains("<script>"))
    #expect(html.contains("&lt;script&gt;"))
    #expect(html.contains("a &amp; b"))
}

// 服務範圍原本是三層遞進縮排（標題 text-indent:2em → 內文 2em+3em+2em → 編號項 3.8em），
// 一層比一層右。要求是內文與編號項**共用同一層縮排**（仍縮在標題底下，不是貼齊容器左緣）。
// 這條鎖住「兩者深度相同」——分開寫就會重演遞進縮排，而版面問題不會有測試訊號。
@Test func serviceScopeHasNoProgressiveIndent() {
    let model = QuotingServiceTerm.Model(
        title: "標題",
        term: "內文",
        serviceItemTerms: [.init(content: "工作項目一"), .init(content: "工作項目二")]
    )
    let html = ServiceScope(index: 0, model: .init(title: "T", heading: "H", items: [model])).render()

    // 舊的三個不同深度都不該再出現
    #expect(!html.contains("padding-left: 2em"))
    #expect(!html.contains("padding-left: 3em"))
    #expect(!html.contains("padding-left: 3.8em"))
    // 內文與編號項共用同一個深度：出現兩次（各一個外層容器）
    let indentOccurrences = html.components(separatedBy: "padding-left: \(ServiceScope.bodyIndent)").count - 1
    #expect(indentOccurrences == 2)
    // 編號清單不吃預設縮排、標記排進文字流（否則編號會比內文右一截）
    #expect(html.contains("list-style-position: inside; padding-left: 0"))
}

@Test func createServiceScopeHtml(){
    let title = "Quotation Service Scope"
    let content = "This is a description of the Service Scope."
    
    let model = QuotingServiceTerm.Model(title: "ItemTitle", term: "ItemContent", serviceItemTerms: nil)
    let quotingServiceTerms: [QuotingServiceTerm.Model] = [
        model
    ]
    
    let serviceScope = ServiceScope(index: 0, model: .init(title: title, heading: content, items: quotingServiceTerms))
    
    // 服務內容改走 markdown 渲染後，term 外多包一層 .rich-serviceContent（見 ServiceContentHTMLRenderer）。
    // style block 以常數內插而非貼死字串：否則之後微調清單縮排，這條 snapshot 又會誤紅。
    let expectedContent = ServiceContentHTMLRenderer.scopedStyleBlock
        + "<div class=\"rich-serviceContent\"><p>ItemContent</p>\n</div>"
    #expect(serviceScope.render() == """
<div style="break-inside: avoid-page;"><div style="font-size: 1.1em;">一、Quotation Service Scope</div><p style="text-indent: 2em;">This is a description of the Service Scope.</p></div><div style="display: flex; flex-direction: column;  break-inside: avoid-page; "><div style="display: flex; text-indent: 2em;">（一）ItemTitle</div><div style="display: flex; flex-direction: column; padding-left: \(ServiceScope.bodyIndent);"><div style="display: flex;">\(expectedContent)</div></div></div>
""")
}



@Test func createContractSectionHtml(){
    let contractSection = ContractSection(index: 4, title: "權利義務事項", heading: "本項說明如下：", provisions: [
        .init(term: "第一條條款。")
    ])

    #expect(contractSection.render() == """
<div style="break-inside: avoid-page; "><div style="font-size: 1.1em; margin-top: 1em;">五、權利義務事項</div><p style="display: flex; text-indent: 2em;">本項說明如下：</p><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（一）第一條條款。</div></div></div>
""")
}


@Test func createPaymentItemHtml(){
    let names: [String] = ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證", "二代健保暨表單彙總處理"]
    let fee = "5,000 元/月"
    
    let paymentItem = PaymentItem(names: names, fee: fee)
    
    #expect(paymentItem.render() == """
<td><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div><div>二代健保暨表單彙總處理</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">5,000 元/月</td>
""")
}





@Test func createPaymentHtml(){
    let title = "酬金"
    let items: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], fee: "5,000 元/年"),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "6,000 元/年")
    ]

    let payment = Payment(name: title, items: items)
    #expect(payment.render() == """
    <tr><td colspan="3"><b style="font-size: 0.95em;">酬金</b></td></tr><tr style="padding-bottom: 0.5em; width: 100%; padding-top: 0.5em;"><td style="vertical-align: top; width: 1.35rem;">1.</td><td><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">5,000 元/年</td></tr><tr style="padding-bottom: 0.5em; width: 100%; padding-top: 0.5em;"><td style="vertical-align: top; width: 1.35rem;">2.</td><td><div>會計帳務處理作業（113 年 5 月開始）</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">6,000 元/年</td></tr>
    """)
}

@Test func paymentRendersSupplementaryNoteRowWhenProvided(){
    let payment = Payment(
        name: "糕盛有限公司",
        items: [
            .init(names: ["民國 114 度財務報表查核簽證"], fee: "100,000 元/年")
        ],
        supplementaryNote: "財務簽證依預估資產總額新台幣壹億元報價\n會計帳務處理作業依照預估年營收貳億伍仟萬元報價。"
    )
    // 2026-07：補充說明不加任何標記符號、不畫上方橫線；僅以 markdown 渲染的內文呈現。
    let rendered = payment.render()
    #expect(rendered.contains("財務簽證依預估資產總額新台幣壹億元報價"))
    // 補充說明 cell：純 rich-supplementaryNote，不帶 marker。
    #expect(rendered.contains("<div class=\"rich-supplementaryNote\">"),
        "補充說明應以 rich-supplementaryNote 呈現")
    #expect(!rendered.contains("with-marker"), "不應再套 with-marker（* 標記已移除）")
    #expect(!rendered.contains("::before"), "不應再有 * marker 的 ::before 規則")
    #expect(!rendered.contains("border-top: 1px solid black"), "不應再畫上方分隔線")
    #expect(!rendered.contains("white-space: pre-line"), "legacy pre-line style 不應再被 emit")
    #expect(!rendered.contains(">*財務簽證"), "不應出現硬寫的 * 前綴")
}

@Test func paymentOmitsSupplementaryNoteRowWhenNil(){
    let payment = Payment(
        name: "X",
        items: [.init(names: ["item"], fee: "1 元/年")]
    )
    // nil → 整個 supplementaryNote row 不渲染（用 `colspan="2"` 鎖、items row 沒這屬性）
    #expect(!payment.render().contains("colspan=\"2\""))
}

@Test func paymentOmitsSupplementaryNoteRowWhenEmptyString(){
    let payment = Payment(
        name: "X",
        items: [.init(names: ["item"], fee: "1 元/年")],
        supplementaryNote: ""
    )
    #expect(!payment.render().contains("colspan=\"2\""))
}

/// 鎖 supplementaryNote 走 raw HTML inject — 內含 `<b>` / `<u>` 等 tag 不會被 escape，且**不加任何前綴**。
/// 對應 2026-06 富文字編輯支援（前端 markdown / HTML 混合內容轉 HTML 後傳入此欄位）。
@Test func paymentRendersSupplementaryNoteAsRawHTML(){
    let payment = Payment(
        name: "X",
        items: [.init(names: ["item"], fee: "1 元/年")],
        supplementaryNote: "<b>粗體</b> <u>底線</u> <s>刪除線</s>"
    )
    let rendered = payment.render()
    #expect(rendered.contains("<b>粗體</b> <u>底線</u> <s>刪除線</s>"),
        "HTML tag 應原樣 inject、不應被 escape 成 &lt;b&gt; 等")
    #expect(!rendered.contains("&lt;b&gt;"), "確認沒 escape")
    #expect(!rendered.contains("*<b>"), "硬寫的 `*` 前綴不應再被 emit")
}

/// 鎖內嵌圖片（caller 已轉 data URI）正常 inject — `<img src="data:image/...">`。
@Test func paymentRendersSupplementaryNoteWithEmbeddedImage(){
    let dataUri = "data:image/png;base64,iVBORw0KGgo=" // 短的測試用 base64
    let payment = Payment(
        name: "X",
        items: [.init(names: ["item"], fee: "1 元/年")],
        supplementaryNote: "見附圖：<img src=\"\(dataUri)\" />"
    )
    let rendered = payment.render()
    #expect(rendered.contains("<img src=\"\(dataUri)\""),
        "data URI img tag 應原樣 inject、可被 weasyprint 渲染為實際圖片")
}

@Test("two payment", arguments: [
    ([
        Payment(name: "****作業(112 年度)", items: [
            .init(names: ["Hello"], fee: "5,000 元/月")
        ]),
        Payment(name: "****作業(113 年起)", items: [
            .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], fee: "5,000 元/年"),
            .init(names: ["World"], fee: "6,000 元/年")
        ])
    ], """
    <p style="font-size: 1.1rem;">酬金</p><div style="break-inside: avoid-page;"><table style="border-collapse: collapse; width: 100%;"><tr style="border-bottom: 1px solid black;"><td colspan="2" style="text-align: center ;">服務項目</td><td><div style="white-space: nowrap; text-align: right; padding-right: 1em;">公費金額</div></td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td colspan="3"><b style="font-size: 0.95em;">****作業(112 年度)</b></td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td style="vertical-align: top; width: 1.35rem;">1.</td><td><div>Hello</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">5,000 元/月</td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td colspan="3"><b style="font-size: 0.95em;">****作業(113 年起)</b></td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td style="vertical-align: top; width: 1.35rem;">1.</td><td><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">5,000 元/年</td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td style="vertical-align: top; width: 1.35rem;">2.</td><td><div>World</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">6,000 元/年</td></tr></table></div>
    """),
    ([
        Payment(name: "****作業(112 年度)", items: [
            .init(names: ["Hello"], fee: "5,000 元/年")
        ])
    ], """
    <p style="font-size: 1.1rem;">酬金</p><div style="break-inside: avoid-page;"><table style="border-collapse: collapse; width: 100%;"><tr style="border-bottom: 1px solid black;"><td colspan="2" style="text-align: center ;">服務項目</td><td><div style="white-space: nowrap; text-align: right; padding-right: 1em;">公費金額</div></td></tr><tr style="font-size: 1rem; padding-bottom: 0.5em; width: 100%;"><td style="vertical-align: top; width: 1.35rem;">1.</td><td><div>Hello</div></td><td style="text-align: right; vertical-align: top; white-space: nowrap; padding-right: 0.5em;">5,000 元/年</td></tr></table></div>
    """)
])
func createPaymentBlocHtml(payments: [Payment], result: String){
    let paymentBlock = PaymentBlock(title: "酬金", payments: payments)

    #expect(paymentBlock.render() == result)
}

@Test("multiple cases render a case-name heading; bundle name shown only for cases with ≥2 bundles")
func paymentBlockRendersCaseHeadingsWhenMultipleCases() {
    let payments = [
        // 甲公司：2 個 bundle → bundle 名照顯示
        Payment(name: "規劃1", items: [.init(names: ["稅務帳務處理作業"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "規劃2", items: [.init(names: ["記帳作業"], fee: "3,000 元/月")], caseName: "甲公司"),
        // 乙公司：1 個 bundle → bundle 名隱藏（case 標題已足夠）
        Payment(name: "乙方案", items: [.init(names: ["財務報表查核簽證"], fee: "50,000 元/年")], caseName: "乙公司"),
    ]
    let rendered = PaymentBlock(title: "酬金", payments: payments).render()

    // 兩個不同 case → 各自的 case 名稱標題（1.05em bold）。
    #expect(rendered.contains("<b style=\"font-size: 1.05em;\">甲公司</b>"))
    #expect(rendered.contains("<b style=\"font-size: 1.05em;\">乙公司</b>"))
    // 甲公司有 ≥2 個 bundle → bundle 名（0.95em）照顯示。
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃1</b>"))
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃2</b>"))
    // 乙公司只有 1 個 bundle → bundle 名隱藏（即使在合併顯示多 case 情境）。
    #expect(!rendered.contains("乙方案"), "單一 bundle 的 case 不應顯示 bundle 名")
    // 甲公司標題排在乙公司之前（依輸入 case 順序）。
    let jiaIndex = try! #require(rendered.range(of: "甲公司")).lowerBound
    let yiIndex = try! #require(rendered.range(of: "乙公司")).lowerBound
    #expect(jiaIndex < yiIndex)
}

@Test("bundle-name hiding counts total bundles per case, not consecutive runs (order-independent)")
func paymentBlockCountsBundlesPerCaseRegardlessOfOrder() {
    // 甲公司的兩個 bundle 在輸入中被乙公司隔開（非連續）→ 仍應視為「甲有 2 bundle」而顯示其 bundle 名。
    let payments = [
        Payment(name: "規劃1", items: [.init(names: ["稅務帳務處理作業"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "乙方案", items: [.init(names: ["財務報表查核簽證"], fee: "50,000 元/年")], caseName: "乙公司"),
        Payment(name: "規劃2", items: [.init(names: ["記帳作業"], fee: "3,000 元/月")], caseName: "甲公司"),
    ]
    let rendered = PaymentBlock(title: "酬金", payments: payments).render()

    // 甲公司總共 2 個 bundle → bundle 名照顯示（不因被乙公司隔開而誤隱藏）。
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃1</b>"))
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃2</b>"))
    // 乙公司只有 1 個 bundle → 隱藏。
    #expect(!rendered.contains("乙方案"), "單一 bundle 的 case 不應顯示 bundle 名")
}

@Test("single-bundle case hides bundle name even in merged (multi-case) view")
func paymentBlockHidesSingleBundleNamePerCaseInMergedView() {
    // 兩個 case 各只有 1 個 bundle → case 標題照渲染、但兩個 bundle 名都隱藏。
    let payments = [
        Payment(name: "甲方案", items: [.init(names: ["稅務帳務處理作業"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "乙方案", items: [.init(names: ["財務報表查核簽證"], fee: "50,000 元/年")], caseName: "乙公司"),
    ]
    let rendered = PaymentBlock(title: "酬金", payments: payments).render()

    #expect(rendered.contains("<b style=\"font-size: 1.05em;\">甲公司</b>"))
    #expect(rendered.contains("<b style=\"font-size: 1.05em;\">乙公司</b>"))
    #expect(!rendered.contains("甲方案"), "單一 bundle 的 case 不應顯示 bundle 名")
    #expect(!rendered.contains("乙方案"), "單一 bundle 的 case 不應顯示 bundle 名")
}

@Test("single case does not render a case-name heading")
func paymentBlockOmitsCaseHeadingWhenSingleCase() {
    // 同一 case 的兩個 bundle：不顯示 case 標題，沿用既有「多 bundle 顯示 bundle 名」行為。
    let payments = [
        Payment(name: "規劃1", items: [.init(names: ["A"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "規劃2", items: [.init(names: ["B"], fee: "50,000 元/年")], caseName: "甲公司"),
    ]
    let rendered = PaymentBlock(title: "酬金", payments: payments).render()

    // 單一 case 不渲染 case 名稱標題 → caseName 文字（甲公司）完全不出現（case 名只會以標題形式出現）。
    #expect(!rendered.contains("甲公司"), "單一 case 不應出現 case 名稱標題")
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃1</b>"))
    #expect(rendered.contains("<b style=\"font-size: 0.95em;\">規劃2</b>"))
}

@Test("reply form: single-bundle case hides bundle name even in merged (multi-case) view")
func replyFormPaymentBlockHidesSingleBundleNamePerCaseInMergedView() {
    // 兩個 case 各只有 1 個 bundle → case 標題照渲染、但兩個 bundle 名都隱藏（與主酬金 PaymentBlock 一致）。
    let payments = [
        Payment(name: "規劃1", items: [.init(names: ["財務報表查核簽證"], fee: "320,000 元/年")], caseName: "誠鋼實業股份有限公司"),
        Payment(name: "規劃1", items: [.init(names: ["財務報表查核簽證"], fee: "120,000 元/年")], caseName: "東經投資有限公司"),
    ]
    let rendered = ReplyFormPaymentBlock(payments: payments).render()

    #expect(rendered.contains("<b style=\"font-size: 1.1em;\">誠鋼實業股份有限公司</b>"))
    #expect(rendered.contains("<b style=\"font-size: 1.1em;\">東經投資有限公司</b>"))
    #expect(!rendered.contains("規劃1"), "單一 bundle 的 case 不應顯示 bundle 名")
}

@Test("reply form: bundle names shown only for cases with ≥2 bundles, order-independent")
func replyFormPaymentBlockCountsBundlesPerCaseRegardlessOfOrder() {
    // 甲公司的兩個 bundle 被乙公司隔開（非連續）→ 仍視為「甲有 2 bundle」照顯示；乙單 bundle 隱藏。
    let payments = [
        Payment(name: "規劃1", items: [.init(names: ["稅務帳務處理作業"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "乙方案", items: [.init(names: ["財務報表查核簽證"], fee: "50,000 元/年")], caseName: "乙公司"),
        Payment(name: "規劃2", items: [.init(names: ["記帳作業"], fee: "3,000 元/月")], caseName: "甲公司"),
    ]
    let rendered = ReplyFormPaymentBlock(payments: payments).render()

    #expect(rendered.contains("<b>規劃1</b>"))
    #expect(rendered.contains("<b>規劃2</b>"))
    #expect(!rendered.contains("乙方案"), "單一 bundle 的 case 不應顯示 bundle 名")
}

@Test("reply form: single case keeps existing single/multi bundle behavior")
func replyFormPaymentBlockSingleCaseBehaviorUnchanged() {
    // 單一 case、多 bundle → bundle 名照顯示、無 case 標題。
    let multi = ReplyFormPaymentBlock(payments: [
        Payment(name: "規劃1", items: [.init(names: ["A"], fee: "4,000 元/月")], caseName: "甲公司"),
        Payment(name: "規劃2", items: [.init(names: ["B"], fee: "50,000 元/年")], caseName: "甲公司"),
    ]).render()
    #expect(!multi.contains("甲公司"), "單一 case 不應出現 case 名稱標題")
    #expect(multi.contains("<b>規劃1</b>"))
    #expect(multi.contains("<b>規劃2</b>"))

    // 單一 case、單 bundle → bundle 名隱藏（既有行為）。
    let single = ReplyFormPaymentBlock(payments: [
        Payment(name: "規劃1", items: [.init(names: ["A"], fee: "4,000 元/月")], caseName: nil),
    ]).render()
    #expect(!single.contains("規劃1"), "單 bundle 不應顯示 bundle 名")
}




@Test func createBusinessClientAssistance(){
    let title = "Assistance Title"
    let items: [BusinessClientAssistanceItem.Model] = [
        .init(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
        .init(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
        .init(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
    ]
    
    let assistance = BusinessClientAssistance(index: 0, title: title, items: items)
    
    #expect(assistance.render() == """
<div><div style="break-inside: avoid-page;"><div style="font-size: 1.1em;">一、Assistance Title</div><div style="break-inside: avoid-page; "><div style="display: flex; text-indent: 2em; padding-top: 1em;">（一）指派專責會計人員</div><div style="display: flex; flex-direction: column; padding-left: 5em;"><div style="display: flex; text-indent: 2em;">為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。</div></div></div></div><div style="break-inside: avoid-page; "><div style="display: flex; text-indent: 2em; padding-top: 1em;">（二）網路銀行申請</div><div style="display: flex; flex-direction: column; padding-left: 5em;"><div style="display: flex; text-indent: 2em;">為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)</div></div></div><div style="break-inside: avoid-page; "><div style="display: flex; text-indent: 2em; padding-top: 1em;">（三）配合及時提供相關資訊</div><div style="display: flex; flex-direction: column; padding-left: 5em;"><div style="display: flex; text-indent: 2em;">為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。</div></div></div></div>
""")
    
}




@Test func createNote(){
    let contents: [String] = [
        "報價依照年度營收狀況及資產總額狀況評估，若有巨額變動時，將另與 貴公司民國112年以後依照附表一、專屬全家人健康事業(股) 會計帳務及稅務申報處理作業級距表討論報價金額。簽證公費請於當年底時支付半數，另外半數請於交付報告時支付；財會委外會計帳務暨稅務處申報理作業費用一年以十四個月計算，並請於次月底前支付前一個月之公費。合約執行期間不得低於二年，解除合約須提前三個月告知。",
        """
        出納事務處理作業內容包含：
        A.國內轉帳30 筆；每加⼀筆多50 元。
        B.國外轉帳10 筆；每加⼀筆多100 元。
        C.⼀次薪資轉帳。
        """,
        "薪資人力支援處理作業500元/人/月；基本收費3,000/月。"
    ]
    
    let note = Note(contents: contents)
    #expect(note.render() == """
    <table><tr style="break-inside: avoid-page;"><td style="width: 3.8rem; vertical-align: top; font-size: 0.83rem;">註一：</td><td><div><div style="font-size: 0.83rem;">報價依照年度營收狀況及資產總額狀況評估，若有巨額變動時，將另與 貴公司民國112年以後依照附表一、專屬全家人健康事業(股) 會計帳務及稅務申報處理作業級距表討論報價金額。簽證公費請於當年底時支付半數，另外半數請於交付報告時支付；財會委外會計帳務暨稅務處申報理作業費用一年以十四個月計算，並請於次月底前支付前一個月之公費。合約執行期間不得低於二年，解除合約須提前三個月告知。</div></div></td></tr><tr style="break-inside: avoid-page;"><td style="width: 3.8rem; vertical-align: top; font-size: 0.83rem;">註二：</td><td><div><div style="font-size: 0.83rem;">出納事務處理作業內容包含：</div><div style="font-size: 0.83rem;">A.國內轉帳30 筆；每加⼀筆多50 元。</div><div style="font-size: 0.83rem;">B.國外轉帳10 筆；每加⼀筆多100 元。</div><div style="font-size: 0.83rem;">C.⼀次薪資轉帳。</div></div></td></tr><tr style="break-inside: avoid-page;"><td style="width: 3.8rem; vertical-align: top; font-size: 0.83rem;">註三：</td><td><div><div style="font-size: 0.83rem;">薪資人力支援處理作業500元/人/月；基本收費3,000/月。</div></div></td></tr></table>
    """)
    
}



@Test func createReplyForm(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
    let paymentItems: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"],  fee: "5,000 元/年"),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "6,000 元/月")
    ]
    let payments = [
        Payment(name: "Hello", items: paymentItems)
    ]
    let additionalServices: [AdditionalService] = [
        AdditionalService(name: "代辦年度CTP申報(每年3月；加收2,000元/家)", isSelected: false),
        AdditionalService(name: "二代健保申報作業", isSelected: true) 
    ]
    let quotationNo = "111112101"

    let replyForm = ReplyForm(receiver: receiver, sender: sender, subject: subject, payments: payments, additionalServices: additionalServices, quotationNo: quotationNo)
    #expect(replyForm.render() == """
<h2 style="text-align: center;">同意函</h2><table style="width: 100%;"><tr><td style="width: 70px; white-space: nowrap; vertical-align: top">受文者：</td><td>嘉威聯合會計師事務所</td></tr><tr><td style="white-space: nowrap; vertical-align: top">主　旨：</td><td>本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。</td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top">酬　金：</td></tr><tr><td></td><td><div style="break-inside: avoid-page;"><table style="font-size: 0.875rem; width: 100%; border-collapse: separate; border-spacing: 0.2em;"><tr><td style="vertical-align: top;">(1)</td><td style="vertical-align: top; width: 100%;"><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">5,000 元/年</td></tr><tr><td style="vertical-align: top;">(2)</td><td style="vertical-align: top; width: 100%;"><div>會計帳務處理作業（113 年 5 月開始）</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">6,000 元/月</td></tr></table></div></td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top;">附加服務請勾選：</td></tr><tr style="font-size: 0.875rem;"><td></td><td>□代辦年度CTP申報(每年3月；加收2,000元/家)</td></tr><tr style="font-size: 0.875rem;"><td></td><td>☑二代健保申報作業</td></tr></table><br/><div style="break-inside: avoid-page;"><table style="width: 100%;"><tr><td style="white-space: nowrap; vertical-align: top;">附　件：</td><td>嘉威稅字第111112101號公費報價單</td></tr></table><br/><table style="width: 100%;"><tr><td style="width: 102px;"></td><td>全家人健康事業股份有限公司</td><td style="width: 10rem;"></td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（公　司　章）　　</td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（授權人簽名或蓋章）</td></tr></table></div><div style="display: flex; justify-content: space-between; width: 100%; margin: 0 auto; position: absolute; bottom: 0px;"><p>中　　華　　民　　國</p><p>年</p><p>月</p><p>日</p></div>
""")
}


@Test func createReplyFormWithoutCompanyStamp(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
    let paymentItems: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"],  fee: "5,000 元/年"),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "6,000 元/月")
    ]
    let payments = [
        Payment(name: "Hello", items: paymentItems)
    ]
    let additionalServices: [AdditionalService] = [
        AdditionalService(name: "代辦年度CTP申報(每年3月；加收2,000元/家)", isSelected: false),
        AdditionalService(name: "二代健保申報作業", isSelected: true)
    ]
    let quotationNo = "111112101"

    let replyForm = ReplyForm(receiver: receiver, sender: sender, subject: subject, payments: payments, additionalServices: additionalServices, quotationNo: quotationNo, showCompanyStamp: false)
    #expect(replyForm.render() == """
<h2 style="text-align: center;">同意函</h2><table style="width: 100%;"><tr><td style="width: 70px; white-space: nowrap; vertical-align: top">受文者：</td><td>嘉威聯合會計師事務所</td></tr><tr><td style="white-space: nowrap; vertical-align: top">主　旨：</td><td>本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。</td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top">酬　金：</td></tr><tr><td></td><td><div style="break-inside: avoid-page;"><table style="font-size: 0.875rem; width: 100%; border-collapse: separate; border-spacing: 0.2em;"><tr><td style="vertical-align: top;">(1)</td><td style="vertical-align: top; width: 100%;"><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">5,000 元/年</td></tr><tr><td style="vertical-align: top;">(2)</td><td style="vertical-align: top; width: 100%;"><div>會計帳務處理作業（113 年 5 月開始）</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">6,000 元/月</td></tr></table></div></td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top;">附加服務請勾選：</td></tr><tr style="font-size: 0.875rem;"><td></td><td>□代辦年度CTP申報(每年3月；加收2,000元/家)</td></tr><tr style="font-size: 0.875rem;"><td></td><td>☑二代健保申報作業</td></tr></table><br/><div style="break-inside: avoid-page;"><table style="width: 100%;"><tr><td style="white-space: nowrap; vertical-align: top;">附　件：</td><td>嘉威稅字第111112101號公費報價單</td></tr></table><br/><table style="width: 100%;"><tr><td style="width: 102px;"></td><td>全家人健康事業股份有限公司</td><td style="width: 10rem;"></td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">　</td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（授權人簽名或蓋章）</td></tr></table></div><div style="display: flex; justify-content: space-between; width: 100%; margin: 0 auto; position: absolute; bottom: 0px;"><p>中　　華　　民　　國</p><p>年</p><p>月</p><p>日</p></div>
""")
}

@Test func createReplyFormWithoutAdditionalService(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
    
    let paymentItems: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], fee: "5,000 元/年"),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: "6,000 元/月")
    ]
    
    let payments = [
        Payment(name: "Hello", items: paymentItems)
    ]
    
    let additionalServices: [AdditionalService] = []
    let quotationNo = "111112101"

    let replyForm = ReplyForm(receiver: receiver, sender: sender, subject: subject, payments: payments, additionalServices: additionalServices, quotationNo: quotationNo)
    #expect(replyForm.render() == """
<h2 style="text-align: center;">同意函</h2><table style="width: 100%;"><tr><td style="width: 70px; white-space: nowrap; vertical-align: top">受文者：</td><td>嘉威聯合會計師事務所</td></tr><tr><td style="white-space: nowrap; vertical-align: top">主　旨：</td><td>本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。</td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top">酬　金：</td></tr><tr><td></td><td><div style="break-inside: avoid-page;"><table style="font-size: 0.875rem; width: 100%; border-collapse: separate; border-spacing: 0.2em;"><tr><td style="vertical-align: top;">(1)</td><td style="vertical-align: top; width: 100%;"><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">5,000 元/年</td></tr><tr><td style="vertical-align: top;">(2)</td><td style="vertical-align: top; width: 100%;"><div>會計帳務處理作業（113 年 5 月開始）</div></td><td style="vertical-align: top; text-align: right; white-space: nowrap;">6,000 元/月</td></tr></table></div></td></tr></table><br/><div style="break-inside: avoid-page;"><table style="width: 100%;"><tr><td style="white-space: nowrap; vertical-align: top;">附　件：</td><td>嘉威稅字第111112101號公費報價單</td></tr></table><br/><table style="width: 100%;"><tr><td style="width: 102px;"></td><td>全家人健康事業股份有限公司</td><td style="width: 10rem;"></td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（公　司　章）　　</td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（授權人簽名或蓋章）</td></tr></table></div><div style="display: flex; justify-content: space-between; width: 100%; margin: 0 auto; position: absolute; bottom: 0px;"><p>中　　華　　民　　國</p><p>年</p><p>月</p><p>日</p></div>
""")
}



@Test func createContractHeader(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "承 貴公司委任本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務，至深感荷。謹將服務內容及酬金等分別說明如後，敬請卓察賜覆為禱。"
    let description = "感謝 貴公司對本事務所的支持與愛護，本事務所本著積極服務顧客的熱忱，以及專業智慧的多元服務，特將本事務所受託辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務內容概述如後，期盼此項合作能協助 貴公司提升會計帳務品質，俾能符合相關稅務法令和企業會計準則之規定。茲將委任之目的、服務範圍、 貴公司協助事項、酬金、權利義務事項及同意函列示如下："
    
    let contractHeader = ContractHeader(receiver: receiver, sender: sender, subject: subject, content: description)
    #expect(contractHeader.render() == """
    <table style="margin: 2rem 2rem 3rem 2rem;"><tr><td style="vertical-align: top; width: 6em; font-size: 1rem;">受 文 者：</td><td style="font-size: 1rem;">全家人健康事業股份有限公司（以下簡稱 貴公司）</td></tr><tr><td style="vertical-align: top; font-size: 1rem;">發 文 者：</td><td style="font-size: 1rem;">嘉威聯合會計師事務所（以下簡稱 本事務所）</td></tr><tr><td style="vertical-align: top; font-size: 1rem;">主    旨：</td><td style="font-size: 1rem;">承 貴公司委任本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務，至深感荷。謹將服務內容及酬金等分別說明如後，敬請卓察賜覆為禱。</td></tr><tr><td style="vertical-align: top; font-size: 1rem;">說    明：</td><td style="font-size: 1rem;">感謝 貴公司對本事務所的支持與愛護，本事務所本著積極服務顧客的熱忱，以及專業智慧的多元服務，特將本事務所受託辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務內容概述如後，期盼此項合作能協助 貴公司提升會計帳務品質，俾能符合相關稅務法令和企業會計準則之規定。茲將委任之目的、服務範圍、 貴公司協助事項、酬金、權利義務事項及同意函列示如下：</td></tr></table>
    """)
}

@Test func createRightsAndObligations(){
    let rightsAndObligations = ContractSection(title: "權利義務事項", heading: "本事務所將會依照現行法規的規範及符合專業慣例之基礎上提供上開服務：", provisions: [
        .init(term: "本事務所將依現行有效之法規，提供上開各項服務；就服務事項完辦後相關法規之變更、修正或廢止所導致之變動，應另行修正報價單之內容。"),
        .init(term: "本事務所將依據  貴公司所提供之資料及文件，利用會計專業知識蒐集、分類及彙總財務資訊，進而提供會計帳務處理作業服務項目，無須對資訊加以查核或核閱，所提供之財務資訊亦不提供任何程度之確信。"),
        .init(term: "本事務所所提供會計帳務處理作業服務，僅限協助 貴公司完成相關專業服務使用。除本事務所有可歸責之情形外，如本事務所於本報價單意旨提供會計帳務處理作業服務事項，而遭致第三人向本事務所為法律上之主張而致生損害時， 貴公司同意負責補償。另未經本事務所書面同意，本事務所所提供之服務不得提供他人使用(其中不包含提供予股東開會使用)；且若有此種情形致他人權益受損，本事務所不負任何責任。"),
        .init(term: "本事務所履行委任書所涉之服務事項，將本誠信履踐應有之注意義務，惟僅於經法院判決確定後，在本案已收受之服務公費範圍內負擔相關責任。"),
        .init(term: "本公司對 貴公司所提供之各項資料或相關文件，當盡保密之責。"),
        .init(term: "本委任書由 貴公司與本公司雙方各執一份。")
    ])
    #expect(rightsAndObligations.render() == """
    <div style="break-inside: avoid-page; "><div style="font-size: 1.1em; margin-top: 1em;">權利義務事項</div><p style="display: flex; text-indent: 2em;">本事務所將會依照現行法規的規範及符合專業慣例之基礎上提供上開服務：</p><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（一）本事務所將依現行有效之法規，提供上開各項服務；就服務事項完辦後相關法規之變更、修正或廢止所導致之變動，應另行修正報價單之內容。</div></div><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（二）本事務所將依據  貴公司所提供之資料及文件，利用會計專業知識蒐集、分類及彙總財務資訊，進而提供會計帳務處理作業服務項目，無須對資訊加以查核或核閱，所提供之財務資訊亦不提供任何程度之確信。</div></div><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（三）本事務所所提供會計帳務處理作業服務，僅限協助 貴公司完成相關專業服務使用。除本事務所有可歸責之情形外，如本事務所於本報價單意旨提供會計帳務處理作業服務事項，而遭致第三人向本事務所為法律上之主張而致生損害時， 貴公司同意負責補償。另未經本事務所書面同意，本事務所所提供之服務不得提供他人使用(其中不包含提供予股東開會使用)；且若有此種情形致他人權益受損，本事務所不負任何責任。</div></div><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（四）本事務所履行委任書所涉之服務事項，將本誠信履踐應有之注意義務，惟僅於經法院判決確定後，在本案已收受之服務公費範圍內負擔相關責任。</div></div><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（五）本公司對 貴公司所提供之各項資料或相關文件，當盡保密之責。</div></div><div style="display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;"><div style="display: flex; text-indent: -3em;">（六）本委任書由 貴公司與本公司雙方各執一份。</div></div></div>
    """)
}

@Test func createAgreementTerms(){
    let agreementTerms = ContractSection(title: "其它約定事項", heading: "", provisions: [
        .init(term: "上開服務公費自本函發出日有效期間為三個月，倘　貴公司簽署回函時點已逾本函發出日三個月以上，本事務所保有修改本服務委任書之權利。"),
        .init(term: "在本報價單所載之工作服務期間，任何一方可提前三個月要求終止服務或終止雙方之委任關係，惟 貴公司仍應支付本事務所已完成工作之服務費用。貴公司同意於雙方之委任關係終止後15日內，不經本事務所催告即應對本事務所清償所有 貴公司應付之費用。"),
        .init(term: "貴公司或 貴公司之代理人或使用人所提供之文件將暫存於本事務所處，本事務所將依本事務所當時之正常文件管理方式保管之。本事務所得於每年度終了或特定服務完成後，返還本事務所為 貴公司所留存之文件。於 貴公司請求返還之情形下，本事務所將於收訖 貴公司應給付之全部費用後，儘速返還本事務所為 貴公司所留存之文件。除前述 貴公司交付之文件資料外，本事務所得留存相關文件影本、紀錄，包括草稿、筆記、利害衝突確認紀錄、帳務及財務資訊、內部紀錄及其他工作成果，除依法應保存之文件、紀錄或資訊外，本事務所得於委任關係終止或特定服務履行完成後，銷毀或以其他方式處分該等文件、紀錄或資訊。\n有關本報價單所生之相關爭議，均應以中華民國法令為準據法。"),
    ])
    #expect(agreementTerms.render() == "<div style=\"break-inside: avoid-page; \"><div style=\"font-size: 1.1em; margin-top: 1em;\">其它約定事項</div><p style=\"display: flex; text-indent: 2em;\"></p><div style=\"display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;\"><div style=\"display: flex; text-indent: -3em;\">（一）上開服務公費自本函發出日有效期間為三個月，倘　貴公司簽署回函時點已逾本函發出日三個月以上，本事務所保有修改本服務委任書之權利。</div></div><div style=\"display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;\"><div style=\"display: flex; text-indent: -3em;\">（二）在本報價單所載之工作服務期間，任何一方可提前三個月要求終止服務或終止雙方之委任關係，惟 貴公司仍應支付本事務所已完成工作之服務費用。貴公司同意於雙方之委任關係終止後15日內，不經本事務所催告即應對本事務所清償所有 貴公司應付之費用。</div></div><div style=\"display: flex; flex-direction: column; padding-left: 5em; break-inside: avoid-page;\"><div style=\"display: flex; text-indent: -3em;\">（三）貴公司或 貴公司之代理人或使用人所提供之文件將暫存於本事務所處，本事務所將依本事務所當時之正常文件管理方式保管之。本事務所得於每年度終了或特定服務完成後，返還本事務所為 貴公司所留存之文件。於 貴公司請求返還之情形下，本事務所將於收訖 貴公司應給付之全部費用後，儘速返還本事務所為 貴公司所留存之文件。除前述 貴公司交付之文件資料外，本事務所得留存相關文件影本、紀錄，包括草稿、筆記、利害衝突確認紀錄、帳務及財務資訊、內部紀錄及其他工作成果，除依法應保存之文件、紀錄或資訊外，本事務所得於委任關係終止或特定服務履行完成後，銷毀或以其他方式處分該等文件、紀錄或資訊。\n有關本報價單所生之相關爭議，均應以中華民國法令為準據法。</div></div></div>")
}
