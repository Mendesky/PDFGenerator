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
    let letter = LetterHeader(to: to, from: from, content: content, date: testingDate!, blessings: blessings)
    print(letter.render())
    #expect(letter.render() == """
    <div style="width: 100%;padding: 25px 25px 40px 25px;"><table><tr style="height: 3rem;"><td style="font-family: Times New Roman;width: 5rem;">To</td><td style="text-align: left;">\(to)</td></tr><tr style="height: 3rem;"><td style="font-family: Times New Roman;">From</td><td style="text-align: left;">\(letter.from.displayName)</td></tr></table></div><table><tr><td colspan="2"><hr/><p style="text-indent: 2em;">\(content)</p></td></tr><tr><td style="text-indent: 2em;" colspan="2">\(blessings)</td></tr><tr><td colspan="2" dir="rtl">\(letter.from.displayName)<br/>\(testingDateString)</td></tr></table>
    """)
}


@Test func createContentItemHtml(){
    let title = "Quotation Purpose"
    let content = "This is a description of the Purpose."
    
    let contentItem = ContentItem(title: title, content: content)
    
    #expect(contentItem.render() == """
<table style="break-inside: avoid-page;"><tr><td>Quotation Purpose</td></tr><tr><td><p style="text-indent: 2em;">This is a description of the Purpose.</p></td></tr></table>
""")
}





@Test func createServiceItemTermHtml(){
    let term = "This is a Term string."
    
    let serviceItemTerm = ServiceItemTerm(term: term)
    #expect(serviceItemTerm.render() == "<li>\(term)</li>")
}


@Test func createQuotingServiceTermHtml(){
    let title = "Quotation Purpose"
    let content = "This is a description of the Purpose."
    let termStrings = ["Term1", "Term2"]
    
    let terms = termStrings.map{ ServiceItemTerm(term: $0) }
    
    let quotingServiceTerm = QuotingServiceTerm(title: title, term: content, serviceItemTerms: terms)
    
    #expect(quotingServiceTerm.render() == "<p>\(title)</p><p style=\"text-indent: 2em;\">\(content)</p><ol><li>\(termStrings[0])</li><li>\(termStrings[1])</li></ol>")
    
}


@Test func createServiceScopeHtml(){
    let title = "Quotation Service Scope"
    let content = "This is a description of the Service Scope."

    let quotingServiceTerms: [QuotingServiceTerm] = [
        QuotingServiceTerm(title: "ItemTitle", term: "ItemContent", serviceItemTerms: nil)
    ]
    
    let serviceScope = ServiceScope(title: title, heading: content, items: quotingServiceTerms)
    
    #expect(serviceScope.render() == """
<div style="break-inside: avoid-page;"><tr><td>Quotation Service Scope</td></tr><p style="text-indent: 2em;">This is a description of the Service Scope.</p></div><ol><li style="break-inside: avoid-page;"><p>ItemTitle</p><p style="text-indent: 2em;">ItemContent</p></li></ol>
""")
}



@Test func createPaymentItemHtml(){
    let names: [String] = ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證", "二代健保暨表單彙總處理"]
    let price: String = "5,000"
    let billingPeriod: BillingPeriod = .monthly13
    
    let paymentItem = PaymentItem(names: names, price: price, billingPeriod: billingPeriod.description)
    
    #expect(paymentItem.render() == """
<td><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div><div>二代健保暨表單彙總處理</div></td><td><div style="text-align: right; white-space: nowrap; padding-right: 0.5em;">5,000 元/月</div></td>
""")
}





@Test func createPaymentHtml(){
    let billingPeriod: BillingPeriod = .yearly
    let title = "酬金"
    let items: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], price: "5,000", billingPeriod: billingPeriod.description),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], price: "6,000", billingPeriod: billingPeriod.description)
    ]
    
    let paymentItem = Payment(title: title, items: items)
    #expect(paymentItem.render() == """
    <p>酬金</p><table style="border-collapse: collapse; width: 100%;"><tr style="border-bottom: 1px solid black;"><td></td><td>服務項目</td><td><div style="white-space: nowrap; text-align: right; padding-right: 1em;">公費金額</div></td></tr><tr><td style="padding-right: 0.5em; padding-bottom: 0.5em;">(1)</td><td style="padding-bottom: 0.5em; width: 100%;"><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td style="padding-bottom: 0.5em; width: 100%;"><div style="text-align: right; white-space: nowrap; padding-right: 0.5em;">5,000 元/年</div></td></tr><tr><td style="padding-right: 0.5em; padding-bottom: 0.5em;">(2)</td><td style="padding-bottom: 0.5em; width: 100%;"><div>會計帳務處理作業（113 年 5 月開始）</div></td><td style="padding-bottom: 0.5em; width: 100%;"><div style="text-align: right; white-space: nowrap; padding-right: 0.5em;">6,000 元/年</div></td></tr></table>
    """)
}




@Test func createBusinessClientAssistance(){
    let title = "Assistance Title"
    let items: [BusinessClientAssistanceItem] = [
        BusinessClientAssistanceItem(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
        BusinessClientAssistanceItem(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
        BusinessClientAssistanceItem(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
    ]
    
    let assistance = BusinessClientAssistance(title: title, items: items)
    
    #expect(assistance.render() == """
