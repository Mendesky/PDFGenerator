//
//  main.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2024/9/23.
//
import Foundation
import QuotationHTML
import HandoverDocumentHTML
import Plot
import PDFGenerator


let purpose: Purpose.Model? = .init(title: "目的", content: "貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，以協助　貴公司提升整體會計帳務品質，並符合相關稅務法令和企業會計準則等之規定。")


let lettetHeader = LetterHeader.Model(to: "全家人健康事業股份有限公司", from: "嘉威聯合會計師事務所", content: "茲將附上全家人健康事業股份有限公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務公費報價單。 我們希望以最專業多元的服務與 貴公司長久配合，公費內容若經確認，煩請將最後一頁同意函簽章並回傳至敝事務所（FAX：2299-9901），謝謝您的合作。", date: Date(), blessings: "順頌 商祺")

//print(lettetHeader.render())


//print(purpose.render())
//
//print("\n")
let scope = ServiceScope.Model(title: "服務範圍及內容", heading: "本項專案作業之服務範圍將根據相關稅務法令、企業會計準則與會計師查核簽證準則之規定，由  貴公司委託本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務，俾能符合相關法令規定與提升整體會計帳務品質。具體服務事項如下：", items: [
    QuotingServiceTerm.Model(title: "營利事業所得稅查核簽證", term: "營利事業所得稅查核簽證主要係包括執行營利事業所得稅結算申報程序及依照「所得稅法」規定進行會計師查核簽證作業。營利事業所得稅查核簽證主要係包括執行營利事業所得稅結算申報程序及依照「所得稅法」規定進行會計師查核簽證作業。", serviceItemTerms: [
        .init(content: "平時稅務會計帳務作業，包括:憑證整理、\n傳票登打、\n相關帳簿與財務報表之編製。\n(1) xxx報表\n(2) YYY報表"),
        .init(content: "資金流程作業。"),
        .init(content: "成本表編製作業。"),
        .init(content: "成本表編製作業。"),
        .init(content: "成本表編製作業。"),
        .init(content: "成本表編製作業。"),
        .init(content: "成本表編製作業。"),
    ])
])
//print(scope.render())


//print("\n")

let assistance = BusinessClientAssistance.Model(title: "貴公司之協助辦理事項", items: [
    .init(title: "指派專責會計人員", content: "為期本專業服務能順利完成，爰建議  貴公司應指派熟悉公司會計作業流程之人員，以作為與本事務所溝通協調及對內對外之窗口。"),
    .init(title: "網路銀行申請", content: "為方便本事務所執行出納事務，故請 貴公司配合申請網路銀行，以利運作順暢。(請提供編輯與審核帳號各一組)"),
    .init(title: "配合及時提供相關資訊", content: "為順利達成上述服務，委任人應提供相關之會計資訊、文件及憑證等，供受任人審閱，並答覆有關問題之詢問。委任人會計人員應對財會委外工作儘量協助，此項協助包括憑證蒐集、對帳、提供有關文件資料、相關問題詢問等；至於其具體配合事項，將由受任人之服務人員於工作開始前，提供應備資料清單，商請委任人有關人員惠予配合。")
])

//print(assistance.render())


//print("\n")
let paymentItems: [PaymentItem.Model] = [
    .init(names: ["工商登記處理作業(資本額200萬元)(台中市)(不含動資查核)(股東3人)"], fee: .oneTime(16000)),
    .init(names: ["會計帳務及稅務申報處理作業-書審 (設立完成後開始)"], fee: .oneTime(0)),
    .init(names: ["附設補習班-會計帳務及其稅務申報處理作業-書審(設立完成後開始)"], fee: .monthly(1000))
]
let paymentItems2: [PaymentItem.Model] = [
    .init(names: ["會計帳務處理作業（113 年 5 月開始）"], fee: .monthly(5000)),
]


let payments:[Payment.Model] = [
    Payment.Model(name: "財務會計委外作業(112 年度)", items: paymentItems, needShowName: true),
    Payment.Model(name: "財務會計委外作業(113 年度)", items: paymentItems, needShowName: true)
]

