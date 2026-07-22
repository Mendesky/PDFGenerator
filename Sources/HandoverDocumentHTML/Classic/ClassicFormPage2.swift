//
//  ClassicFormPage2.swift
//  PDFGenerator
//
//  第 2 頁：補充資訊，仿第 1 頁框線表單做法 —— 左側直書區塊標籤 + label/value 網格。
//  以通用 Section / Row 表示，呼叫端把報價、營運、訪談紀錄、關係企業、統購…組成列，
//  視覺與第 1 頁一致（沿用 .classicForm / .sectionLabel / .innerTable 樣式）。
//

import Plot
import QRCodeGenerator

public struct ClassicFormPage2: Component {
    let sections: [Section]
    let externalURL: String?
    let internalURL: String?

    public init(sections: [Section], externalURL: String? = nil, internalURL: String? = nil) {
        self.sections = sections
        self.externalURL = externalURL
        self.internalURL = internalURL
    }

    public var body: any Component {
        ComponentGroup {
            // 標題列：置中標題 ＋ 右上角（外網/內網連結按鈕 + QR）
            Div {
                Div().class("titleSpacer")
                H1("訪談紀錄表（補充資訊）").class("formTitle")
                Div {
                    Div {
                        Div {
                            Span(html: DocumentHeader.linkIconSVG).class("urlIcon")
                            Link("外網連結", url: externalURL ?? "#")
                        }.class("url")
                        Div {
                            Span(html: DocumentHeader.linkIconSVG).class("urlIcon")
                            Link("內網連結", url: internalURL ?? "#")
                        }.class("url")
                    }.class("shareUrlContainer")
                    if let externalURL,
                       let qr = try? QRCode.encode(text: externalURL, ecl: .high) {
                        Span(html: qr.toSVGString(border: 1)).class("qrImage")
                    }
                }.class("classicTopRight")
            }.class("titleRow2")
            // 單一扁平表格（同第 1 頁），框線統一 1px。每個 section 包成獨立 <tbody>，
            // 分頁時以 section 為單位整段移動（break-inside: avoid），不會把區塊直書標籤與首列
            // 孤兒留在上一頁。用 Element 自建 table/tbody，避開 Plot 的 Table 會把每個 child
            // 自動包成 <tr> 的行為（會產生 <tr><tbody>）。
            Element(name: "table") {
                for section in sections {
                    Element(name: "tbody") {
                        flatSection(section)
                    }.class("sectionGroup")
                }
            }.class("classicForm2")
        }
    }

    /// 第一列帶左側直書標籤格（rowspan 跨整個區塊），其餘列只放內容格。
    /// 每個 Row 展開成一或多個 table row（.service 含設定時為 2 列），區塊標籤 rowspan 跨展開後的總列數。
    private func flatSection(_ section: Section) -> Component {
        let groups: [Component] = section.rows.flatMap(cellGroups(for:))
        return ComponentGroup {
            for (index, group) in groups.enumerated() {
                TableRow {
                    if index == 0 {
                        TableCell(ClassicVerticalLabel(text: section.label))
                            .class("sectionLabel")
                            .attribute(named: "rowspan", value: "\(groups.count)")
                    }
                    group
                }
            }
        }
    }

    // 表格邏輯共 5 欄：① 區塊直書標籤 ② 群組/欄位標籤 ③ 內容（服務名/設定/值）④ 每項金額 ⑤ 總價。
    // 非報價列以 colspan 填滿 ③④⑤（或 ②③④⑤），讓各區塊與報價的欄界對齊。
    /// 一個 Row 對應的 table row 內容（不含最左區塊標籤①）。.quoting 會展開成多列。
    private func cellGroups(for row: Row) -> [Component] {
        switch row.kind {
        case .field:
            return [ComponentGroup {
                TableCell(Text(row.label ?? "")).class("fieldLabel")
                multilineCell(row.value).class("fieldValue").attribute(named: "colspan", value: "3")
            }]
        case .markdown:
            // 值為 markdown 原文，渲染成 HTML 後注入（標題/清單/粗體/inline <span> 等）。
            return [ComponentGroup {
                TableCell(Text(row.label ?? "")).class("fieldLabel")
                TableCell(Div(html: MarkdownHTML.render(row.value))).class("fieldValue").attribute(named: "colspan", value: "3")
            }]
        case .heading:
            return [TableCell(Text(row.value)).class("fieldValue rowHeading").attribute(named: "colspan", value: "4")]
        case .full:
            return [multilineCell(row.value).class("fieldValue").attribute(named: "colspan", value: "4")]
        case .pairs:
            // 一列多組 label｜value 內嵌於單一跨欄格（避免增生表格欄、壓縮其他列的值欄）
            return [TableCell {
                for pair in row.pairs {
                    Span(pair.0).class("pairLabel")
                    Span(pair.1).class("pairValue")
                }
            }.class("fieldValue").attribute(named: "colspan", value: "4")]
        case .quoting:
            return quotingCellGroups(row.quoting)
        }
    }

