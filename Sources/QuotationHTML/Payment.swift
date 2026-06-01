//
//  Payment.swift
//  PDFGenerator
//
//  Created by Grady Zhuo on 2025/4/23.
//
import Plot

public struct Payment: Component {
    public let name: String
    public let items: [PaymentItem]
    public let needShowName: Bool
    /// 酬金補充說明（per-case 註解，例：「*財務簽證依預估資產總額新台幣壹億元報價」）。
    /// **HTML 字串**（非純文字）— render 時前綴單一個 `*`、整段以 raw HTML inject 到 `<td>`，
    /// 不做 HTML escape。caller（OC composer）負責把 markdown + 內嵌 HTML 轉成乾淨 HTML 字串
    /// （含內嵌圖片轉 data URI、template variable 替換等）後才傳入。
    /// `white-space: pre-line` 保留換行；`nil` 或空字串 → 不渲染此 row。
    ///
    /// **語意變更（2026-06）**：原為純文字 `Text()` rendering、escape HTML chars；frontend 引入富文字
    /// 編輯（粗體 / 底線 / 刪除線 / 圖片 / 表格等）後改為 HTML。既有純文字 caller 仍可正常渲染
    /// （無 HTML tag 即等同純文字），但若內含 `<` `>` `&` 等 HTML 字元需 caller 先 escape。
    public let supplementaryNote: String?

    public var body: any Component{
        ComponentGroup{
            if needShowName {
                TableRow{
                    TableCell{
                        Text(name).bold().style("font-size: 1.1em;")
                    }.attribute(named: "colspan", value: "3")
                }
            }
            for (index, item) in items.enumerated(){
                TableRow{
                    TableCell("(\(index+1))").style("vertical-align: top; width: 1.35rem;")
                    item
                }.style("padding-bottom: 0.5em; width: 100%; padding-top: 0.5em;")
            }
            if let supplementaryNote, !supplementaryNote.isEmpty {
                TableRow{
                    TableCell()  // alignment 占位，對齊 (n) 編號欄
                    TableCell(html: "*\(supplementaryNote)")
                        .attribute(named: "colspan", value: "2")
                        .style("white-space: pre-line; padding-top: 0.5em;")
                }
            }
        }
    }

    public init(name: String, items: [PaymentItem], needShowName: Bool = true, supplementaryNote: String? = nil) {
        self.name = name
        self.items = items
        self.needShowName = needShowName
        self.supplementaryNote = supplementaryNote
    }

    package func hideName() -> Self {
        .init(name: name, items: items, needShowName: false, supplementaryNote: supplementaryNote)
    }
}

extension Payment {
    public struct Model {
        public let name: String
        public let items: [PaymentItem.Model]
        public let needShowName: Bool
        public let supplementaryNote: String?

        public init(name: String, items: [PaymentItem.Model], needShowName: Bool, supplementaryNote: String? = nil) {
            self.name = name
            self.items = items
            self.needShowName = needShowName
            self.supplementaryNote = supplementaryNote
        }
    }
}