let contents: [String] = [
    """
    工商登記費用不包含政府規費及代墊雜項費用，服務公費及代墊費用請於辦理完成時支付。
    如股東超過5人，第6位起每位加收新台幣500元之防制洗錢查核費。    
    """,
    """
    會計帳務處理作業依照預估年營收計500萬元報價，年營收每增加1,000萬元，公費增加
    500元/月。
    會計帳務處理作業費用一年以十四個月計算，並請於單月份月底前支付前兩個月之公
    費。
    """,
    """
    附加服務選項：代辦年度 CTP 申報(每年 3 月)，依據公司法增訂第 22 條之 1 是為了
    配合洗錢防制政策，協助建置完善洗錢防
    制體制，強化洗錢防制作為，以增加法人(公司)之透明度，並有效掌握公司負責人(董
    事、監察人及經理人)及主要股東(持有超過 10%股份或出資額股東)之持股或出資額。    
    """,
    """
    本事務所將依據 貴公司所提供之資料及文件，利用會計專業知識蒐集、分類及彙總財務
    資訊，進而提供會計帳務處理作業服務項目，無須對資訊加以查核或核閱，所提供之財
    務資訊亦不提供任何程度之確信。    
    """,
    """
    本事務所所提供會計帳務處理作業服務，僅限協助 貴公司完成相關專業服務使用。除本
    事務所有可歸責之情形外，如本事務所於本報價單意旨提供會計帳務處理作業服務事
    項，而遭致第三人向本事務所為法律上之主張而致生損害時， 貴公司同意負責補償。另
    未經本事務所書面同意，本事務所所提供之服務不得提供他人使用(其中不包含提供予股
    東開會使用)；且若有此種情形致他人權益受損，本事務所不負任何責任。    
    """,
    """
    採查帳申報(非稅簽案件)當年度若需協助國稅局營所稅查核，將另與 貴公司討論服務
    費報價金額。    
    """,
    """
    最新稅務訊息通知及教育訓練免費參加本事務所將定期以電子郵件寄送最新稅務法令之
    變更、稅捐獎勵減免、會計審計學術專論等有關訊息供 貴公司參考。
    另外，本事務所將針對客戶之需要，開設不同財稅課程，對於本事務所之客戶將可免費
    參加，以使 貴公司與敝事務所共同成長。    
    """,
//    """
//    營利事業所得稅查核簽證包括營利事業所得稅結算申報及依「所得稅法」規定進行
//    查核簽證。
//    有關會計師稅務簽證之優點列舉如下：
//    1. 提高交際費限額，較普通申報案件高出 30%。
//    2. 享有盈虧互抵之優惠。
//    3. 降低國稅局抽查查帳比率，倘若有查帳情況將由本事務會計師親至國稅局處理之。
//    4. 未分配盈餘之課稅規定，其課稅所得額以會計師簽證之申報數為準，不須按核
//    定所得額計算。
//    """
    
]
let notes: [Note.Model] = contents.map{
    .init(content: $0)
}


let receiver = "全家人健康事業股份有限公司"
let sender = Organization.kd.rawValue
let subject = "本公司同意委託貴事務所執行本公司有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務項目及公費，請查照。"
let additionalServices: [AdditionalService.Model] = [
    .init(name: "代辦年度CTP申報(每年3月；加收2,000元/家)", isSelected: false),
    .init(name: "二代健保申報作業", isSelected: true)
]
let quotationNo = "111112101"

let replyForm = ReplyForm.Model.init(subject: subject, payments: payments, additionalServices: additionalServices, showCompanyStamp: false)


let contractSubject = "承 貴公司委任本事務所辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證暨財會委外處理作業之專業服務，至深感荷。謹將服務內容及酬金等分別說明如後，敬請卓察賜覆為禱。"
let content = "感謝 貴公司對本事務所的支持與愛護，本事務所本著積極服務顧客的熱忱，以及專業智慧的多元服務，特將本事務所受託辦理有關營利事業所得稅查核簽證與未分配盈餘查核簽證及財會委外處理作業之專業服務內容概述如後，期盼此項合作能協助 貴公司提升會計帳務品質，俾能符合相關稅務法令和企業會計準則之規定。茲將委任之目的、服務範圍、 貴公司協助事項、酬金、權利義務事項及同意函列示如下："
let contractHeader = ContractHeader.Model.init(subject: contractSubject, content: content)


