//
//  ClassicFormPage1+Model.swift
//  PDFGenerator
//
//  第 1 頁表單資料。選項欄位（行業別/成本分析/申報方式/服務/發票）以
//  「全部選項 + 勾選集合」表示，渲染時逐項判斷 ■/□。無資料來源的欄位傳 nil → 空格。
//

extension ClassicFormPage1 {
    /// 聯絡人（可多位）；Email／手機／市話皆屬聯絡人資訊。
    public struct Contact {
        public var name: String
        public var relationship: String?
        public var phone: String?
        public var mobile: String?
        public var email: String?

        public init(name: String, relationship: String? = nil, phone: String? = nil, mobile: String? = nil, email: String? = nil) {
            self.name = name
            self.relationship = relationship
            self.phone = phone
            self.mobile = mobile
            self.email = email
        }
    }

    public struct Model {
        // 基本資料
        public var contactDate: String?      // 接洽日期（新版無來源 → nil）
        public var confirmDate: String?      // 確定日期＝成交日期
        public var interviewers: String?
        public var companyName: String
        public var representative: String?
        public var contacts: [Contact]       // 聯絡人（可多位，含其 Email／手機／市話）
        public var businessId: String?
        public var revenue: String?
        public var capital: String?          // 資總（實收資本額）
        public var industryCode: String?
        public var registeredPostcode: String?
        public var registeredAddress: String?
        public var communicationPostcode: String?
        public var communicationAddress: String?
        public var products: String?
        public var source: String?
        public var designatedCpa: String?

        // 選項（label + 是否勾選）
        public var industryChoices: [(label: String, checked: Bool)]
        public var costAnalysisChoices: [(label: String, checked: Bool)]
        public var filingChoices: [(label: String, checked: Bool)]
        public var serviceChoices: [(label: String, checked: Bool)]
        public var invoiceChoices: [(label: String, checked: Bool)]

        // 訪談內容摘要
        public var previousFirmServices: String?
        public var previousFirmChangeReason: String?
        public var clientNotesSummary: String?
        public var relatedBusinessSummary: String?

        // 費用摘要
        public var bookkeepingFee: String?
        public var tidyingFee: String?
        public var ctpFee: String?
        public var taxAuditFee: String?
        public var financialAuditFee: String?
        public var individualIncomeTaxFee: String?
        public var payrollFee: String?
        public var cashierFee: String?
        public var nhiFee: String?

        // 備註
        public var serviceGroup: String?
        public var serviceStartDate: String?

        public init(
            contactDate: String? = nil,
            confirmDate: String? = nil,
            interviewers: String? = nil,
            companyName: String,
            representative: String? = nil,
            contacts: [Contact] = [],
            businessId: String? = nil,
            revenue: String? = nil,
            capital: String? = nil,
            industryCode: String? = nil,
            registeredPostcode: String? = nil,
            registeredAddress: String? = nil,
            communicationPostcode: String? = nil,
            communicationAddress: String? = nil,
            products: String? = nil,
            source: String? = nil,
            designatedCpa: String? = nil,
            industryChoices: [(label: String, checked: Bool)] = [],
            costAnalysisChoices: [(label: String, checked: Bool)] = [],
            filingChoices: [(label: String, checked: Bool)] = [],
            serviceChoices: [(label: String, checked: Bool)] = [],
            invoiceChoices: [(label: String, checked: Bool)] = [],
            previousFirmServices: String? = nil,
            previousFirmChangeReason: String? = nil,
            clientNotesSummary: String? = nil,
            relatedBusinessSummary: String? = nil,
            bookkeepingFee: String? = nil,
            tidyingFee: String? = nil,
            ctpFee: String? = nil,
            taxAuditFee: String? = nil,
            financialAuditFee: String? = nil,
            individualIncomeTaxFee: String? = nil,
            payrollFee: String? = nil,
            cashierFee: String? = nil,
            nhiFee: String? = nil,
            serviceGroup: String? = nil,
            serviceStartDate: String? = nil
        ) {
            self.contactDate = contactDate
            self.confirmDate = confirmDate
            self.interviewers = interviewers
            self.companyName = companyName
            self.representative = representative
            self.contacts = contacts
            self.businessId = businessId
            self.revenue = revenue
            self.capital = capital
            self.industryCode = industryCode
            self.registeredPostcode = registeredPostcode
            self.registeredAddress = registeredAddress
            self.communicationPostcode = communicationPostcode
            self.communicationAddress = communicationAddress
            self.products = products
            self.source = source
            self.designatedCpa = designatedCpa
            self.industryChoices = industryChoices
            self.costAnalysisChoices = costAnalysisChoices
            self.filingChoices = filingChoices
            self.serviceChoices = serviceChoices
            self.invoiceChoices = invoiceChoices
            self.previousFirmServices = previousFirmServices
            self.previousFirmChangeReason = previousFirmChangeReason
            self.clientNotesSummary = clientNotesSummary
            self.relatedBusinessSummary = relatedBusinessSummary
            self.bookkeepingFee = bookkeepingFee
            self.tidyingFee = tidyingFee
            self.ctpFee = ctpFee
            self.taxAuditFee = taxAuditFee
            self.financialAuditFee = financialAuditFee
            self.individualIncomeTaxFee = individualIncomeTaxFee
            self.payrollFee = payrollFee
            self.cashierFee = cashierFee
            self.nhiFee = nhiFee
            self.serviceGroup = serviceGroup
            self.serviceStartDate = serviceStartDate
        }
    }
}
