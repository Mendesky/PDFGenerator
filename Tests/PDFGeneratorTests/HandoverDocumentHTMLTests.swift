import Testing
import Plot
import Foundation
@testable import HandoverDocumentHTML

@Test func billingPeriodLongText() {
    #expect(BillingPeriod.oneTime.text == "次")
    #expect(BillingPeriod.yearly.text == "年")
    #expect(BillingPeriod.monthly11.text == "月 ( 11 個月 )")
    #expect(BillingPeriod.monthly12.text == "月 ( 12 個月 )")
    #expect(BillingPeriod.monthly13.text == "月 ( 13 個月 )")
    #expect(BillingPeriod.monthly14.text == "月 ( 14 個月 )")
}

@Test func additionalServiceBlockRendersServicesAndPrice() {
    let block = AdditionalServiceBlock(units: [
        .init(services: ["代辦年度CTP申報", "二代健保申報作業"], billingPeriod: .yearly, price: 16000)
    ])
    let html = block.render()
    #expect(html.contains("附加服務"))
    #expect(html.contains("代辦年度CTP申報"))
    #expect(html.contains("二代健保申報作業"))
    #expect(html.contains("16,000"))
    #expect(html.contains("元 / 年"))
}

@Test func additionalServiceBlockRendersDashWhenEmpty() {
    let block = AdditionalServiceBlock(units: [])
    #expect(block.render().contains(">-<"))
}

@Test func quotingBundleBlockSingleBundleHidesBundleName() {
    let block = QuotingBundleBlock(bundles: [
        .init(name: "BundleA", units: [
            .init(billingPeriod: .monthly12, price: 5000, services: [
                .init(alias: "記帳服務", items: [.init(configs: [.init(name: "開始月份", value: "113年5月")])])
            ])
        ])
    ])
    let html = block.render()
    #expect(!html.contains("BundleA"))
    #expect(html.contains("記帳服務"))
    #expect(html.contains("開始月份"))
    #expect(html.contains("113年5月"))
    #expect(html.contains("5,000"))
    #expect(html.contains("元 / 月 ( 12 個月 )"))
}

@Test func quotingBundleBlockMultipleBundlesShowNames() {
    let block = QuotingBundleBlock(bundles: [
        .init(name: "BundleA", units: []),
        .init(name: "BundleB", units: [])
    ])
    let html = block.render()
    #expect(html.contains("BundleA"))
    #expect(html.contains("BundleB"))
}

@Test func handoverDocumentRendersTwoColumnWithQuotingSections() {
    let doc = HandoverDocument(
        header: .init(companyName: "測試公司"),
        focusItems: [
            .init(leftText: "帳務類型", value: "範例值")
        ],
        leftSections: [
            QuotingBundleBlock(bundles: [
                .init(name: "B", units: [
                    .init(billingPeriod: .yearly, price: 12000, services: [
                        .init(alias: "稅務簽證", items: [])
                    ])
                ])
            ]),
            AdditionalServiceBlock(units: [
                .init(services: ["二代健保"], billingPeriod: .yearly, price: 2000)
            ])
        ],
        rightSections: [
            DesignatedInfoSection(items: [
                .init(title: "客戶指定", strongInfoTitle: "簽證會計師", value: "無")
            ])
        ]
    )
    let html = doc.render()
    #expect(html.contains("測試公司"))
    #expect(html.contains("帳務類型"))   // focus bar 已整合
    #expect(html.contains("範例值"))
    #expect(html.contains("稅務簽證"))
    #expect(html.contains("12,000"))
    #expect(html.contains("附加服務"))
    #expect(html.contains("二代健保"))
    #expect(html.contains("簽證會計師"))  // 右欄 section 已整合
    #expect(html.contains("contentContainer"))
    #expect(html.contains("focusBar"))
    #expect(html.contains("<style"))      // 集中式 stylesheet 已內嵌
    #expect(html.contains("font-size: 12px"))
}

@Test func focusItemBarRendersLabelAndValue() {
    let bar = FocusItemBar(items: [
        .init(leftText: "帳務類型", value: "範例值A"),
        .init(leftText: "申報行代", rightText: "000000", boldSide: .right, value: "範例值B")
    ])
    let html = bar.render()
    #expect(html.contains("focusBar"))
    #expect(html.contains("帳務類型"))
    #expect(html.contains("範例值A"))
    #expect(html.contains("申報行代"))
    #expect(html.contains("000000"))
    #expect(html.contains("範例值B"))
    #expect(html.contains("value"))
}