let rightsAndObligations = ContractSection(title: "權利義務事項", heading: "本事務所將會依照現行法規的規範及符合專業慣例之基礎上提供上開服務：", provisions: [
    .init(term: "本事務所將依現行有效之法規，提供上開各項服務；就服務事項完辦後相關法規之變更、修正或廢止所導致之變動，應另行修正報價單之內容。"),
    .init(term: "本事務所將依據  貴公司所提供之資料及文件，利用會計專業知識蒐集、分類及彙總財務資訊，進而提供會計帳務處理作業服務項目，無須對資訊加以查核或核閱，所提供之財務資訊亦不提供任何程度之確信。"),
    .init(term: "本事務所所提供會計帳務處理作業服務，僅限協助 貴公司完成相關專業服務使用。除本事務所有可歸責之情形外，如本事務所於本報價單意旨提供會計帳務處理作業服務事項，而遭致第三人向本事務所為法律上之主張而致生損害時， 貴公司同意負責補償。另未經本事務所書面同意，本事務所所提供之服務不得提供他人使用(其中不包含提供予股東開會使用)；且若有此種情形致他人權益受損，本事務所不負任何責任。"),
    .init(term: "本事務所履行委任書所涉之服務事項，將本誠信履踐應有之注意義務，惟僅於經法院判決確定後，在本案已收受之服務公費範圍內負擔相關責任。"),
    .init(term: "本公司對 貴公司所提供之各項資料或相關文件，當盡保密之責。"),
    .init(term: "本委任書由 貴公司與本公司雙方各執一份。")
])


let quotation = AuditQuotation(no: quotationNo, receiver: receiver, sender: .kd, purpose: purpose, payments: payments, serviceScope: scope, letterHeader: lettetHeader, assistance: assistance, notes: notes, replyForm: replyForm, contractHeader: contractHeader, fontSize: 20)
let html = quotation.render()
let htmlUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test.html")
try html.write(to: htmlUrl, atomically: true, encoding: .utf8)

let generator = PDFGenerator(mainHtml: quotation, headerHtml: quotation.headerHTML, footerHtml: quotation.footerHTML)
//print(pdfData)




let pdfUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test.pdf")
if let pdfData = try? generator.generate() {
    try pdfData.write(to: pdfUrl)
}


// MARK: - 客戶訪談紀錄表（核心骨架 + 報價區塊）示範

