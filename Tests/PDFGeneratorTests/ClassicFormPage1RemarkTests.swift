import Testing
@testable import HandoverDocumentHTML

// 第 1 頁備註區的開始服務時間：沒有值（沒買記帳）時整行不印，有值照印。

@Test func classicFormPage1PrintsServiceStartDate() {
    let html = ClassicFormPage1(model: .init(companyName: "範例股份有限公司", serviceStartDate: "設立完成後開始")).render()

    #expect(html.contains("開始服務時間：設立完成後開始"))
}

@Test func classicFormPage1OmitsServiceStartDateLineWhenNil() {
    let html = ClassicFormPage1(model: .init(companyName: "範例股份有限公司", serviceStartDate: nil)).render()

    #expect(!html.contains("開始服務時間"))
}
