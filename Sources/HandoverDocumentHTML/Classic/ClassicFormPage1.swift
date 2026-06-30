//
//  ClassicFormPage1.swift
//  PDFGenerator
//
//  第 1 頁：復刻舊版「新客戶訪談記錄表」單頁框線表單。
//  版型＝整頁黑框表格，左側直書區塊標籤（基本資料 / 訪談內容 / 服務 / 費用 / 備註），
//  右側為「灰底標籤格 + 內容格」緊湊網格；選項欄位用 ■/□。
//  舊版有但新版無資料來源的欄位（接洽日期、LINE 群組…）保留空格。
//

import Plot

public struct ClassicFormPage1: Component {
    let model: Model

    public init(model: Model) {
        self.model = model
    }

    public var body: any Component {
        ComponentGroup {
            // 標題列：置中標題（事務所 logo 改由每頁固定 running header 呈現，見 LogoHeader）
            Div(H1("新客戶訪談記錄表").class("formTitle")).class("titleRow")

            // 單一扁平表格：全部框線出自同一 border-collapse，粗細一致（不用巢狀表格）
            Table {
                flatSection(label: "基本資料", rows: basicInfoRows)
                flatSection(label: "訪談內容", rows: [[fullCell(interviewBlock)]])
                flatSection(label: "服務", rows: [[fullCell(serviceBlock)]])
                flatSection(label: "費用", rows: feeRows)
                flatSection(label: "備註", rows: [[fullCell(remarkBlock)]])
            }.class("classicForm")
        }
    }

    // MARK: 基本資料（6 欄密集網格：短資料一列三格）

    private var basicInfoRows: [[Component]] {
        [
            // 第一列建立 6 欄（label,value × 3）
            [labelCell("接洽日期"), valueCell(model.contactDate),
             labelCell("確定日期"), valueCell(model.confirmDate),
             labelCell("訪 談 人"), valueCell(model.interviewers)],
            [labelCell("公司名稱"), valueCell(model.companyName, colspan: 3),
             labelCell("負 責 人"), valueCell(model.representative)],
            [labelCell("統一編號"), valueCell(model.businessId),
             labelCell("營業額"), valueCell(model.revenue),
             labelCell("資　總"), valueCell(model.capital)],
            [labelCell("行業代號"), valueCell(model.industryCode),
             labelCell("行 業 別"), checkboxCell(model.industryChoices, colspan: 3)],
            [labelCell("成本分析"), checkboxCell(model.costAnalysisChoices, colspan: 2),
             labelCell("申報方式"), checkboxCell(model.filingChoices, colspan: 2)],
            [labelCell("登記地址"), valueCell(joinAddress(model.registeredPostcode, model.registeredAddress), colspan: 5)],
            [labelCell("通訊地址"), valueCell(joinAddress(model.communicationPostcode, model.communicationAddress), colspan: 5)],
            [labelCell("營業項目及產品"), valueCell(model.products, colspan: 5)],
            [labelCell("來　源"), valueCell(model.source, colspan: 5)],
            [labelCell("指定簽證之會計師"), valueCell(model.designatedCpa, colspan: 5)],
            [labelCell("聯絡人"), cell(contactsBlock, class: "fieldValue", colspan: 5)],
        ]
    }

    // 聯絡人（可多位）：每位一列，含稱謂與市話/手機/Email
    private var contactsBlock: Component {
        Div {
            if model.contacts.isEmpty {
                Paragraph("")
            } else {
                for contact in model.contacts {
                    Div {
                        Div {
                            Span(contact.name).class("contactName")
                            if let rel = contact.relationship, !rel.isEmpty {
                                Span("（\(rel)）").class("contactRel")
                            }
                        }.class("contactNameLine")
                        for (label, value) in contactMethods(contact) {
                            Div("\(label)　\(value)").class("contactMethod")
                        }
                    }.class("contactLine")
                }
            }
        }.class("contactBlock")
    }