let handover = HandoverDocument(
    header: .init(
        companyName: "範例股份有限公司",
        businessId: "00000000",
        representative: "王ＯＯ",
        dealDate: "115/06/17",
        shareToken: "OOOOOOOO",
        externalURL: "http://www.google.com",
        internalURL: "http://www.google.com"
    ),
    focusItems: [
        .init(leftText: "帳務類型", value: "稅務帳"),
        .init(leftText: "行業類別", value: "買賣業"),
        .init(leftText: "申報類型", value: "書審申報"),
        .init(leftText: "成本分析", value: "不適用"),
        .init(leftText: "申報行代", rightText: "000000", boldSide: .right, value: "範例行業"),
        .init(leftText: "記帳", rightText: "開始服務時間", boldSide: .left, value: "115年5月"),
        .init(leftText: "實收資本額", value: "2,000,000"),
        .init(leftText: "去年營業額", value: "10,000,000"),
        .init(leftText: "預估今年營業額", value: "10,000,000")
    ],
    leftSections: [
        QuotingBundleBlock(bundles: [
            .init(name: "財務會計委外作業", units: [
                .init(billingPeriod: .monthly14, price: 5000, services: [
                    .init(alias: "記帳服務", items: [
                        .init(configs: [
                            .init(name: "開始月份", value: "113 年 5 月"),
                            .init(name: "預估年營收", value: "500 萬元")
                        ])
                    ])
                ]),
                .init(billingPeriod: .yearly, price: 30000, services: [
                    .init(alias: "營所稅查核簽證", items: [
                        .init(configs: [.init(name: "年度", value: "113 年度")])
                    ])
                ])
            ]),
            .init(name: "工商登記作業", units: [
                .init(billingPeriod: .oneTime, price: 16000, services: [
                    .init(alias: "設立登記", items: [
                        .init(configs: [
                            .init(name: "資本額", value: "200 萬元"),
                            .init(name: "股東人數", value: "3 人")
                        ])
                    ])
                ])
            ])
        ]),
        AdditionalServiceBlock(units: [
            .init(services: ["代辦年度 CTP 申報"], billingPeriod: .yearly, price: 2000),
            .init(services: ["二代健保申報作業"], billingPeriod: .yearly, price: 1500)
        ]),
        OperationInfoSection(groups: [
            .init(direction: .horizontal, units: [
                .init(title: "扣繳人數", text: "1~10人"),
                .init(title: "分支機構家數", text: "0家")
            ]),
            .init(direction: .vertical, units: [
                .init(title: "營業項目及產品", text: "範例產品")
            ])
        ]),
        InterviewInfoSection(items: [
            .init(title: "未來預期及追蹤事項", description: "範例追蹤事項第一行\n範例追蹤事項第二行"),
            .init(title: "客戶背景概況", description: "- 範例背景第一點\n- 範例背景第二點\n- 範例背景第三點"),
            .init(title: "客戶營運現況", description: "**重點**：範例營運現況說明"),
            .init(title: "其他需注意事項", description: nil)
        ]),
        RelatedBusinessSection(blocks: [
            .init(title: "持股關係", companies: [
                .init(businessId: "00000000", name: "範例關係企業有限公司", serviceEmployee: "範例組別 林ＯＯ", description: "**股權結構**：\n- 範例股東持股 60%\n- 其餘為範例法人")
            ])
        ])
    ],
    rightSections: [
        DesignatedInfoSection(items: [
            .init(title: "客戶指定", strongInfoTitle: "簽證會計師", value: "無"),
            .init(title: "客戶指定", strongInfoTitle: "服務組別", value: "範例組別 審3")
        ]),
        MaintenanceInfoSection(
            familiarPersons: [.init(firmName: "範例所", department: "CPA", name: "陳ＯＯ")],
            source: "客戶介紹",
            interviewers: [.init(firmName: "範例所", department: "CPA", name: "陳ＯＯ")]
        ),
        ContactSection(
            contacts: [
                .init(name: "詹ＯＯ", gender: "小姐", relationship: "會計", methods: [
                    .init(title: "市內電話", values: ["(00)0000000"]),
                    .init(title: "Email", values: ["sample@example.com"])
                ])
            ],
            establishedDate: "111 年 02 月 14 日",
            telephones: ["(00)0000000"],
            faxes: [],
            registeredAddress: "範例市範例區範例路 0 號",
            communicationAddress: "範例市範例區範例路 0 號"
        ),
        EvidenceInfoSection(
            purchaseArrangementType: "由事務所統購",
            purchaseStartDate: "115 年 09 月",
            counts: [
                .init(text: "二聯式", value: "-", unit: "本"),
                .init(text: "二聯式加副聯", value: "1", unit: "本"),
                .init(text: "三聯式", value: "-", unit: "本"),
                .init(text: "三聯式加副聯", value: "1", unit: "本"),
                .init(text: "特種計稅", value: "-", unit: "本"),
                .init(text: "二聯式收銀機", value: "-", unit: "卷"),
                .init(text: "三聯式收銀機", value: "-", unit: "盒"),
                .init(text: "三聯式加副聯收銀機", value: "-", unit: "盒")
            ]
        ),
        PreserviceOrgSection(items: [
            .init(title: "前所名稱", value: "-"),
            .init(title: "前所費用", value: "-"),
            .init(title: "前所服務業務", labels: ["記帳", "年度CTP"]),
            .init(title: "前所資訊及更換原因", labels: ["範例原因"])
        ])
    ]
)

let handoverHtml = handover.render()
let handoverHtmlUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test-handover.html")
try handoverHtml.write(to: handoverHtmlUrl, atomically: true, encoding: .utf8)

let handoverGenerator = PDFGenerator(mainHtml: handover, headerHtml: handover.headerHTML)
let handoverPdfUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test-handover.pdf")
// logo 走每頁固定 running header；上邊距由 header 高度自動讓出，extraVerticalMargin 只補 header 與內文間距
if let handoverPdfData = try? handoverGenerator.generate(sideMargin: 1.5, extraVerticalMargin: 16) {
    try handoverPdfData.write(to: handoverPdfUrl)
}


// MARK: - 舊版風格訪談紀錄表（ClassicHandoverDocument）示範