@Test func designatedInfoSectionRendersTitleStrongAndValue() {
    let section = DesignatedInfoSection(items: [
        .init(title: "客戶指定", strongInfoTitle: "簽證會計師", value: "無"),
        .init(title: "客戶指定", strongInfoTitle: "服務組別", value: "範例組別")
    ])
    let html = section.render()
    #expect(html.contains("designatedInfo"))
    #expect(html.contains("客戶指定"))
    #expect(html.contains("簽證會計師"))
    #expect(html.contains("無"))
    #expect(html.contains("服務組別"))
    #expect(html.contains("範例組別"))
}

@Test func maintenanceInfoSectionRendersStaffSourceAndInterviewers() {
    let section = MaintenanceInfoSection(
        familiarPersons: [.init(firmName: "範例所", department: "CPA", name: "陳ＯＯ")],
        source: "客戶介紹",
        interviewers: [.init(firmName: "範例所", department: "審一", name: "林ＯＯ")]
    )
    let html = section.render()
    #expect(html.contains("maintenanceInfo"))
    #expect(html.contains("熟悉人員/會計師"))
    #expect(html.contains("範例所"))
    #expect(html.contains("陳ＯＯ"))
    #expect(html.contains("客戶來源"))
    #expect(html.contains("客戶介紹"))
    #expect(html.contains("訪談人"))
    #expect(html.contains("林ＯＯ"))
}

@Test func contactSectionRendersContactsAndCompanyInfo() {
    let section = ContactSection(
        contacts: [
            .init(name: "詹ＯＯ", gender: "小姐", relationship: "會計", methods: [
                .init(title: "市內電話", values: ["(00)0000000"]),
                .init(title: "Email", values: ["sample@example.com"])
            ])
        ],
        establishedDate: "111 年 02 月 14 日",
        telephones: ["(00)0000000"],
        faxes: [],
        registeredAddress: "範例登記地址",
        communicationAddress: "範例通訊地址"
    )
    let html = section.render()
    #expect(html.contains("contactInfo"))
    #expect(html.contains("聯絡人資料"))
    #expect(html.contains("詹ＯＯ"))
    // 職位（relationship）排在姓名前面
    #expect(html.range(of: "會計")!.lowerBound < html.range(of: "詹ＯＯ")!.lowerBound)
    #expect(html.contains("市內電話"))
    #expect(html.contains("sample@example.com"))
    #expect(html.contains("核准設立日期"))
    #expect(html.contains("公司電話"))
    #expect(html.contains("公司傳真"))
    #expect(html.contains("公司登記地址"))
    #expect(html.contains("範例通訊地址"))
}

@Test func evidenceInfoSectionRendersArrangementAndCounts() {
    let section = EvidenceInfoSection(
        purchaseArrangementType: "由事務所統購",
        purchaseStartDate: "115 年 09 月",
        counts: [
            .init(text: "二聯式", value: "-", unit: "本"),
            .init(text: "二聯式加副聯", value: "1", unit: "本")
        ]
    )
    let html = section.render()
    #expect(html.contains("evidenceInfo"))
    #expect(html.contains("統購需求"))
    #expect(html.contains("由事務所統購"))
    #expect(html.contains("統購開始期別"))
    #expect(html.contains("115 年 09 月"))
    #expect(html.contains("二聯式加副聯"))
}

@Test func evidenceInfoSectionHidesCountsWhenNoStartDate() {
    let section = EvidenceInfoSection(purchaseArrangementType: "-")
    let html = section.render()
    #expect(html.contains("統購需求"))
    #expect(!html.contains("統購開始期別"))
}

@Test func preserviceOrgSectionRendersValueAndLabels() {
    let section = PreserviceOrgSection(items: [
        .init(title: "前所名稱", value: "-"),
        .init(title: "前所服務業務", labels: ["記帳", "年度CTP"]),
        .init(title: "前所資訊及更換原因", labels: ["範例原因"])
    ])
    let html = section.render()
    #expect(html.contains("preserviceOrg"))
    #expect(html.contains("前所名稱"))
    #expect(html.contains("前所服務業務"))
    #expect(html.contains("記帳"))
    #expect(html.contains("年度CTP"))
    #expect(html.contains("範例原因"))
}

@Test func operationInfoSectionRendersGroupsAndUnits() {
    let section = OperationInfoSection(groups: [
        .init(direction: .horizontal, units: [
            .init(title: "扣繳人數", text: "1~10人"),
            .init(title: "分支機構家數", text: "0家")
        ]),
        .init(direction: .vertical, units: [
            .init(title: "營業項目及產品", text: "範例產品")
        ])
    ])
    let html = section.render()
    #expect(html.contains("operationInfo"))
    #expect(html.contains("扣繳人數"))
    #expect(html.contains("1~10人"))
    #expect(html.contains("分支機構家數"))
    #expect(html.contains("營業項目及產品"))
    #expect(html.contains("範例產品"))
}

