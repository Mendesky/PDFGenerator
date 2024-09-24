import Testing
import Plot
import Foundation
@testable import Quotation

@Test func createLetterHTML() {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    let to = "Jane Doe"
    let from = "John Doe"
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
    
    #expect(letter.render() == "<table><tr><td>TO:</td><td>\(to)</td></tr><tr><td>FROM:</td><td>\(from)</td></tr><tr><td colspan=\"2\"><hr/>\(content)</td></tr><tr><td colspan=\"2\">　　\(blessings)</td></tr><tr><td colspan=\"2\" dir=\"rtl\">\(from)<br/>\(testingDateString)</td></tr></table>")
}


@Test func createContentItemHtml(){
    let title = "Quotation Purpose"
    let content = "This is a description of the Purpose."
    
    let contentItem = ContentItem(title: title, content: content)
    
    #expect(contentItem.render() == "<table><tr><td>\(title)</td></tr><tr><td>\(content)</td></tr></table>")
    
}





@Test func createServiceScopeItemTermHtml(){
    let term = "This is a Term string."
    
    let serviceScopeItem = ServiceScopeItemTerm(term: term)
    
    #expect(serviceScopeItem.render() == "<li>\(term)</li>")
}


@Test func createServiceScopeItemHtml(){
    let title = "Quotation Purpose"
    let content = "This is a description of the Purpose."
    let termStrings = ["Term1", "Term2"]
    
    let terms = termStrings.map{ ServiceScopeItemTerm(term: $0) }
    
    let serviceItemScopeItem = ServiceScopeItem(title: title, content: content, terms: terms)
    
    #expect(serviceItemScopeItem.render() == "<p>\(title)</p><p>\(content)</p><ol><li>\(termStrings[0])</li><li>\(termStrings[1])</li></ol>")
    
}


@Test func createServiceScopeHtml(){
    let title = "Quotation Service Scope"
    let content = "This is a description of the Service Scope."
    let serviceScopeItems: [ServiceScopeItem] = [
        ServiceScopeItem(title: "ItemTitle", content: "ItemContent", termStrings: nil)
    ]
    
    let serviceScope = ServiceScope(title: title, content: content, items: serviceScopeItems)
    
    #expect(serviceScope.render() == "<p>\(title)</p><p>\(content)</p><ol><li>\(serviceScopeItems[0].render())</li></ol>")
}



@Test func createPaymentItemHtml(){
    let names: [String] = ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證", "二代健保暨表單彙總處理"]
    let price: String = "5,000"
    let billingPeriod: BillingPeriod = .monthly13
    
    let paymentItem = PaymentItem(names: names, price: price, billingPeriod: billingPeriod)
    
    #expect(paymentItem.render() == "<td>\(names.joined(separator: "\(Node.br().render())"))</td><td>\(price)</td><td>\(billingPeriod)</td>")
}





@Test func createPaymentHtml(){
    let title = "酬金"
    let items: [PaymentItem] = [
        .init(names: ["民國 113 年度之營利事業所得稅查核簽證與未分配盈餘查核簽證"], price: "5,000", billingPeriod: .yearly),
        .init(names: ["會計帳務處理作業（113 年 5 月開始）"], price: "6,000", billingPeriod: .monthly13)
    ]
    
    let paymentItem = Payment(title: title, items: items)
    
    #expect(paymentItem.render() == "<p>\(title)</p><table style=\"border-collapse: collapse;\"><tr style=\"border-bottom: 1pt solid black;\"><td></td><td>服務項目</td><td>公費金額</td><td></td></tr><tr><td>(1)</td>\(items[0].render())</tr><tr><td>(2)</td>\(items[1].render())</tr></table>")
}




@Test func createBusinessClientAssistance(){
    let title = "Assistance Title"
    let items: [ContentItem] = [
        ContentItem(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
        ContentItem(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
        ContentItem(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
    ]
    
    let assistance = BusinessClientAssistance(title: title, items: items)
    
    #expect(assistance.render() == "<p>\(title)</p><ol><li>\(items[0].render())</li><li>\(items[1].render())</li><li>\(items[2].render())</li></ol>")
    
}