let classicPage1 = ClassicFormPage1.Model(
    contactDate: nil,                 // 新版無來源 → 空格
    confirmDate: "115.06.17",
    interviewers: "陳ＯＯ、林ＯＯ",
    companyName: "範例股份有限公司",
    representative: "王ＯＯ",
    contacts: [
        .init(name: "詹ＯＯ", relationship: "會計", phone: "(00)0000000", mobile: "0900-000-000", email: "sample@example.com"),
        .init(name: "王ＯＯ", relationship: "負責人", mobile: "0911-111-111")
    ],
    businessId: "00000000",
    revenue: "1,000 萬以內",
    capital: "2,000,000",
    industryCode: "範例代碼",
    registeredPostcode: "100",
    registeredAddress: "範例市範例區範例路 0 號",
    communicationPostcode: nil,
    communicationAddress: nil,
    products: "範例產品",
    source: "客戶介紹（範例）",
    designatedCpa: "無",
    industryChoices: [("買賣", true), ("製造", false), ("營建", false), ("其它", false)],
    costAnalysisChoices: [("要", false), ("依法", true)],
    filingChoices: [("簽證", false), ("所得額", false), ("查帳", false), ("書審", true)],
    serviceChoices: [
        ("稅簽", true), ("財簽", false), ("記帳(稅)", true), ("記帳(管)", false),
        ("年度CTP", true), ("整帳", false), ("工商", false), ("出納", true), ("薪資人力", false)
    ],
    invoiceChoices: [
        ("電子發票", false), ("二聯(副)", true), ("三聯(副)", true),
        ("二收", false), ("三收(副)", false)
    ],
    previousFirmServices: "記帳、年度CTP",
    previousFirmChangeReason: "服務不好",
    clientNotesSummary: "公費請詳報價單；詳細追蹤事項見補充頁。",
    relatedBusinessSummary: "持股關係 1 家，詳補充頁。",
    bookkeepingFee: "14 個月：5,000 元",
    tidyingFee: "優惠免收",
    ctpFee: "2,000 元",
    taxAuditFee: "30,000 元",
    financialAuditFee: nil,
    individualIncomeTaxFee: nil,
    payrollFee: nil,
    cashierFee: nil,
    nhiFee: nil,
    serviceGroup: "範例組別 陳ＯＯ",
    serviceStartDate: "115 年 5 月"
)

let classic = ClassicHandoverDocument(
    page1: classicPage1,
    page2Sections: [
        .init(label: "報價", rows: [
            .heading("▼ 財務會計委外作業"),
            // 服務名 + 公費同列；設定以 - 條列於其下（跨欄）
            .field("服務項目", "記帳服務 $5,000 元 / 月 ( 14 個月 )"),
            .full("- 開始月份 115 年 5 月\n- 預估年營收 1,000 萬元"),
            .field("服務項目", "營所稅查核簽證 $30,000 元 / 年"),
            .full("- 年度 115 年度")
        ]),
        .init(label: "附加服務", rows: [
            .full("代辦年度 CTP 申報 $2,000 元 / 年")
        ]),
        .init(label: "營運資訊", rows: [
            // 扣繳人數／分支機構家數 同一列；營業項目及產品已在第 1 頁，不重複
            .pairs([("扣繳人數", "1~10人"), ("分支機構家數", "0家")])
        ]),
        .init(label: "訪談紀錄", rows: [
            .markdown("未來預期及追蹤事項", "範例追蹤事項一\n範例追蹤事項二"),
            .markdown("客戶背景概況", "### 概況\n1. **背景**\n2. <span style=\"color:#3a9ccd\">營業</span>"),
            .markdown("客戶營運現況", "範例營運現況")
        ]),
        .init(label: "關係企業", rows: [
            .heading("持股關係（1）"),
            .field("統一編號", "00000000"),
            .field("公司名稱", "範例關係企業有限公司"),
            .field("服務人員", "範例組別 林ＯＯ"),
            .field("關係說明", "範例關係說明")
        ]),
        .init(label: "統購", rows: [
            .field("統購需求", "由事務所統購"),
            .field("統購開始期別", "115 年 09 月"),
            // 各式發票張數併為一列
            .pairs([("二聯式", "-"), ("二聯式加副聯", "1 本"), ("三聯式", "-"), ("三聯式加副聯", "1 本")])
        ])
    ],
    externalURL: "http://www.google.com",
    internalURL: "http://www.google.com",
    fontSize: 15
)

let classicHtml = classic.render()
let classicHtmlUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test-classic.html")
try classicHtml.write(to: classicHtmlUrl, atomically: true, encoding: .utf8)

let classicGenerator = PDFGenerator(mainHtml: classic, headerHtml: classic.headerHTML)
let classicPdfUrl = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test-classic.pdf")
if let classicPdfData = try? classicGenerator.generate(sideMargin: 1.2, extraVerticalMargin: 12) {
    try classicPdfData.write(to: classicPdfUrl)
}

//import PDFToImage
//
//let converter = PDFImageConverter()
//let imageDatas = try converter.convert(data: pdfData!)
////let imageData = try converter.convertToData(url: URL(string: "file:///Users/gradyzhuo/test.pdf")!)
//
//let folderURL = FileManager.default.homeDirectoryForCurrentUser.appending(path: "test", directoryHint: .isDirectory)
//for (index,imgData) in imageDatas.enumerated(){
//    let url = folderURL.appending(path: "\(index).jpg")
//    try imgData.write(to: url)
//}