@Test func interviewInfoSectionRendersTitleAndDescriptionWithLineBreaks() {
    let section = InterviewInfoSection(items: [
        .init(title: "未來預期及追蹤事項", description: "第一行\n第二行"),
        .init(title: "其他需注意事項", description: nil)
    ])
    let html = section.render()
    #expect(html.contains("interviewInfo"))
    #expect(html.contains("未來預期及追蹤事項"))
    #expect(html.contains("第一行"))
    #expect(html.contains("第二行"))
    #expect(html.contains("<br"))   // 換行轉 <br>
    #expect(html.contains("其他需注意事項"))
    #expect(html.contains(">-<"))   // nil description 顯示 -
}

@Test func interviewInfoSectionRendersMarkdown() {
    let section = InterviewInfoSection(items: [
        .init(title: "客戶背景概況", description: "- 第一點\n- 第二點"),
        .init(title: "其他需注意事項", description: "**重點**內容")
    ])
    let html = section.render()
    #expect(html.contains("<ul>"))
    #expect(html.contains("<li>"))
    #expect(html.contains("第一點"))
    #expect(html.contains("第二點"))
    #expect(html.contains("<strong>"))
    #expect(html.contains("重點"))
}

@Test func relatedBusinessSectionRendersBlocksAndCompanies() {
    let section = RelatedBusinessSection(blocks: [
        .init(title: "持股關係", companies: [
            .init(businessId: "00000000", name: "範例關係企業", serviceEmployee: "範例組別 林ＯＯ", description: "範例說明")
        ])
    ])
    let html = section.render()
    #expect(html.contains("relatedBusiness"))
    #expect(html.contains("關係企業清單"))
    #expect(html.contains("持股關係"))
    #expect(html.contains("00000000"))
    #expect(html.contains("範例關係企業"))
    #expect(html.contains("林ＯＯ"))
    #expect(html.contains("範例說明"))
    #expect(html.contains("employeeIcon"))   // 服務人員 badge 前的小 icon
}

@Test func relatedBusinessDescriptionRendersMarkdown() {
    let section = RelatedBusinessSection(blocks: [
        .init(title: "持股關係", companies: [
            .init(businessId: "00000000", name: "範例公司", serviceEmployee: nil, description: "**重點**說明")
        ])
    ])
    let html = section.render()
    #expect(html.contains("<strong>"))
    #expect(html.contains("重點"))
}

@Test func relatedBusinessSectionShowsDashWhenEmpty() {
    let section = RelatedBusinessSection(blocks: [
        .init(title: "持股關係", companies: [])
    ])
    let html = section.render()
    #expect(html.contains("關係企業清單"))
    #expect(html.contains(">-<"))
}

@Test func relatedBusinessSectionShowsNonClientWhenNoServiceEmployee() {
    let section = RelatedBusinessSection(blocks: [
        .init(title: "持股關係", companies: [
            .init(businessId: "00000000", name: "範例關係企業", serviceEmployee: nil, description: "範例說明")
        ])
    ])
    let html = section.render()
    #expect(html.contains("非所客"))
}

@Test func documentHeaderRendersCardLayout() {
    let header = DocumentHeader(model: .init(
        companyName: "範例股份有限公司",
        businessId: "00000000",
        representative: "王ＯＯ",
        dealDate: "115/06/17",
        shareToken: "OOOOOOOO",
        externalURL: "http://www.google.com",
        internalURL: "http://www.google.com"
    ))
    let html = header.render()
    #expect(!html.contains("新客戶訪談紀錄表"))   // 標題已移除
    #expect(html.contains("範例股份有限公司"))
    #expect(html.contains("00000000"))
    #expect(html.contains("王ＯＯ"))
    #expect(html.contains("115/06/17"))
    #expect(html.contains("成交日期"))
    #expect(html.contains("OOOOOOOO"))
    // 卡片式版面的結構 class（對齊 Frontend header.component）
    #expect(html.contains("printHeader"))
    #expect(html.contains("companyContainer"))
    // 外網/內網連結
    #expect(html.contains("外網連結"))
    #expect(html.contains("內網連結"))
    #expect(html.contains("href=\"http://www.google.com\""))
    // logo 改用事務所圖檔（取代文字佔位）
    #expect(html.contains("<img"))
    #expect(html.contains("header_logo"))
    // QR code（由外網連結生成）+ 分享碼於下方
    #expect(html.contains("qrImage"))
    #expect(html.contains("<svg"))
}