<div style="break-inside: avoid-page;"><tr><td>Assistance Title</td></tr><table><tr><td style="vertical-align: top; padding-top: 1.05em;"><div style="text-indent: 1.25em;">1.</div></td><td><p>指派專責會計人員</p><p style="text-indent: 2em;">為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。</p></td></tr></table></div><table><tr style="break-inside: avoid-page;"><td style="vertical-align: top; padding-top: 1.05em;"><div style="text-indent: 1.25em;">2.</div></td><td><p>網路銀行申請</p><p style="text-indent: 2em;">為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)</p></td></tr><tr style="break-inside: avoid-page;"><td style="vertical-align: top; padding-top: 1.05em;"><div style="text-indent: 1.25em;">3.</div></td><td><p>配合及時提供相關資訊</p><p style="text-indent: 2em;">為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。</p></td></tr></table>
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
    #expect(note.render() == "<table><tr style=\"break-inside: avoid-page;\"><td style=\"width: 3rem;vertical-align: top;\">註一：</td><td><div><div>\(contents[0])</div></div></td></tr><tr style=\"break-inside: avoid-page;\"><td style=\"width: 3rem;vertical-align: top;\">註二：</td><td><div><div>\(contents[1].components(separatedBy: "\n")[0])</div><div>\(contents[1].components(separatedBy: "\n")[1])</div><div>\(contents[1].components(separatedBy: "\n")[2])</div><div>\(contents[1].components(separatedBy: "\n")[3])</div></div></td></tr><tr style=\"break-inside: avoid-page;\"><td style=\"width: 3rem;vertical-align: top;\">註三：</td><td><div><div>\(contents[2])</div></div></td></tr></table>")
    
}



@Test func createReplyForm(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
    let paymentItems: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], price: "5,000", billingPeriod: BillingPeriod.yearly.description),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], price: "6,000", billingPeriod: BillingPeriod.monthly13.description)
    ]
    let additionalServices: [AdditionalService] = [
        AdditionalService(name: "代辦年度CTP申報(每年3月；加收2,000元/家)", isSelected: false),
        AdditionalService(name: "二代健保申報作業", isSelected: true) 
    ]
    let quotationNo = "111112101"

    let replyForm = ReplyForm(receiver: receiver, sender: sender, subject: subject, paymentItems: paymentItems, additionalServices: additionalServices, quotationNo: quotationNo)
    #expect(replyForm.render() == """
<h2 style="text-align: center;">同意函</h2><table style="width: 100%;"><tr><td style="width: 70px; white-space: nowrap; vertical-align: top">受文者：</td><td>嘉威聯合會計師事務所</td></tr><tr><td style="white-space: nowrap; vertical-align: top">主　旨：</td><td>本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。</td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top">酬　金：</td></tr><tr><td></td><td><table style="font-size: 14px; width: 100%; border-collapse: separate; border-spacing: 0.2em;"><tr><td style="vertical-align: middle;">(1)</td><td style="vertical-align: middle; width: 100%;"><div>民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證</div></td><td><div style="text-align: right; white-space: nowrap;">5,000 元/年</div></td></tr><tr><td style="vertical-align: middle;">(2)</td><td style="vertical-align: middle; width: 100%;"><div>會計帳務處理作業（113 年 5 月開始）</div></td><td><div style="text-align: right; white-space: nowrap;">6,000 元/月</div></td></tr></table></td></tr><tr><td></td><td style="white-space: nowrap; vertical-align: top;">附加服務請勾選：</td></tr><tr style="font-size: 14px;"><td></td><td>□代辦年度CTP申報(每年3月；加收2,000元/家)</td></tr><tr style="font-size: 14px;"><td></td><td>☑二代健保申報作業</td></tr><tr><td>附　件：</td><td>嘉威稅字第111112101號公費報價單</td></tr></table><br/><table style="width: 100%;"><tr><td style="width: 102px;"></td><td>全家人健康事業股份有限公司</td><td style="width: 10rem;"></td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（公　司　章）　　</td></tr><tr><td></td><td></td><td style="height: 6rem;vertical-align: top;">（授權人簽名或蓋章）</td></tr></table>
""")
}



@Test func createContractHeader(){
    let receiver = "全家人健康事業股份有限公司"
    let sender = "88183980"
    let subject = "承 貴公司委任本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務，至深感荷。謹將服務內容及酬金等分別說明如後，敬請卓察賜覆為禱。"
    let description = "感謝 貴公司對本事務所的支持與愛護，本事務所本著積極服務顧客的熱忱，以及專業智慧的多元服務，特將本事務所受託辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務內容概述如後，期盼此項合作能協助 貴公司提升會計帳務品質，俾能符合相關稅務法令和企業會計準則之規定。茲將委任之目的、服務範圍、 貴公司協助事項、酬金、權利義務事項及同意函列示如下："
    
    let contractHeader = ContractHeader(receiver: receiver, sender: sender, subject: subject, content: description)
    #expect(contractHeader.render() == """
    <table style="margin: 2rem 2rem 3rem 2rem;"><tr><td style="vertical-align: top; width: 6em;">受 文 者：</td><td>\(receiver)（以下簡稱 貴公司）</td></tr><tr><td style="vertical-align: top;">發 文 者：</td><td>\(contractHeader.sender.displayName)（以下簡稱 本事務所）</td></tr><tr><td style="vertical-align: top;">主    旨：</td><td>\(subject)</td></tr><tr><td style="vertical-align: top;">說    明：</td><td>\(description)</td></tr></table>
    """)
}