    private func contactMethods(_ c: Contact) -> [(String, String)] {
        var out: [(String, String)] = []
        if let p = c.phone, !p.isEmpty { out.append(("市話", p)) }
        if let m = c.mobile, !m.isEmpty { out.append(("手機", m)) }
        if let e = c.email, !e.isEmpty { out.append(("Email", e)) }
        return out
    }

    // MARK: 訪談內容（第 1 頁僅放短摘要，完整長文於第 2 頁）

    private var interviewBlock: Component {
        Div {
            Paragraph("1. 前所服務業務：\(model.previousFirmServices ?? "")")
            Paragraph("2. 前所資訊及更換原因：\(model.previousFirmChangeReason ?? "")")
            Paragraph("3. 客戶狀況及注意事項：\(model.clientNotesSummary ?? "")")
            Paragraph("關係企業：\(model.relatedBusinessSummary ?? "")")
        }.class("interviewBlock")
    }

    // MARK: 服務（由報價推導勾選）

    private var serviceBlock: Component {
        Div { ClassicCheckboxGroup(items: model.serviceChoices) }.class("serviceBlock")
    }

    // MARK: 費用（摘要；完整報價明細於第 2 頁）

    private var feeRows: [[Component]] {
        [
            [labelCell("記帳費"), valueCell(model.bookkeepingFee, colspan: 2),
             labelCell("整帳費"), valueCell(model.tidyingFee, colspan: 2)],
            [labelCell("年度CTP"), valueCell(model.ctpFee, colspan: 2),
             labelCell("稅簽/年"), valueCell(model.taxAuditFee, colspan: 2)],
            [labelCell("財簽/年"), valueCell(model.financialAuditFee, colspan: 2),
             labelCell("綜所/人"), valueCell(model.individualIncomeTaxFee, colspan: 2)],
            [labelCell("薪資人力"), valueCell(model.payrollFee, colspan: 2),
             labelCell("出納"), valueCell(model.cashierFee, colspan: 2)],
            [labelCell("二代健保"), valueCell(model.nhiFee, colspan: 5)],
        ]
    }

    // MARK: 備註

    private var remarkBlock: Component {
        Div {
            Paragraph("服務組別：\(model.serviceGroup ?? "")")
            Div {
                Span("發票明細：")
                ClassicCheckboxGroup(items: model.invoiceChoices)
            }.class("invoiceLine")
            Paragraph("開始服務時間：\(model.serviceStartDate ?? "")")
        }.class("remarkBlock")
    }

    // MARK: helpers

    /// 一個區塊：第一列帶左側直書標籤格（rowspan 跨整個區塊），其餘列只放內容格。
    private func flatSection(label: String, rows: [[Component]]) -> Component {
        ComponentGroup {
            for (index, cells) in rows.enumerated() {
                TableRow {
                    if index == 0 {
                        TableCell(ClassicVerticalLabel(text: label))
                            .class("sectionLabel")
                            .attribute(named: "rowspan", value: "\(rows.count)")
                    }
                    for c in cells { c }
                }
            }
        }
    }

    private func labelCell(_ text: String) -> Component {
        TableCell(Text(text)).class("fieldLabel")
    }

    private func valueCell(_ text: String?, colspan: Int = 1) -> Component {
        cell(Text(text ?? ""), class: "fieldValue", colspan: colspan)
    }

    private func checkboxCell(_ items: [(label: String, checked: Bool)], colspan: Int = 1) -> Component {
        cell(ClassicCheckboxGroup(items: items), class: "fieldValue", colspan: colspan)
    }

    /// 跨整列（6 欄）的內容格，給訪談內容/服務/備註的純文字區塊用。
    private func fullCell(_ content: Component) -> Component {
        cell(content, class: "blockCell", colspan: 6)
    }

    private func cell(_ content: Component, class className: String, colspan: Int) -> Component {
        if colspan > 1 {
            return TableCell(content).class(className).attribute(named: "colspan", value: "\(colspan)")
        }
        return TableCell(content).class(className)
    }

    private func joinAddress(_ postcode: String?, _ address: String?) -> String? {
        let parts = [postcode, address].compactMap { $0 }.filter { !$0.isEmpty }
        return parts.isEmpty ? nil : parts.joined(separator: " ")
    }
}