    /// 報價群組（組合項目／服務項目）：
    /// ② 群組標籤、⑤ 總價皆 rowspan 跨整組；每個服務的「服務名(+每項金額④)」為主列，
    /// 設定條列於其下、跨 ③④。有每項金額時服務名佔③、金額佔④；無則服務名跨 ③④。
    private func quotingCellGroups(_ group: QuotingGroup?) -> [Component] {
        guard let group else { return [] }
        let rowCount = group.services.reduce(0) { $0 + 1 + ($1.configs.isEmpty ? 0 : 1) }
        var out: [Component] = []
        for (index, svc) in group.services.enumerated() {
            let isFirst = index == 0
            out.append(ComponentGroup {
                if isFirst {
                    TableCell(Text(group.label)).class("fieldLabel").attribute(named: "rowspan", value: "\(rowCount)")
                }
                if let amount = svc.amount, !amount.isEmpty {
                    multilineCell(svc.name).class("serviceName")
                    TableCell(Text(amount)).class("serviceAmount")
                } else {
                    multilineCell(svc.name).class("serviceName").attribute(named: "colspan", value: "2")
                }
                if isFirst {
                    multilineCell(group.total).class("serviceTotal").attribute(named: "rowspan", value: "\(rowCount)")
                }
            })
            if !svc.configs.isEmpty {
                out.append(multilineCell(svc.configs).class("serviceConfig").attribute(named: "colspan", value: "2"))
            }
        }
        return out
    }

    /// 值可含 \n，逐行以 <br> 斷開。
    private func multilineCell(_ value: String) -> Component {
        let lines = value.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        return TableCell {
            for (index, line) in lines.enumerated() {
                if index < lines.count - 1 {
                    Text(line).addLineBreak()
                } else {
                    Text(line)
                }
            }
        }
    }
}

extension ClassicFormPage2 {
    public struct Section {
        public var label: String
        public var rows: [Row]
        public init(label: String, rows: [Row]) {
            self.label = label
            self.rows = rows
        }
    }

    public struct Row {
        enum Kind { case field, markdown, heading, full, pairs, quoting }
        let kind: Kind
        let label: String?
        let value: String
        let pairs: [(String, String)]
        let quoting: QuotingGroup?

        /// label｜value 一般欄位
        public static func field(_ label: String, _ value: String) -> Row {
            Row(kind: .field, label: label, value: value, pairs: [], quoting: nil)
        }
        /// label｜value，value 以 markdown 渲染（訪談紀錄等富文字欄位）
        public static func markdown(_ label: String, _ value: String) -> Row {
            Row(kind: .markdown, label: label, value: value, pairs: [], quoting: nil)
        }
        /// 粗體跨欄小標（如報價的 bundle 名）
        public static func heading(_ text: String) -> Row {
            Row(kind: .heading, label: nil, value: text, pairs: [], quoting: nil)
        }
        /// 跨欄整段文字
        public static func full(_ value: String) -> Row {
            Row(kind: .full, label: nil, value: value, pairs: [], quoting: nil)
        }
        /// 一列多組 label｜value
        public static func pairs(_ pairs: [(String, String)]) -> Row {
            Row(kind: .pairs, label: nil, value: "", pairs: pairs, quoting: nil)
        }
        /// 報價群組：label＝「組合項目」(多項) 或「服務項目」(單項)；total＝最右側總價（rowspan 跨整組）。
        public static func quoting(_ group: QuotingGroup) -> Row {
            Row(kind: .quoting, label: nil, value: "", pairs: [], quoting: group)
        }
    }

    /// 報價群組：一筆共用報價（pricingDetail）。多服務＝組合項目、單服務＝服務項目。
    public struct QuotingGroup {
        /// 群組標籤：「組合項目」/「服務項目」
        public let label: String
        /// 最右側總價（本組報價金額），可含 \n，e.g. "$279,000 元 / 年"
        public let total: String
        public let services: [QuotingService]
        public init(label: String, total: String, services: [QuotingService]) {
            self.label = label
            self.total = total
            self.services = services
        }
    }

    /// 報價群組內的單一服務。
    public struct QuotingService {
        /// 服務名（如「財務簽證」）
        public let name: String
        /// 每項金額（組合項目拆分用，第④欄）。nil／空字串則服務名跨 ③④、不顯示金額欄。
        public let amount: String?
        /// 設定條列（含「- 」前綴，可 \n 多行），顯示於服務名下方、跨 ③④。空字串則無設定列。
        public let configs: String
        public init(name: String, amount: String? = nil, configs: String = "") {
            self.name = name
            self.amount = amount
            self.configs = configs
        }
    }
}
