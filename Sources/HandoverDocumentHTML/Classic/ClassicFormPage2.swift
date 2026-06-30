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
            // 單一扁平表格（同第 1 頁），框線統一 1px
            Table {
                for section in sections {
                    flatSection(section)
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

    /// 一個 Row 對應的 table row 內容（不含最左區塊標籤）。多數 1 列；.service 含設定時 2 列。
    private func cellGroups(for row: Row) -> [Component] {
        switch row.kind {
        case .field:
            return [ComponentGroup {
                TableCell(Text(row.label ?? "")).class("fieldLabel")
                multilineCell(row.value).class("fieldValue")
            }]
        case .markdown:
            // 值為 markdown 原文，渲染成 HTML 後注入（標題/清單/粗體/inline <span> 等）。
            return [ComponentGroup {
                TableCell(Text(row.label ?? "")).class("fieldLabel")
                TableCell(Div(html: MarkdownHTML.render(row.value))).class("fieldValue")
            }]
        case .heading:
            return [TableCell(Text(row.value)).class("fieldValue rowHeading").attribute(named: "colspan", value: "2")]
        case .full:
            return [multilineCell(row.value).class("fieldValue").attribute(named: "colspan", value: "2")]
        case .pairs:
            // 一列多組 label｜value 內嵌於單一跨欄格（避免增生表格欄、壓縮其他列的值欄）
            return [TableCell {
                for pair in row.pairs {
                    Span(pair.0).class("pairLabel")
                    Span(pair.1).class("pairValue")
                }
            }.class("fieldValue").attribute(named: "colspan", value: "2")]
        case .service:
            // 服務名(+公費)為主列；設定條列於其下，「服務項目」標籤 rowspan 跨兩列、設定只佔值欄。
            let label = row.label ?? "服務項目"
            if row.detail.isEmpty {
                return [ComponentGroup {
                    TableCell(Text(label)).class("fieldLabel")
                    multilineCell(row.value).class("fieldValue")
                }]
            }
            return [
                ComponentGroup {
                    TableCell(Text(label)).class("fieldLabel").attribute(named: "rowspan", value: "2")
                    multilineCell(row.value).class("fieldValue")
                },
                multilineCell(row.detail).class("fieldValue")
            ]
        }
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
        enum Kind { case field, markdown, heading, full, pairs, service }
        let kind: Kind
        let label: String?
        let value: String
        let detail: String
        let pairs: [(String, String)]

        /// label｜value 一般欄位
        public static func field(_ label: String, _ value: String) -> Row {
            Row(kind: .field, label: label, value: value, detail: "", pairs: [])
        }
        /// label｜value，value 以 markdown 渲染（訪談紀錄等富文字欄位）
        public static func markdown(_ label: String, _ value: String) -> Row {
            Row(kind: .markdown, label: label, value: value, detail: "", pairs: [])
        }
        /// 粗體跨欄小標（如報價的 bundle 名）
        public static func heading(_ text: String) -> Row {
            Row(kind: .heading, label: nil, value: text, detail: "", pairs: [])
        }
        /// 跨欄整段文字
        public static func full(_ value: String) -> Row {
            Row(kind: .full, label: nil, value: value, detail: "", pairs: [])
        }
        /// 一列多組 label｜value
        public static func pairs(_ pairs: [(String, String)]) -> Row {
            Row(kind: .pairs, label: nil, value: "", detail: "", pairs: pairs)
        }
        /// 報價服務項目：服務名(+公費)為主列；configs（設定，可含 \n 條列）顯示於其下，
        /// 「服務項目」標籤 rowspan 跨兩列、設定只佔值欄。configs 空字串則只有一列。
        public static func service(name: String, configs: String) -> Row {
            Row(kind: .service, label: "服務項目", value: name, detail: configs, pairs: [])
        }
    }
}
