import Testing
@testable import HandoverDocumentHTML

// 新版（雙欄）訪談表比照舊版的調整（2026-11-03）：客戶來源加細節說明、統購區塊加憑證收發需求。

@Test func maintenanceInfoRendersSourceDetailBelowSource() {
    let html = MaintenanceInfoSection(familiarPersons: [], source: "員工介紹（王小明）", sourceDetail: "原本是王小明的大學同學\n第二行", interviewers: []).render()

    #expect(html.contains("員工介紹（王小明）"))
    #expect(html.contains("sourceDetail"))
    #expect(html.contains("第二行"))
    guard let sourceIndex = html.range(of: "員工介紹（王小明）")?.lowerBound,
          let detailIndex = html.range(of: "原本是王小明的大學同學")?.lowerBound else {
        Issue.record("來源與細節說明都應印出")
        return
    }
    #expect(sourceIndex < detailIndex)
}

@Test func maintenanceInfoOmitsSourceDetailWhenAbsent() {
    let html = MaintenanceInfoSection(familiarPersons: [], source: "客戶介紹（陳大文）", interviewers: []).render()

    #expect(!html.contains("class=\"sourceDetail\""))
}

@Test func evidenceInfoRendersDeliveryMethodBeforePurchase() {
    let html = EvidenceInfoSection(deliveryMethod: "由事務所派人收件", purchaseArrangementType: "客戶自行購買").render()

    guard let deliveryIndex = html.range(of: "憑證收發需求")?.lowerBound,
          let purchaseIndex = html.range(of: "統購需求")?.lowerBound else {
        Issue.record("憑證收發需求與統購需求都應印出")
        return
    }
    #expect(html.contains("由事務所派人收件"))
    #expect(deliveryIndex < purchaseIndex)
}

// 專營投資業不問統購（OC ADR 2026-11-investment-only-skips-business-tax-fields）：
// 呼叫端傳 nil → 統購整段不印，憑證收發需求照印。
@Test func evidenceInfoOmitsPurchaseWhenArrangementIsNil() {
    let html = EvidenceInfoSection(deliveryMethod: "由事務所派人收件", purchaseArrangementType: nil).render()

    #expect(html.contains("憑證收發需求"))
    #expect(html.contains("由事務所派人收件"))
    #expect(!html.contains("統購需求"))
    #expect(!html.contains("統購開始期別"))
}

@Test func evidenceInfoOmitsDeliveryMethodWhenNil() {
    let html = EvidenceInfoSection(purchaseArrangementType: "客戶自行購買").render()

    #expect(!html.contains("憑證收發需求"))
}
